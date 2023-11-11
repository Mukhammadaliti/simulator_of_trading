import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  List<double> courseHistory = [100]; // История изменения курса
  double userBalance = 1000;
  bool hasWon = false;
  final Random random = Random();

  void buyCrypto(double amount) {
    // Генерируем случайное изменение курса
    double change = random.nextInt(3) - 1; // -1, 0 или 1
    double currentCourse = courseHistory.last + change;

    // Проверяем, что currentCourse - конечное число
    if (currentCourse.isFinite) {
      courseHistory.add(currentCourse);

      // Проверяем, был ли выигрыш
      if (currentCourse > courseHistory.first) {
        double winnings = amount * 2; // Выигрыш в два раза больше
        userBalance += winnings;
        hasWon = true;
      } else {
        hasWon = false;
      }
    } else {
      // Обработка случая, когда currentCourse не является конечным числом
      print('Ошибка: currentCourse не является конечным числом');
    }
  }

  List<LineChartBarData> generateLineChartBars() {
    try {
      return [
        LineChartBarData(
          spots: courseHistory
              .asMap()
              .entries
              .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
              .toList(),
          isCurved: true,
          color: Colors.blue,
          belowBarData: BarAreaData(show: false),
        ),
      ];
    } catch (e) {
      print('Ошибка при создании LineChartBarData: $e');
      return []; // Возвращаем пустой список в случае ошибки
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crypto Trading App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current Balance: \$${userBalance.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            LineChart(
              LineChartData(
                lineBarsData: generateLineChartBars(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(drawBelowEverything: true),
                  bottomTitles: AxisTitles(drawBelowEverything: true),
                ),
                borderData: FlBorderData(
                  show: true,
                ),
                gridData: FlGridData(
                  show: true,
                ),
              ),
              duration: Duration(milliseconds: 250),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                buyCrypto(50); // Покупаем 50 единиц криптовалюты
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(hasWon
                          ? 'Congratulations!'
                          : 'Better luck next time'),
                      content: Text(hasWon
                          ? 'You won!\nYour balance is now \$${userBalance.toStringAsFixed(2)}'
                          : 'You lost.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                setState(() {});
              },
              child: Text('Buy Crypto'),
            ),
          ],
        ),
      ),
    );
  }
}
