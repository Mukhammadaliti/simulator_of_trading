import 'package:flutter/material.dart';
import 'package:simulator_of_trading/page/background/background.dart';
import 'package:simulator_of_trading/page/main/main_widget.dart';
import 'package:simulator_of_trading/page/settings/setting_page.dart';
import 'package:simulator_of_trading/page/trade/tradeng.dart';
import 'package:svg_flutter/svg.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/png/splash.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/images/svg/chart.svg'),
                    const SizedBox(
                      width: 24,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TRADING\nSIMULATOR',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 27,
                            fontFamily: 'SFProDisplay',
                            fontWeight: FontWeight.w700,
                            height: 0,
                            letterSpacing: 0.54,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          'Learn by playing',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'SFProText',
                            fontWeight: FontWeight.w500,
                            height: 0,
                            letterSpacing: 0.30,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 104,
                ),
                Column(
                  children: [
                    CustomButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Tradeng(),
                            ),
                            (route) => false);
                      },
                      text: 'Trade',
                      clip: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(1.00, 0.03),
                          end: Alignment(-1, -0.03),
                          colors: [
                            Color(0xFF06B1FC),
                            Color(0xFF0017FF),
                            Color(0xFF18BBD7)
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Background(),
                            ),
                            (route) => false);
                      },
                      text: 'Background',
                      clip: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF0A1730),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomButton(
                      onPressed: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingPage(),
                          ),
                          (route) => false),
                      text: 'Settings',
                      clip: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF0A1730),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
