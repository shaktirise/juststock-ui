// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crowwn/config/common.dart';
import '../Dark mode.dart';

class Policy extends StatefulWidget {
  const Policy({super.key});

  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
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
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/images/arrow-narrow-left (1).png",scale: 3,color: notifier.textColor,)),
        actions: [
          Icon(Icons.menu, size: 25, color: notifier.textColor),
          const SizedBox(width: 20,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppConstants.Height(30),
              /*Text(
                "Privacy Policy",
                style: TextStyle(
                    color: notifier.textColor,
                    fontSize: 33,
                    fontFamily: "Manrope-Bold"),
              ),
              AppConstants.Height(10),
              // New Privacy Policy content (replacing legacy text below)
              _para(
                notifier,
                'Welcome to Just Stock Education App ("we", "our", "us"). We respect your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, and safeguard your data when you use our mobile application, website, and related services (collectively referred to as the "App").',
              ),*/
              AppConstants.Height(20),
              _h('1. Information We Collect', notifier),
              _para(
                notifier,
                'We collect limited data necessary to improve user experience and provide educational content effectively.',
              ),
              _subh('a. Information You Provide', notifier),
              _bullets([
                'Account Information: When you register, we may collect your name, email address, and password.',
                'Feedback & Support Requests: Any messages, queries, or feedback you share with us.',
                'Course or Subscription Data: Details related to the courses or educational materials you enroll in.',
              ], notifier),
              _subh('b. Automatically Collected Information', notifier),
              _bullets([
                'Usage Data: App performance, features used, time spent, and learning progress.',
                'Device Data: Device type, operating system, IP address, and app version for analytics and troubleshooting.',
                'Cookies and Analytics: We may use cookies or analytics tools to understand user interaction and improve our services.',
              ], notifier),
              AppConstants.Height(20),
              _h('2. How We Use Your Information', notifier),
              _bullets([
                'Provide access to educational materials and app features.',
                'Improve the quality, design, and functionality of the app.',
                'Send important updates, notifications, or service-related emails.',
                'Respond to your queries and provide support.',
                'Analyze app usage trends to enhance user experience.',
                'We do not sell or share your personal data with third parties for marketing purposes.',
              ], notifier),
              AppConstants.Height(20),
              _h('3. Data Sharing and Disclosure', notifier),
              _bullets([
                'Service Providers: With trusted vendors who assist in app hosting, analytics, or communication—bound by strict confidentiality agreements.',
                'Legal Requirements: If required by law, regulation, or court order.',
                'Business Transfers: In case of merger, acquisition, or sale of assets, your information may be transferred under confidentiality obligations.',
              ], notifier),
              AppConstants.Height(20),
              _h('4. Data Retention', notifier),
              _para(
                notifier,
                'We retain your personal data only for as long as necessary to fulfill the purposes outlined in this policy, or as required by law. You can request deletion of your account or data anytime by contacting us at [Insert Email Address].',
              ),
              AppConstants.Height(20),
              _h('5. Security of Your Data', notifier),
              _para(
                notifier,
                'We implement industry-standard measures such as encryption, secure servers, and limited access controls to protect your personal information. However, no electronic storage or transmission method is completely secure — use the app at your discretion.',
              ),
              AppConstants.Height(20),
              _h('6. Your Rights and Choices', notifier),
              _bullets([
                'Access or correct your personal data.',
                'Request deletion of your data.',
                'Withdraw consent for data processing.',
              ], notifier),
              _para(
                notifier,
                'You can exercise these rights by emailing us at [Insert Email Address].',
              ),
              AppConstants.Height(20),
              _h('7. Children’s Privacy', notifier),
              _para(
                notifier,
                'Our app is intended for users aged 16 and above. We do not knowingly collect data from children under 16. If you believe a child has provided us information, please contact us immediately to remove it.',
              ),
              AppConstants.Height(20),
              _h('8. Third-Party Links and Services', notifier),
              _para(
                notifier,
                'Our educational materials may include references or links to third-party websites or platforms (e.g., YouTube, stock APIs, etc.). We are not responsible for their privacy practices. Please review their policies before interacting with them.',
              ),
              AppConstants.Height(20),
              _h('9. Updates to This Privacy Policy', notifier),
              _para(
                notifier,
                'We may update this Privacy Policy periodically. Changes will be reflected with a new “Last Updated” date at the top. We encourage you to review this page regularly to stay informed.',
              ),
              AppConstants.Height(20),
              _h('10. Contact Us', notifier),
              _para(
                notifier,
                'If you have any questions or concerns about this Privacy Policy or our data practices, please contact us at:',
              ),
              _para(
                notifier,
                'Just Stock Education App',
              ),
              // Removed: Last updated banner
              /*
              Text(
                "The protection and confidentiality of your personal information is very important to us. Therefore, Financial Company with the website financial.com and the Financial mobile application (hereinafter referred to as “Financial”) set the privacy policy as follows:",
                style: TextStyle(
                    fontFamily: "Manrope-Regular",
                    fontSize: 14,
                    color: notifier.tabBarText2),
              ),
              AppConstants.Height(20),
              Text(
                "Our Commitment",
                style: TextStyle(
                    color: notifier.textColor,
                    fontSize: 18,
                    fontFamily: "Manrope-Bold"),
              ),
              AppConstants.Height(10),
              Text(
                "We collect and use your personal information in accordance with the relevant provisions of the personal data protection law. This privacy policy describes the collection, use, storage and protection of your personal information. This applies to applications, all websites, sites and related services of the Financial regardless of how you access or use it.",
                style: TextStyle(
                    fontFamily: "Manrope-regular",
                    fontSize: 14,
                    color: notifier.tabBarText2),
              ),
              AppConstants.Height(20),
              Text(
                "Scope and Approval",
                style: TextStyle(
                    color: notifier.textColor,
                    fontSize: 18,
                    fontFamily: "Manrope-Bold"),
              ),
              AppConstants.Height(10),
              Text(
                "You accept this privacy policy when you register, access, or use our products, services, content, features, technology or functions offered on the application, all websites, sites and related services (collectively called “Financial Services”). We can upload policy changes on this page periodically, the revised version will take effect on the effective date of publication. You are responsible for reviewing this privacy policy as often as possible.",
                style: TextStyle(
                    fontFamily: "Manrope-regular",
                    fontSize: 14,
                    color: notifier.tabBarText2),
              ),
              */
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
