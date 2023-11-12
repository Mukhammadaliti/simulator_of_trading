import 'package:flutter/material.dart';
import 'package:simulator_of_trading/widgets/appbar_custom.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Background extends StatefulWidget {
  const Background({Key? key}) : super(key: key);

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
  int? selectedBackgroundIndex; // Индекс выбранного фона
  bool isBackgroundPurchased = false; // Флаг, указывающий, куплен ли фон

  @override
  void initState() {
    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      selectedBackgroundIndex = index;
    });
  }

  void buyBackground(int index) {
    // Здесь вы можете реализовать логику покупки фона, например, вычитать валюту пользователя и сохранять выбранный фон.
    setState(() {
      selectedBackgroundIndex = index;
      isBackgroundPurchased = true;
    });
  }

  String getButtonText() {
    // Логика отображения текста кнопки в зависимости от выбранного и купленного фона
    if (selectedBackgroundIndex != null) {
      return 'Selected';
    } else {
      return isBackgroundPurchased ? 'Selected' : 'Buy Background';
    }
  }

  Color getButtonBorderColor() {
    return isBackgroundPurchased
        ? Colors.green
        : Colors.blue; // Замените на цвет, который вы хотите использовать
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: const AppbarCustom(),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Image.asset(
                images[index],
                fit: BoxFit.cover,
                key: UniqueKey(),
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
          const Positioned(
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
            child: ElevatedButton(
              onPressed: selectedBackgroundIndex != null
                  ? null
                  : () => buyBackground(selectedBackgroundIndex ?? 0),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white, // Цвет текста кнопки
                side: BorderSide(
                    color: getButtonBorderColor()), // Цвет границы кнопки
              ),
              child: Text(
                getButtonText(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
