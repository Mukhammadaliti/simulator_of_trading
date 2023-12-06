import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simulator_of_trading/page/main/main_page.dart';
import 'package:simulator_of_trading/page/trade/widget/balance.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:svg_flutter/svg.dart';

class Background extends StatefulWidget {
  final Function(int)? onBalanceChanged;
  const Background({Key? key, this.onBalanceChanged}) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  final controller = PageController();
  final List<String> images = [
    "assets/images/background/background 1.png",
    "assets/images/background/background 2.png",
    "assets/images/background/background 3.png",
    "assets/images/background/background 4.png",
    "assets/images/background/background 5.png",
  ];
  final List<int> backgroundPrices = [0, 12000, 14000, 15000, 17000];
  List<bool> isBackgroundPurchasedList = [true, false, false, false, false];

  int selectedBackgroundIndex = 0;
  late int userBalance;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  void onPageChanged(int index) {
    setState(() {
      selectedBackgroundIndex = index;
    });
  }

  void buyBackground(int index) {
    if (!isBackgroundPurchasedList[index] &&
        userBalance >= backgroundPrices[index]) {
      print("Before Purchase: User Balance - $userBalance");

      setState(() {
        // Вычитаем стоимость из баланса пользователя, используя параметр 'index'
        userBalance -= backgroundPrices[index];

        // Обновляем 'selectedBackgroundIndex' после успешной покупки
        selectedBackgroundIndex = index;

        // Устанавливаем фон как купленный
        isBackgroundPurchasedList[index] = true;

        // Сохраняем изменения в SharedPreferences
        _saveData();

        // Перезагружаем баланс
        widget.onBalanceChanged?.call(userBalance);
        print("After Purchase: User Balance - $userBalance");
      });
    } else {
      // Обработка случаев недостаточных средств или других ошибок
      print("Не хватает баланса $userBalance");
    }
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('selectedBackgroundIndex', selectedBackgroundIndex);
    prefs.setInt('balance', userBalance);

    for (int i = 0; i < isBackgroundPurchasedList.length; i++) {
      prefs.setBool('isBackgroundPurchased_$i', isBackgroundPurchasedList[i]);
    }
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      selectedBackgroundIndex = prefs.getInt('selectedBackgroundIndex') ?? 0;
      userBalance = prefs.getInt('balance') ?? 10000;

      for (int i = 0; i < isBackgroundPurchasedList.length; i++) {
        isBackgroundPurchasedList[i] =
            prefs.getBool('isBackgroundPurchased_$i') ?? false;
      }
    });

    // Добавьте этот блок кода для установки купленных фонов в true,
    // если соответствующая цена фона равна 0 (нулевая цена фона).
    for (int i = 0; i < backgroundPrices.length; i++) {
      if (backgroundPrices[i] == 0) {
        setState(() {
          isBackgroundPurchasedList[i] = true;
        });
      }
    }
  }

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
              KeyedSubtree(
                key: UniqueKey(), // Добавьте ключ
                child: Balance(onBalanceChanged: (balance) {
                  setState(() {
                    userBalance = balance;
                  });
                }),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xff0A1730),
      ),
      body: Stack(
        children: [
          PageView.builder(
            key: PageStorageKey<String>('background_page_key'),
            controller: controller,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Opacity(
                opacity: isBackgroundPurchasedList[index] ? 1.0 : 0.5,
                child: Image.asset(
                  images[index],
                  fit: BoxFit.cover,
                  key: ValueKey<String>(
                    images[index],
                  ),
                ),
              );
            },
            onPageChanged: onPageChanged,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 208,
            child: Align(
              alignment: Alignment.center,
              child: SmoothPageIndicator(
                controller: controller,
                count: images.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.white,
                  dotWidth: 14,
                  dotHeight: 6,
                  spacing: 7,
                  dotColor: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 146,
            child: Text(
              'Swipe left and right to see more\n backgrounds',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w500,
                height: 0,
                letterSpacing: 0.32,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Positioned(
            left: 0,
            right: 0,
            bottom: 58,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              height: 50,
              decoration: BoxDecoration(
                gradient: isBackgroundPurchasedList[selectedBackgroundIndex]
                    ? null
                    : LinearGradient(
                        begin: Alignment(1.00, 0.03),
                        end: Alignment(-1, -0.03),
                        colors: [
                          Color(0xFF06B1FC),
                          Color(0xFF0017FF),
                          Color(0xFF18BBD7)
                        ],
                      ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isBackgroundPurchasedList[selectedBackgroundIndex]
                      ? Colors.transparent
                      : Colors.blue,
                ),
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    buyBackground(selectedBackgroundIndex);
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Center(
                  child: isBackgroundPurchasedList[selectedBackgroundIndex]
                      ? Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xff0A1730),
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'CHOOSED',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.w600,
                                height: 0,
                                letterSpacing: 0.40,
                              ),
                            ),
                          ),
                        )
                      : isBackgroundPurchasedList[selectedBackgroundIndex]
                          ? Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  'Выбрать',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'SFProDisplay',
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                    letterSpacing: 0.40,
                                  ),
                                ),
                              ),
                            )
                          : Text(
                              '${backgroundPrices[selectedBackgroundIndex]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'SFProDisplay',
                                fontWeight: FontWeight.w600,
                                height: 0,
                                letterSpacing: 0.40,
                              ),
                            ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
