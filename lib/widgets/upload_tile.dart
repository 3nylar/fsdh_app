import 'package:flutter/material.dart';

import '../models/onboarding_data.dart';
import '../theme/app_colors.dart';
import 'common.dart';

/// Dashed-border upload target. Renders three states drawn in the
/// mockups: idle (cloud icon + helper text), uploading (progress bar on
/// a bare tile) and done (filled tile with a check).
class UploadTile extends StatelessWidget {
  const UploadTile({
    super.key,
    required this.slot,
    required this.onTap,
    this.height = 132,
  });

  final UploadSlot slot;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(slot.label, required: slot.required),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: slot.status == UploadStatus.uploading ? null : onTap,
          child: CustomPaint(
            painter: _DashedBorderPainter(
              color: slot.status == UploadStatus.failed
                  ? AppColors.error
                  : AppColors.accent,
            ),
            child: Container(
              height: height,
              width: double.infinity,
              decoration: BoxDecoration(
                color: slot.isDone ? AppColors.tooltip : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(child: _body()),
            ),
          ),
        ),
        if (slot.errorMessage != null) ...[
          const SizedBox(height: 6),
          Text(
            slot.errorMessage!,
            style: const TextStyle(color: AppColors.error, fontSize: 11.5),
          ),
        ],
      ],
    );
  }

  Widget _body() {
    switch (slot.status) {
      case UploadStatus.uploading:
        return ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: slot.progress,
            minHeight: 5,
            backgroundColor: const Color(0xFF9DBBD4),
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        );

      case UploadStatus.done:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Uploaded\nsuccessfully',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.35,
                color: AppColors.heading,
              ),
            ),
            SizedBox(height: 10),
            CircleAvatar(
              radius: 12,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.check, size: 15, color: Colors.white),
            ),
          ],
        );

      case UploadStatus.failed:
      case UploadStatus.idle:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_upload_outlined,
                size: 30, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              slot.helperText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.5,
                height: 1.35,
                color: AppColors.heading,
              ),
            ),
          ],
        );
    }
  }
}

/// Flutter has no dashed border out of the box, so the outline is drawn
/// by hand: walk each edge with a path metric and stroke alternating
/// segments.
class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    this.dash = 5,
    this.gap = 4,
    this.radius = 4,
  });

  final Color color;
  final double dash;
  final double gap;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dash;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}
