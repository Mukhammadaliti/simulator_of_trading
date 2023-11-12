import 'dart:async';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Graph extends StatefulWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  _GraphState createState() => _GraphState();
}

final List<Color> gradientColor = [
  const Color(0xff0171C8),
  const Color.fromARGB(47, 1, 7, 5)
];

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  final style = TextStyle(
    color: Colors.white.withOpacity(0.4000000059604645),
    fontWeight: FontWeight.bold,
    fontFamily: 'SFProText',
    fontSize: 14,
  );
  DateTime currentTime = DateTime.now();
  DateTime userEndTime = currentTime.add(const Duration(minutes: 10));
  int intValue = value.toInt();
  DateTime pastTime =
      currentTime.subtract(Duration(minutes: (5 - intValue).abs() * 10));
  String text = '';

  if (intValue >= 1 && intValue <= 5) {
    text = DateFormat('HH:mm').format(pastTime);
  } else if (intValue == 0) {
    text = DateFormat('HH:mm').format(userEndTime);
  }

  return Text(text, style: style, textAlign: TextAlign.start);
}

Widget rightTitleWidgets(double value, TitleMeta meta) {
  String text;
  final style = TextStyle(
    color: Colors.white.withOpacity(0.4000000059604645),
    fontWeight: FontWeight.bold,
    fontFamily: 'SFProText',
    fontSize: 14,
  );

  switch (value.toDouble()) {
    case 9:
      text = '1.10600';
      break;
    case 8:
      text = '1.10590';
      break;
    case 7:
      text = '1.10580';
      break;
    case 6:
      text = '1.10570';
      break;
    case 5:
      text = '1.10560';
      break;
    case 4:
      text = '1.10550';
      break;
    case 3:
      text = '1.10540';
      break;
    case 2:
      text = '1.10530';
      break;
    case 1:
      text = '1.10520';
      break;
    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.start);
}

class _GraphState extends State<Graph> {
  late Timer _timer;
  @override
  void initState() {
    super.initState();

    // Инициализация таймера для обновления каждые 20 секунд
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      // Вызов setState для обновления состояния и перестройки виджета
      updateGraphData();

      setState(() {});
    });
    tradingData = generateInitialData();
  }

  @override
  void dispose() {
    // Отмена таймера при уничтожении виджета
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        titlesData: const FlTitlesData(
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              getTitlesWidget: rightTitleWidgets,
              showTitles: true,
              reservedSize: 70,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                getTitlesWidget: bottomTitleWidgets,
                showTitles: true,
                interval: 1,
                reservedSize: 40),
          ),
        ),
        minX: 0,
        maxX: 5,
        minY: 0,
        maxY: 9,
        gridData: FlGridData(
          getDrawingVerticalLine: (value) {
            return const FlLine(
              color: Color(0xff37434d),
              strokeWidth: 1,
            );
          },
          drawVerticalLine: true,
          show: true,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Color(0xff37434d),
              strokeWidth: 1,
            );
          },
        ),
        lineBarsData: [
          LineChartBarData(
            spots: tradingData,
            color: Colors.white,
            barWidth: 1,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColor
                    .map((color) => color.withOpacity(0.5))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> tradingData = [];

  void updateGraphData() {
    // Генерация случайного значения -1, 0 или 1
    Random random = Random();
    double randomValue = (random.nextDouble() - 0.5) * 0.0080;
    randomValue = randomValue.clamp(1.0520, 1.0600);

    // Копирование текущего списка
    List<FlSpot> updatedData = List<FlSpot>.from(tradingData);

    // Добавление случайного значения к каждому элементу
    if (updatedData.length >= 2) {
      double secondLastPrice = updatedData[updatedData.length - 2].y;
      updatedData[updatedData.length - 2] = FlSpot(
        updatedData.length.toDouble() - 2,
        secondLastPrice + randomValue,
      );
    }
    double lastPrice = updatedData.last.y;
    updatedData.add(
        FlSpot(updatedData.length.toDouble() - 1, lastPrice + randomValue));
    // Установка обновленного списка в качестве новых данных графика
    setState(() {
      tradingData = updatedData;

      print('ghost');
    });
  }

  List<FlSpot> generateInitialData() {
    // Начальные данные для графика (можно заменить реальными данными)
    return [
      FlSpot(0, 1.0520),
      FlSpot(1, 1.0530),
      FlSpot(2, 1.0540),
      FlSpot(3, 1.0560),
      FlSpot(4, 1.0570),
    ];
  }
}
