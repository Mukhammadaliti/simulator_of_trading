import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class Balance extends StatefulWidget {
  final Function(int)? onBalanceChanged;

  const Balance({Key? key, this.onBalanceChanged}) : super(key: key);

  @override
  State<Balance> createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  @override
  void initState() {
    super.initState();
    initializeBalance();
    startDailyTask();
  }

  // Установка начального баланса
  void initializeBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int initialBalance = prefs.getInt('balance') ?? 10000;
    prefs.setInt('balance', initialBalance);
  }

  // Запуск ежедневной задачи
  void startDailyTask() {
    const oneDay = const Duration(seconds: 3);
    Timer.periodic(oneDay, (Timer t) {
      // Ваш код для увеличения баланса
      increaseBalance();
    });
  }

  // Логика увеличения баланса
  void increaseBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentBalance = prefs.getInt('balance') ?? 0;

    setState(() {
      currentBalance += 1000;
      prefs.setInt('balance', currentBalance);

      // Проверка, что колбэк не является null перед его вызовом
      widget.onBalanceChanged?.call(currentBalance);
    });
  }

  void clearBalanceCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('balance');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Your balance',
          textAlign: TextAlign.right,
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
        FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            int currentBalance =
                (snapshot.data as SharedPreferences).getInt('balance') ?? 0;
            return Text(
              '$currentBalance',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'SFProText',
                fontWeight: FontWeight.w500,
                height: 0,
                letterSpacing: 0.32,
              ),
            );
          },
        ),
      ],
    );
  }
}
