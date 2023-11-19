import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Linde extends StatefulWidget {
  Linde({
    Key? key,
  }) : super(key: key);

  @override
  LindeState createState() => LindeState();
}

final List<Color> gradientColor = [
  const Color(0xff0171C8),
  const Color.fromARGB(47, 1, 7, 5)
];

class LindeState extends State<Linde> {
  late List<LiveData> chartData;
  late Timer _timer;
  late int lastDataIndex;
  late SfCartesianChart chart;
  List<LiveData> buyTrades = [];
  List<LiveData> sellTrades = [];
  int elapsedTime = 0;

  void buyTrade() {
    setState(() {
      double randomChange = (math.Random().nextDouble() - 0.5) * 0.001;
      double newSpeed = chartData[lastDataIndex].speed + randomChange;
      newSpeed = newSpeed.clamp(1.07086, 1.17086);

      buyTrades.add(LiveData(time++, newSpeed));

      // Устанавливаем таймер на 10 секунд для удаления маркера
      Timer(Duration(seconds: 10), () {
        buyremovetrade();
      });
    });
  }

  void sellTrade() {
    setState(() {
      double randomChange = (math.Random().nextDouble() - 0.5) * 0.001;
      double newSpeed = chartData[lastDataIndex].speed + randomChange;
      newSpeed = newSpeed.clamp(1.07086, 1.17086);

      sellTrades.add(LiveData(time++, newSpeed));

      // Устанавливаем таймер на 10 секунд для удаления маркера
      Timer(Duration(seconds: 10), () {
        selltremovetrade();
      });
    });
  }

  void selltremovetrade() {
    setState(() {
      sellTrades.clear();
    });
  }

  void buyremovetrade() {
    setState(() {
      buyTrades.clear();
    });
  }

  void initState() {
    chartData = getChartData();
    lastDataIndex = chartData.length - 1;
    _timer = Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
  }

  @override
  void dispose() {
    // Cancel the timer in the dispose method
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      crosshairBehavior: CrosshairBehavior(
        activationMode: ActivationMode.singleTap,
        enable: true,
        lineColor: Colors.white,
        lineType: CrosshairLineType.horizontal,
        shouldAlwaysShow: true,
      ),
      plotAreaBorderWidth: 0.0,
      series: <CartesianSeries<LiveData, int>>[
        LineSeries<LiveData, int>(
          dataSource: chartData,
          color: Colors.white,
          xValueMapper: (LiveData sales, _) => sales.time.toInt(),
          yValueMapper: (LiveData sales, _) => sales.speed,
        ),
        LineSeries<LiveData, int>(
          dataSource: [chartData[lastDataIndex]],
          xValueMapper: (LiveData sales, _) => sales.time.toInt(),
          yValueMapper: (LiveData sales, _) => sales.speed,
          markerSettings: MarkerSettings(
            borderColor: Colors.white,
            borderWidth: 2,
            color: Colors.blue,
            isVisible: true,
            width: 13,
            height: 13,
            shape: DataMarkerType.circle,
          ),
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.auto,
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontFamily: 'SFProText',
              fontWeight: FontWeight.w300,
              height: 0,
              letterSpacing: 0.26,
            ),
          ),
        ),
        LineSeries<LiveData, int>(
          dataSource: chartData,
          color: Colors.white,
          xValueMapper: (LiveData sales, _) => sales.time.toInt(),
          yValueMapper: (LiveData sales, _) => sales.speed,
          dataLabelSettings: DataLabelSettings(),
        ),
        ScatterSeries<LiveData, int>(
          dataSource: buyTrades,
          xValueMapper: (LiveData marker, _) => marker.time.toInt(),
          yValueMapper: (LiveData marker, _) => marker.speed,
          color: Colors.green,
          markerSettings: MarkerSettings(
            borderColor: Colors.white,
            borderWidth: 2,
            isVisible: true,
            width: 13,
            height: 13,
            shape: DataMarkerType.circle,
          ),
        ),
        ScatterSeries<LiveData, int>(
          dataSource: sellTrades,
          xValueMapper: (LiveData marker, _) => marker.time.toInt(),
          yValueMapper: (LiveData marker, _) => marker.speed,
          color: Colors.red,
          markerSettings: MarkerSettings(
            borderColor: Colors.white,
            borderWidth: 2,
            isVisible: true,
            width: 13,
            height: 13,
            shape: DataMarkerType.circle,
          ),
        ),
      ],
      primaryXAxis: NumericAxis(
        majorGridLines: MajorGridLines(
          width: 1,
          color: Colors.white.withOpacity(0.3),
        ),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        borderColor: Colors.white.withOpacity(0.3),
        interval: 3,
        title: AxisTitle(text: 'Time (seconds)'),
      ),
      primaryYAxis: NumericAxis(
        opposedPosition: true,
        borderColor: Colors.white30,
        axisLine: AxisLine(width: 1),
        majorTickLines: MajorTickLines(
          size: 53,
          color: Colors.white.withOpacity(0.3),
        ),
        majorGridLines: MajorGridLines(
          width: 1,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  int time = 19;

  void updateDataSource(Timer timer) {
    setState(() {
      elapsedTime++;
      if (elapsedTime % 20 == 0) {
        double randomChange = (math.Random().nextDouble() - 0.5) * 0.001;
        double newSpeed = chartData[lastDataIndex].speed + randomChange;
        newSpeed = newSpeed.clamp(1.07086, 1.17086);

        chartData.add(LiveData(time++, newSpeed));
        lastDataIndex = chartData.length - 1;

        if (chartData.length > 19) {
          chartData.removeAt(0);
          lastDataIndex--;
        }
      }
    });
  }

  List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 1.10520),
      LiveData(1, 1.10522),
      LiveData(2, 1.20524),
      LiveData(3, 1.20526),
      LiveData(4, 1.30528),
      LiveData(5, 1.30530),
      LiveData(6, 1.40532),
      LiveData(7, 1.40534),
      LiveData(9, 1.50520),
      LiveData(10, 1.50560),
      LiveData(11, 1.60550),
      LiveData(12, 1.60540),
      LiveData(13, 1.70510),
      LiveData(14, 1.70590),
      LiveData(15, 1.80570),
      LiveData(16, 1.80510),
      LiveData(17, 1.90530),
      LiveData(18, 1.90550),
      LiveData(19, 1.10636),
    ];
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final num time;
  final num speed;
}
