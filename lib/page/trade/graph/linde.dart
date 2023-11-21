import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Linde extends StatefulWidget {
  final Function(double) onBuyTrade;
  Linde({Key? key, required this.onBuyTrade}) : super(key: key);

  @override
  LindeState createState() => LindeState();
}

final List<Color> gradientColor = [
  const Color(0xff0171C8),
  const Color.fromARGB(47, 1, 7, 5)
];

class LindeState extends State<Linde> {
  late List<LiveData> chartData;
  late int lastDataIndex;
  double? previousMarkerY;
  late Timer _timer;
  List<LiveData> buyTrades = [];
  List<LiveData> sellTrades = [];
  Map<int, int> markersTimestamps = {};
  void setMarker(double y) {
    if (previousMarkerY != null) {
      double newSpeed = (y - previousMarkerY!);
      widget.onBuyTrade(newSpeed > 0 ? 2 : 0);
    }

    previousMarkerY = y;
  }

  void buyTrade() {
    setState(() {
      double randomChange = (math.Random().nextDouble() - 0.5) * 0.001;
      double newSpeed = chartData[lastDataIndex].speed + randomChange;
      newSpeed = newSpeed.clamp(1.07086, 1.17086);

      LiveData newTrade = LiveData(time++, newSpeed, TradeType.buy);
      chartData.add(newTrade);
      lastDataIndex = chartData.length - 1;
      if (chartData.length > 19) {
        chartData.removeAt(0);
        lastDataIndex--;
      }

      buyTrades.add(newTrade);
      markersTimestamps[newTrade.time.toInt()] =
          DateTime.now().millisecondsSinceEpoch;

      _timer = Timer(Duration(seconds: 10), () {
        removeExpiredMarkers();
      });
    });
  }

  double getReward() {
    // Возвращаем reward текущего состояния
    return widget.onBuyTrade(chartData[lastDataIndex].speed);
  }

  void sellTrade() {
    setState(() {
      double randomChange = (math.Random().nextDouble() - 0.5) * 0.001;
      double newSpeed = chartData[lastDataIndex].speed + randomChange;
      newSpeed = newSpeed.clamp(1.07086, 1.17086);

      LiveData newTrade = LiveData(time++, newSpeed, TradeType.sell);
      chartData.add(newTrade);
      lastDataIndex = chartData.length - 1;
      if (chartData.length > 19) {
        chartData.removeAt(0);
        lastDataIndex--;
      }

      sellTrades.add(newTrade);
      markersTimestamps[newTrade.time.toInt()] =
          DateTime.now().millisecondsSinceEpoch;

      _timer = Timer(Duration(seconds: 10), () {
        removeExpiredMarkers();
      });
    });
  }

  @override
  void dispose() {
    // Отмените таймер в методе dispose
    _timer.cancel();
    super.dispose();
  }

  void removeExpiredMarkers() {
    setState(() {
      final int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
      final List<int> keysToRemove = [];

      markersTimestamps.forEach((key, timestamp) {
        if (currentTimestamp - timestamp >= 10000) {
          keysToRemove.add(key);
        }
      });

      keysToRemove.forEach((key) {
        buyTrades.removeWhere((marker) => marker.time.toInt() == key);
        sellTrades.removeWhere((trade) => trade.time.toInt() == key);

        markersTimestamps.remove(key);
      });
    });
  }

  void initState() {
    chartData = getChartData();
    lastDataIndex = chartData.length - 1;
    Timer.periodic(const Duration(seconds: 2), updateDataSource);
    super.initState();
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
      double randomChange = (math.Random().nextDouble() - 0.5) * 0.001;
      double newSpeed = chartData[lastDataIndex].speed + randomChange;
      newSpeed = newSpeed.clamp(1.07086, 1.17086);
      widget.onBuyTrade(newSpeed);

      chartData.add(LiveData(time++, newSpeed, TradeType.buy));
      lastDataIndex = chartData.length - 1;
      if (chartData.length > 19) {
        chartData.removeAt(0);
        lastDataIndex--;
      }
    });
  }

  List<LiveData> getChartData() {
    List<LiveData> randomData = [];
    for (int i = 0; i < 20; i++) {
      double randomSpeed =
          1.07086 + math.Random().nextDouble() * (1.17086 - 1.07086);
      randomData.add(LiveData(i, randomSpeed, TradeType.buy));
    }
    return randomData;
  }
}

class LiveData {
  LiveData(
    this.time,
    this.speed,
    this.tradeType,
  );
  final int time;
  final double speed;
  final TradeType tradeType;
}

enum TradeType { buy, sell }
