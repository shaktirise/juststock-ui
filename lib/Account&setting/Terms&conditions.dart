// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:juststock/config/common.dart';

import '../Dark mode.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  ColorNotifire notifier = ColorNotifire();

  @override
  Widget build(BuildContext context) {
    notifier = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      backgroundColor: notifier.background,
      appBar: AppBar(
        backgroundColor: notifier.background,
        elevation: 0.9,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Image.asset(
            'assets/images/arrow-narrow-left (1).png',
            scale: 3,
            color: notifier.textColor,
          ),
        ),
        actions: [
          Icon(Icons.menu, size: 25, color: notifier.textColor),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(30),
              Text(
                'Terms & Conditions',
                style: TextStyle(
                  color: notifier.textColor,
                  fontSize: 28,
                  fontFamily: 'Manrope-Bold',
                ),
              ),
              AppConstants.Height(12),
              _para(
                notifier,
                'Welcome to Just Stock Education App ("we", "our", "us"). By accessing or using our mobile application, website, or related services (collectively, the "App"), you agree to be bound by these Terms and Conditions ("Terms"). If you do not agree, please do not use the App.',
              ),
              AppConstants.Height(18),
              // REPLACED TERMS START (legacy content kept for reference)
              _h('1. Acceptance of Terms', notifier),
              _bullets([
                'You are at least 18 years of age, or have parental consent if between 16–18.',
                'You have read, understood, and agreed to be legally bound by these Terms.',
                'These Terms govern your use of all educational services, materials, and content provided by the App.',
              ], notifier),
              AppConstants.Height(18),
              _h('2. Nature of Service', notifier),
              _para(
                notifier,
                'Just Stock Education App is an educational platform that provides learning materials, tutorials, and informational resources about stock markets, investing principles, and financial literacy.',
              ),
              _subh('Disclaimer', notifier),
              _bullets([
                'We do not provide investment advice, stock recommendations, or financial consultancy.',
                'All information on the App is for educational and informational purposes only.',
                'Any financial decisions you make are solely your responsibility.',
              ], notifier),
              AppConstants.Height(18),
              _h('3. Account Registration', notifier),
              _bullets([
                'To access certain features, you may need to create an account by providing accurate and complete information.',
                'You are responsible for maintaining the confidentiality of your login credentials.',
                'Notify us immediately in case of any unauthorized access or breach of security.',
                'We may suspend or terminate any account found in violation of these Terms.',
              ], notifier),
              AppConstants.Height(18),
              _h('4. Use of the App', notifier),
              _para(
                notifier,
                'You agree to use the App only for lawful, educational, and non-commercial purposes. You must not:',
              ),
              _bullets([
                'Copy, reproduce, or distribute educational materials without permission.',
                'Attempt to hack, disrupt, or reverse‑engineer the App.',
                'Upload or share any content that is offensive, illegal, or violates intellectual property rights.',
              ], notifier),
              _para(
                notifier,
                'We reserve the right to restrict or terminate access to users who misuse the platform.',
              ),
              AppConstants.Height(18),
              _h('5. Intellectual Property Rights', notifier),
              _para(
                notifier,
                'All content available on the App—including text, videos, graphics, logos, icons, and design—is the intellectual property of Just Stock Education App or its content partners.',
              ),
              _bullets([
                'You are granted a limited, non-transferable license to access and use the materials for personal learning only.',
                'You may not reproduce, sell, or exploit any part of the App or its content for commercial purposes without prior written permission.',
              ], notifier),
              AppConstants.Height(18),
              _h('6. Payment and Subscriptions (If Applicable)', notifier),
              _bullets([
                'All fees are displayed clearly before purchase.',
                'Payments are processed securely via authorized payment gateways.',
                'Subscription fees are non‑refundable unless stated otherwise under our Refund Policy.',
                'We may change pricing or content access plans with prior notice.',
              ], notifier),
              AppConstants.Height(18),
              _h('7. Limitation of Liability', notifier),
              _bullets([
                'To the maximum extent permitted by law, we are not liable for any direct, indirect, incidental, or consequential damages arising from your use of the App.',
                'We make no warranties or guarantees regarding the accuracy, completeness, or reliability of educational content.',
                'You use the App at your own discretion and risk.',
              ], notifier),
              AppConstants.Height(18),
              _h('8. Third‑Party Services', notifier),
              _para(
                notifier,
                'The App may include links or integrations with third‑party platforms (e.g., YouTube, analytics tools, or APIs). We are not responsible for the content, privacy practices, or reliability of these third parties. Your interaction with them is governed by their respective terms.',
              ),
              AppConstants.Height(18),
              _h('9. Termination', notifier),
              _para(
                notifier,
                'We may suspend or terminate your access to the App at any time, without prior notice, if:',
              ),
              _bullets([
                'You violate these Terms.',
                'You engage in unauthorized activities.',
                'You cause harm to the App or its users.',
              ], notifier),
              _para(
                notifier,
                'Upon termination, your access and license to use the App will immediately cease.',
              ),
              AppConstants.Height(18),
              _h('10. Privacy', notifier),
              _para(
                notifier,
                'Your privacy is important to us. Please refer to our Privacy Policy to understand how we collect, use, and protect your data.',
              ),
              AppConstants.Height(18),
              _h('11. Governing Law', notifier),
              _para(
                notifier,
                'These Terms are governed by and construed in accordance with the laws of India, without regard to conflict of law principles. Any disputes shall be subject to the exclusive jurisdiction of the courts of [Insert City/State, e.g., Mumbai, Maharashtra].',
              ),
              AppConstants.Height(18),
              _h('12. Changes to Terms', notifier),
              _para(
                notifier,
                'We may modify these Terms periodically to reflect updates in our practices or for legal reasons. Changes will be effective immediately upon posting. You are encouraged to review this page regularly to stay informed.',
              ),
              AppConstants.Height(18),
              _h('13. Contact Us', notifier),
              _para(
                notifier,
                'If you have any questions or concerns about these Terms, please contact us at:\nEmail: [your email]\nWebsite: https://juststock.in',
              ),
              AppConstants.Height(24),


              // New Terms and Conditions (clean text)
              _h('1. Acceptance of Terms', notifier),
              _bullets([
                'You are at least 18 years of age, or have parental consent if between 16–18.',
                'You have read, understood, and agreed to be legally bound by these Terms.',
                'These Terms govern your use of all educational services, materials, and content provided by the App.',
              ], notifier),
              AppConstants.Height(18),
              _h('2. Nature of Service', notifier),
              _para(
                notifier,
                'Just Stock Education App is an educational platform that provides learning materials, tutorials, and informational resources about stock markets, investing principles, and financial literacy.',
              ),
              _subh('Disclaimer', notifier),
              _bullets([
                'We do not provide investment advice, stock recommendations, or financial consultancy.',
                'All information on the App is for educational and informational purposes only.',
                'Any financial decisions you make are solely your responsibility.',
              ], notifier),
              AppConstants.Height(18),
              _h('3. Account Registration', notifier),
              _bullets([
                'To access certain features, you may need to create an account by providing accurate and complete information.',
                'You are responsible for maintaining the confidentiality of your login credentials.',
                'You agree to notify us immediately in case of any unauthorized access or breach of security.',
                'We reserve the right to suspend or terminate any account found in violation of these Terms.',
              ], notifier),
              AppConstants.Height(18),
              _h('4. Use of the App', notifier),
              _para(
                notifier,
                'You agree to use the App only for lawful, educational, and non-commercial purposes. You must not:',
              ),
              _bullets([
                'Copy, reproduce, or distribute educational materials without permission.',
                'Attempt to hack, disrupt, or reverse‑engineer the App.',
                'Upload or share any content that is offensive, illegal, or violates intellectual property rights.',
              ], notifier),
              _para(
                notifier,
                'We reserve the right to restrict or terminate access to users who misuse the platform.',
              ),
              AppConstants.Height(18),
              _h('5. Intellectual Property Rights', notifier),
              _para(
                notifier,
                'All content available on the App—including text, videos, graphics, logos, icons, and design—is the intellectual property of Just Stock Education App or its content partners.',
              ),
              _bullets([
                'You are granted a limited, non-transferable license to access and use the materials for personal learning only.',
                'You may not reproduce, sell, or exploit any part of the App or its content for commercial purposes without prior written permission.',
              ], notifier),
              AppConstants.Height(18),
              _h('6. Payment and Subscriptions (If Applicable)', notifier),
              _bullets([
                'All fees are displayed clearly before purchase.',
                'Payments are processed securely via authorized payment gateways.',
                'Subscription fees are non-refundable unless stated otherwise under our Refund Policy.',
                'We may change pricing or content access plans with prior notice.',
              ], notifier),
              AppConstants.Height(18),
              _h('7. Limitation of Liability', notifier),
              _bullets([
                'To the maximum extent permitted by law, we are not liable for any direct, indirect, incidental, or consequential damages arising from your use of the App.',
                'We make no warranties or guarantees regarding the accuracy, completeness, or reliability of educational content.',
                'You use the App at your own discretion and risk.',
              ], notifier),
              AppConstants.Height(18),
              _h('8. Third-Party Services', notifier),
              _para(
                notifier,
                'The App may include links or integrations with third-party platforms (e.g., YouTube, analytics tools, or APIs). We are not responsible for the content, privacy practices, or reliability of these third parties. Your interaction with them is governed by their respective terms.',
              ),
              AppConstants.Height(18),
              _h('9. Termination', notifier),
              _para(
                notifier,
                'We reserve the right to suspend or terminate your access to the App at any time, without prior notice, if:',
              ),
              _bullets([
                'You violate these Terms,',
                'Engage in unauthorized activities, or',
                'Cause harm to the App or its users.',
              ], notifier),
              _para(
                notifier,
                'Upon termination, your access and license to use the App will immediately cease.',
              ),
              AppConstants.Height(18),
              _h('10. Privacy', notifier),
              _para(
                notifier,
                'Your privacy is important to us. Please refer to our Privacy Policy to understand how we collect, use, and protect your data.',
              ),
              AppConstants.Height(18),
              _h('11. Governing Law', notifier),
              _para(
                notifier,
                'These Terms are governed by and construed in accordance with the laws of India, without regard to conflict of law principles. Any disputes shall be subject to the exclusive jurisdiction of the courts of [Insert City/State, e.g., Mumbai, Maharashtra].',
              ),
              AppConstants.Height(18),
              _h('12. Changes to Terms', notifier),
              _para(
                notifier,
                'We may modify these Terms periodically to reflect updates in our practices or for legal reasons. Changes will be effective immediately upon posting. You are encouraged to review this page regularly to stay informed.',
              ),
              AppConstants.Height(18),
              _h('13. Contact Us', notifier),
              _para(
                notifier,
                'If you have any questions or concerns about these Terms, please contact us at:',
              ),
              _para(
                notifier,
                'Just Stock Education App',
              ),
              AppConstants.Height(24),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _h(String title, ColorNotifire n) => Text(
      title,
      style: TextStyle(color: n.textColor, fontSize: 18, fontFamily: 'Manrope-Bold'),
    );

Widget _subh(String title, ColorNotifire n) => Text(
      title,
      style: TextStyle(color: n.textColor, fontSize: 16, fontFamily: 'Manrope-Bold'),
    );

Widget _para(ColorNotifire n, String text) => Text(
      text,
      style: TextStyle(color: n.tabBarText2, fontSize: 14, fontFamily: 'Manrope-Regular'),
    );

Widget _bullets(List<String> items, ColorNotifire n) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6, right: 8),
                      child: Icon(Icons.circle, size: 8, color: Color(0xFF94A3B8)),
                    ),
                    Expanded(child: _para(n, e)),
                  ],
                ),
              ))
          .toList(),
    );

