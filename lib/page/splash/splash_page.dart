import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:simulator_of_trading/page/page.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: Image.asset(
          'assets/images/png/splash.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          width: double.infinity,
        ),
        nextScreen: const MainPage(),
        splashIconSize: double.infinity,
        duration: 1000,
      ),
    );
  }
}
