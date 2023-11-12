import 'package:flutter/material.dart';
import 'package:simulator_of_trading/page/main/main_page.dart';
import 'package:simulator_of_trading/page/trade/widget/balance.dart';
import 'package:svg_flutter/svg.dart';

class AppbarCustom extends StatelessWidget {
  const AppbarCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
            Balance(),
          ],
        ),
      ),
      toolbarHeight: 72,
      backgroundColor: const Color(0xff0A1730),
    );
  }
}
