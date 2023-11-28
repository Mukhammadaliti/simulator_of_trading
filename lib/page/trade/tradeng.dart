// ignore_for_file: unnecessary_null_comparison
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simulator_of_trading/page/main/main_page.dart';
import 'package:simulator_of_trading/page/trade/graph/linde.dart';
import 'package:simulator_of_trading/page/trade/widget/balance.dart';
import 'package:svg_flutter/svg.dart';

class Tradeng extends StatefulWidget {
  final Function(int)? onAmountSelected;
  const Tradeng({
    Key? key,
    this.onAmountSelected,
  }) : super(key: key);

  @override
  _TradengState createState() => _TradengState();
}

class _TradengState extends State<Tradeng> {
  final GlobalKey<LindeState> lindeKey = GlobalKey<LindeState>();
  final GlobalKey<BalanceState> balance = GlobalKey<BalanceState>();

  List<Offset> markers = [];
  late List<CurrencyPair> currencyPairs;
  late CurrencyPair selectedCurrencyPair;
  final List<String> price = [
    '20',
    '50',
    '100',
    '500',
    '1000',
    '2000',
    '5000',
  ];
  String selectedOption = 'EUR/USD';
  String selectedPrice = '20';
  String selectedTime = '00:30';
  int selectedTimeIndex = 0;
  int selectedOptionIndex = 0;
  int selectedPriceIndex = 0;
  Timer? chartTimer;
  double reward = 0.0;
  bool isTimerRunning = false;
  void _showBottomSheet(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return DraggableScrollableSheet(
            expand: false,
            builder: (BuildContext context, ScrollController controller) {
              return Container(
                color: const Color(0xff0A1730),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        width: 48,
                        height: 4,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 16,
                        bottom: 24,
                        left: 16,
                      ),
                      child: Text(
                        'Currency pair',
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
                    Expanded(
                      child: ListView.builder(
                          controller: controller,
                          itemCount: currencyPairs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Container(
                                height: 56,
                                padding: const EdgeInsets.all(16),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  gradient: index == selectedOptionIndex
                                      ? const LinearGradient(
                                          begin: Alignment(1.00, 0.03),
                                          end: Alignment(-1, -0.03),
                                          colors: [
                                            Color(0xFF06B1FC),
                                            Color(0xFF0017FF),
                                            Color(0xFF18BBD7)
                                          ],
                                        )
                                      : null, // No gradient for unselected options
                                  color: index != selectedOptionIndex
                                      ? null
                                      : Colors
                                          .white, // No background color for unselected options
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors
                                        .white, // White border for unselected options
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      currencyPairs[index].name.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'SFProText',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                        letterSpacing: 0.32,
                                      ),
                                    ),
                                    if (index == selectedOptionIndex)
                                      SvgPicture.asset(
                                        'assets/images/svg/check.svg',
                                      ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedOptionIndex = index;
                                  selectedOption =
                                      currencyPairs[index].name.toString();

                                  Navigator.pop(context);
                                });
                                print(currencyPairs[selectedOptionIndex].name);
                              },
                            );
                          }),
                    ),
                  ],
                ),
              );
            });
      },
    );
  }

  void _showPrice(
    BuildContext context,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return DraggableScrollableSheet(
            minChildSize: 0.5,
            maxChildSize: 1.0,
            expand: false,
            builder: (BuildContext context, ScrollController controller) {
              return Container(
                color: const Color(0xff0A1730),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        width: 48,
                        height: 4,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 16,
                        bottom: 24,
                        left: 16,
                      ),
                      child: Text(
                        'Amount',
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
                    Expanded(
                      child: ListView.builder(
                          controller: controller,
                          itemCount: price.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Container(
                                height: 56,
                                padding: const EdgeInsets.all(16),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  gradient: index == selectedPriceIndex
                                      ? const LinearGradient(
                                          begin: Alignment(1.00, 0.03),
                                          end: Alignment(-1, -0.03),
                                          colors: [
                                            Color(0xFF06B1FC),
                                            Color(0xFF0017FF),
                                            Color(0xFF18BBD7)
                                          ],
                                        )
                                      : null, // No gradient for unselected options
                                  color: index != selectedPriceIndex
                                      ? null
                                      : Colors
                                          .white, // No background color for unselected options
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors
                                        .white, // White border for unselected options
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      price[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'SFProText',
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                        letterSpacing: 0.32,
                                      ),
                                    ),
                                    if (index == selectedPriceIndex)
                                      SvgPicture.asset(
                                        'assets/images/svg/check.svg',
                                      ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedPriceIndex = index;
                                  selectedPrice = price[index];
                                  widget.onAmountSelected
                                      ?.call(int.parse(selectedPrice));

                                  Navigator.pop(context);
                                });
                              },
                            );
                          }),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              );
            });
      },
    );
  }

  void _showTime(BuildContext context) {
    if (isTimerRunning) {
      return; // Если таймер работает, не показывать диалог выбора времени
    }
    List<String> times = generateTimeOptions();
    showModalBottomSheet(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController controller) {
            return Container(
              color: const Color(0xff0A1730),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      width: 48,
                      height: 4,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 16,
                      bottom: 24,
                      left: 16,
                    ),
                    child: Text(
                      'Time',
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
                  Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: times.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Container(
                            height: 56,
                            padding: const EdgeInsets.all(16),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              gradient:
                                  index == selectedTimeIndex && !isTimerRunning
                                      ? const LinearGradient(
                                          begin: Alignment(1.00, 0.03),
                                          end: Alignment(-1, -0.03),
                                          colors: [
                                            Color(0xFF06B1FC),
                                            Color(0xFF0017FF),
                                            Color(0xFF18BBD7)
                                          ],
                                        )
                                      : null,
                              color: index != selectedTimeIndex
                                  ? null
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  times[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'SFProText',
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                    letterSpacing: 0.32,
                                  ),
                                ),
                                if (index == selectedTimeIndex)
                                  Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedTimeIndex = index;
                              selectedTime = times[
                                  index]; // если вам нужно сохранить выбранное время
                              Navigator.pop(context);
                            });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _startChartTimer() {
    if (chartTimer != null && chartTimer!.isActive) {
      chartTimer!.cancel();
    }

    List<String> timeParts = selectedTime.split(':');
    int minutes = int.parse(timeParts[0]);
    int seconds = int.parse(timeParts[1]);

    int totalDurationInSeconds = minutes * 60 + seconds;
    int remainingDurationInSeconds = totalDurationInSeconds;

    setState(() {
      isTimerRunning = true;
    });

    int updateInterval;

    if (selectedTime == '00:30') {
      updateInterval = 3; // Обновлять каждую секунду
    } else if (selectedTime == '01:00') {
      updateInterval = 10; // Обновлять каждые 3 секунды
    } else if (selectedTime == '02:00') {
      updateInterval = 20; // Обновлять каждые 6 секунд
    } else if (selectedTime == '05:00') {
      updateInterval = 60; // Обновлять каждые 15 секунд
    } else if (selectedTime == '10:00') {
      updateInterval = 80; // Обновлять каждые 30 секунд
    } else {
      updateInterval = 1; // Значение по умолчанию
    }

    // Основной таймер для уменьшения времени каждую секунду
    Timer countDownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingDurationInSeconds == 0) {
          timer.cancel();
          isTimerRunning = false;
          selectedTime = '00:30';
          // Обновление графика каждую секунду после окончания таймера
          chartTimer = Timer.periodic(Duration(seconds: 1), (timer) {
            lindeKey.currentState?.updateDataSource(timer);
          });
        } else {
          remainingDurationInSeconds--;
          int minutes = remainingDurationInSeconds ~/ 60;
          int seconds = remainingDurationInSeconds % 60;
          selectedTime =
              '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

          // Обновление графика с интервалом
          if (remainingDurationInSeconds % updateInterval == 0) {
            lindeKey.currentState?.updateDataSource(timer);
          }
        }
      });
    });
  }

  List<String> generateTimeOptions() {
    List<String> times = ['00:30', '01:00', '02:00', '05:00', '10:00'];
    return times;
  }

  @override
  void dispose() {
    _startChartTimer();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _startChartTimer();
    currencyPairs = [
      CurrencyPair('EUR/USD'),
      CurrencyPair('USD/JPY'),
      CurrencyPair('AUD/USD'),
      CurrencyPair('USD/CAD'),
      CurrencyPair('USD/CHF'),
      CurrencyPair('USD/CNH'),
      CurrencyPair('GBP/USD'),
    ];
    selectedCurrencyPair = currencyPairs.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff00031C),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Currency pair',
                        style: TextStyle(
                          color: Color(0xFF02E206),
                          fontSize: 13,
                          fontFamily: 'SFProText',
                          fontWeight: FontWeight.w300,
                          height: 0,
                          letterSpacing: 0.26,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      InkWell(
                        onTap: () {
                          _showBottomSheet(
                            context,
                          );
                        },
                        child: Row(
                          children: [
                            Text(selectedOption),
                            const SizedBox(
                              width: 4,
                            ),
                            SvgPicture.asset(
                              'assets/images/svg/down.svg',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Balance(),
            ],
          ),
        ),
        toolbarHeight: 72,
        backgroundColor: const Color(0xff0A1730),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 479,
              child: Linde(
                currencyPair: currencyPairs[selectedOptionIndex],
                key: lindeKey,
                onUpdateReward: (double newReward) {
                  setState(() {
                    reward = newReward;
                    print(reward);
                  });
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 98,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF0A1730),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount',
                        style: TextStyle(
                          color: Color(0xFF02E206),
                          fontSize: 16,
                          fontFamily: 'SFProText',
                          fontWeight: FontWeight.w300,
                          height: 0,
                          letterSpacing: 0.26,
                        ),
                      ),
                      SizedBox(height: 4),
                      InkWell(
                        onTap: () {
                          _showPrice(context);
                          setState(() {});
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedPrice,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w500,
                                height: 0,
                                letterSpacing: 0.32,
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/images/svg/down.svg',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 98,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: ShapeDecoration(
                    color: const Color(0xFF0A1730),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time',
                        style: TextStyle(
                          color: Color(0xFF02E206),
                          fontSize: 16,
                          fontFamily: 'SFProText',
                          fontWeight: FontWeight.w300,
                          height: 0,
                          letterSpacing: 0.26,
                        ),
                      ),
                      SizedBox(height: 4),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _showTime(context);
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedTime,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontFamily: 'SFProText',
                                fontWeight: FontWeight.w500,
                                height: 0,
                                letterSpacing: 0.32,
                              ),
                            ),
                            if (isTimerRunning == false)
                              SvgPicture.asset(
                                'assets/images/svg/down.svg',
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 98,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 1, color: Color(0xFF02E206)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reward',
                        style: TextStyle(
                          color: Color(0xFF02E206),
                          fontSize: 16,
                          fontFamily: 'SFProText',
                          fontWeight: FontWeight.w300,
                          height: 0,
                          letterSpacing: 0.26,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        reward.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 19,
                          fontFamily: 'SFProText',
                          fontWeight: FontWeight.w500,
                          height: 0,
                          letterSpacing: 0.32,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 155.50,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        lindeKey.currentState?.buyTrade();
                        _startChartTimer();
                      });
                      print('Buy button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff079504),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'Buy',
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
                ),
                SizedBox(
                  width: 155.50,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF950404),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      setState(() {
                        // Вызываем метод для вычета суммы из баланса перед совершением сделки "Sell"
                        lindeKey.currentState?.sellTrade();
                        _startChartTimer();
                      });
                    },
                    child: const Text(
                      'Sell',
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CurrencyPair {
  final String name;

  CurrencyPair(this.name);
  @override
  String toString() {
    return name;
  }
}
