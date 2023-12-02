import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simulator_of_trading/page/main/main_page.dart';
import 'package:simulator_of_trading/page/settings/settings_widget.dart';
import 'package:svg_flutter/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String urlToShare = 'com.craftholic.simulatoroftrading';
  final Uri urlSupport = Uri.parse(
    'https://docs.google.com/forms/d/e/1FAIpQLSfwfo0dTc3fVmuUu3Gxv_99eyl9jt2s5ru72hcgyNiv3Ij2hw/viewform?usp=sf_link',
  );
  final Uri urlTeam = Uri.parse(
    'https://docs.google.com/document/d/10uCK4TF5nTEhdpM5YpgLvgc-24D7EPBe8NMaPt6C0Pc/edit?usp=sharing',
  );
  final Uri urlPrivacy = Uri.parse(
    'https://docs.google.com/document/d/1EfxYR1jqvyR6acmMqey9EpyOxxr56NLvVrFO5DEq96Y/edit?usp=sharing',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  InkWell(
                    autofocus: true,
                    child: SvgPicture.asset(
                      'assets/images/svg/home.svg',
                      width: 28,
                      height: 28,
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainPage(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xff0A1730),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomButtonSettings(
              onPressed: () {
                _launchUrl(urlPrivacy);
              },
              settingsImage: 'assets/images/svg/privacy.svg',
              settingsText: 'Privacy Policy',
            ),
            CustomButtonSettings(
              onPressed: () {
                _launchUrl(urlTeam);
              },
              settingsImage: 'assets/images/svg/paper.svg',
              settingsText: 'Terms of Use',
            ),
            CustomButtonSettings(
              onPressed: () {
                _launchUrl(urlSupport);
              },
              settingsImage: 'assets/images/svg/phone.svg',
              settingsText: 'Support',
            ),
            CustomButtonSettings(
              settingsImage: 'assets/images/svg/share.svg',
              settingsText: 'Share',
              onPressed: () async {
                await Share.share(
                  '$urlToShare',
                  subject: 'Поделиться ссылкой',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(_url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}
