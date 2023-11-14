import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simulator_of_trading/page/main/main_page.dart';
import 'package:simulator_of_trading/page/settings/settings_widget.dart';
import 'package:svg_flutter/svg.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String urlToShare = 'http://example.com';

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
        toolbarHeight: 72,
        backgroundColor: const Color(0xff0A1730),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomButtonSettings(
              settingsImage: 'assets/images/svg/privacy.svg',
              settingsText: 'Privacy Policy',
            ),
            CustomButtonSettings(
              settingsImage: 'assets/images/svg/paper.svg',
              settingsText: 'Terms of Use',
            ),
            CustomButtonSettings(
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
}
