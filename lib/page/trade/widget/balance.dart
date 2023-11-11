import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Balance extends StatefulWidget {
  const Balance({Key? key}) : super(key: key);

  @override
  State<Balance> createState() => _BalanceState();
}

class _BalanceState extends State<Balance> {
  int userBalance = 10000;
  late DateTime lastLoginDate;

  @override
  void initState() {
    super.initState();
    lastLoginDate = DateTime.now();
    getLastLoginDate();
    updateBalance();
  }

  void getLastLoginDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('lastLoginDate')) {
      lastLoginDate = DateTime.parse(prefs.getString('lastLoginDate')!);
    } else {
      lastLoginDate = DateTime.now();
      updateLastLoginDate();
    }
  }

  void updateLastLoginDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastLoginDate', DateTime.now().toIso8601String());
  }

  void updateBalance() {
    if (DateTime.now().difference(lastLoginDate).inDays > 0) {
      setState(() {
        if (userBalance < 10000) {
          userBalance = 10000;

          // Предположим, что у вас есть функция установки нового баланса пользователю.
          // setNewBalance(userBalance);
        }
      });
      updateLastLoginDate();
    }
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
        Text(
          userBalance.toString(),
          textAlign: TextAlign.right,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'SFProText',
            fontWeight: FontWeight.w500,
            height: 0,
            letterSpacing: 0.32,
          ),
        ),
      ],
    );
  }
}
