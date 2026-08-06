import 'package:flutter/material.dart';
import './screens/welcome_screen.dart';

class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionState();
}

class _TermsConditionState extends State<TermsConditionsScreen> {
  void _accept() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  void _decline() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF004987),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 60, 25, 60),
          child: Container(
            height: 600,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFFFFFFFF),
            ),
            padding: EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/terms_docs.png',
                      height: 42,
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Terms and Conditions',
                          style: TextStyle(
                            color: Color(0xFF001D36),
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Last updated April 2017',
                          style: TextStyle(
                            color: Color(0xFF65727B),
                            fontSize: 12,
                          ),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. Terms',
                      style: TextStyle(
                        color: Color(0xFF001526),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Terms and Conditions agreements act as a legal contract between you (the company) who has the website or mobile app and the user who access your website and mobile app.",
                      style: TextStyle(
                        color: Color(0xFF65727B),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Having a Terms and Conditions agreement is completely optional. No laws require you to have one. Not even the super-strict and wide-reaching General Data Protection Regulation (GDPR).",
                      style: TextStyle(
                        color: Color(0xFF65727B),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "It's up to you to set the rules and guidelines that the user must agree to. You can think of your Terms and Conditions agreement as the legal agreement where you maintain your rights to exclude users from your app in the event that they abuse your app, where you maintain your legal rights against potential app abusers, and so on.",
                      style: TextStyle(
                        color: Color(0xFF65727B),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.justify,
                    ),

                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 136,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Color(0xFFE4ECF2),
                        borderRadius:BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: _decline,
                        child: Text(
                          'Decline',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF001526),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 136,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Color(0xFF004987),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: _accept,
                        child: Text(
                          'Accept',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
                // const SizedBox(
                //   height: 1,
                //   width: double.infinity,
                //   child: DecoratedBox(
                //       decoration: BoxDecoration(
                //         color: Color(0xFFE3E3E3)
                //       )
                //   ),
                // ),
              ],
            ),
          ),
        )
      ),
    );
  }
}