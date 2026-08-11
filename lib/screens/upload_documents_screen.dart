import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/onboarding_data.dart';
import '../state/onboarding_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/upload_tile.dart';
import 'add_bvn_screen.dart';

class UploadDocumentsScreen extends StatefulWidget {
  const UploadDocumentsScreen({super.key});

  @override
  State<UploadDocumentsScreen> createState() => _UploadDocumentsScreenState();
}

class _UploadDocumentsScreenState extends State<UploadDocumentsScreen> {
  final _picker = ImagePicker();

  Future<void> _choose(int index) async {
    final controller = context.read<OnboardingController>();
    final slot = controller.slots[index];

    if (slot.isDone) {
      final replace = await _confirmReplace(slot.label);
      if (replace != true) return;
      controller.resetSlot(index);
    }

    final source = await _pickSource();
    if (source == null || !mounted) return;

    final file = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (file == null || !mounted) return;

    await controller.uploadSlot(index, file.path);
  }

  Future<ImageSource?> _pickSource() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined,
                  color: AppColors.primary),
              title: const Text('Take a photo'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined,
                  color: AppColors.primary),
              title: const Text('Choose from gallery'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<bool?> _confirmReplace(String label) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Replace $label?'),
        content: const Text('The file you already uploaded will be discarded.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Replace'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<OnboardingController>();
    final slots = controller.slots;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        top: false,
        child: ListView(
          padding: AppTheme.pagePadding.copyWith(bottom: 32),
          children: [
            const ScreenTitle(
              'Upload your Picture',
              subtitle:
                  'Welcome, please provide us with the following information.',
            ),
            const SizedBox(height: 28),

            // The photo sits alone on the first row at roughly half
            // width, with ID and signature paired beneath it.
            Row(
              children: [
                Expanded(
                  child: UploadTile(
                    slot: slots[0],
                    onTap: () => _choose(0),
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: UploadTile(slot: slots[1], onTap: () => _choose(1)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: UploadTile(slot: slots[2], onTap: () => _choose(2)),
                ),
              ],
            ),

            const SizedBox(height: 48),
            PrimaryButton(
              label: 'Next',
              busy: slots.any((s) => s.status == UploadStatus.uploading),
              onPressed: controller.uploadsSatisfied
                  ? () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => const AddBvnScreen()),
                      )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
