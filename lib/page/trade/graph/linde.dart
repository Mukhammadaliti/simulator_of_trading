import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simulator_of_trading/page/trade/tradeng.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Linde extends StatefulWidget {
  final CurrencyPair currencyPair;
  final Function(double) onUpdateReward;

  Linde({
    Key? key,
    required this.currencyPair,
    required this.onUpdateReward,
  }) : super(key: key);

  @override
  LindeState createState() => LindeState();
}

final List<Color> gradientColor = [
  const Color(0xff0171C8),
  const Color.fromARGB(47, 1, 7, 5)
];

class LindeState extends State<Linde> {
  List<LiveData>? chartData;
  late int lastDataIndex;
  double? previousMarkerY;
  late Timer _timer;
  List<LiveData> buyTrades = [];
  List<LiveData> sellTrades = [];
  Map<int, int> markersTimestamps = {};
  double previousSpeed = 0.0;
  bool hasOpenTrade = false;
  TradeType? lastTradeType;
  double currentReward = 0.0;
  void updateReward(double newSpeed, TradeType tradeType) {
    if (hasOpenTrade) {
      if ((tradeType == TradeType.buy && newSpeed > previousSpeed!) ||
          (tradeType == TradeType.sell && newSpeed < previousSpeed!)) {
        currentReward = 2.0;
        widget.onUpdateReward(currentReward);
      } else {
        currentReward = 0.0;
        widget.onUpdateReward(currentReward);
      }

      previousSpeed = newSpeed;
    } else {
      currentReward = 0.0;
      widget.onUpdateReward(currentReward);
    }
  }

  void setMarker(double y) {
    if (previousMarkerY != null) {
      double newSpeed = (y - previousMarkerY!);
    }

    previousMarkerY = y;
  }

  void buyTrade() {
    setState(() {
      hasOpenTrade = true;
      double randomChange = (math.Random().nextDouble() - 0.5) * 0.001;
      double newSpeed = chartData![lastDataIndex].speed + randomChange;
      newSpeed = newSpeed.clamp(
        getMinValue(),
        getMaxValue(),
      );

      LiveData newTrade = LiveData(time++, newSpeed, TradeType.buy);
      chartData!.add(newTrade);
      lastDataIndex = chartData!.length - 1;
      if (chartData!.length > 19) {
        chartData!.removeAt(0);
        lastDataIndex--;
      }
      hasOpenTrade = true;

      buyTrades.add(newTrade);
      markersTimestamps[newTrade.time.toInt()] =
          DateTime.now().millisecondsSinceEpoch;

      // Вызовите функцию updateReward при каждой сделке
      updateReward(newSpeed, TradeType.buy);

      _timer = Timer(Duration(seconds: 10), () {
        removeExpiredMarkers();
      });
    });
  }

  void sellTrade() {
    setState(() {
      double randomChange = (math.Random().nextDouble() - 0.5) * 0.001;
      double newSpeed = chartData![lastDataIndex].speed + randomChange;
      newSpeed = newSpeed.clamp(getMinValue(), getMaxValue());

      LiveData newTrade = LiveData(time++, newSpeed, TradeType.sell);
      chartData!.add(newTrade);
      lastDataIndex = chartData!.length - 1;
      if (chartData!.length > 19) {
        chartData!.removeAt(0);
        lastDataIndex--;
      }
      hasOpenTrade = true;
      sellTrades.add(newTrade);
      markersTimestamps[newTrade.time.toInt()] =
          DateTime.now().millisecondsSinceEpoch;

      // Обновляем reward при продаже
      updateReward(newSpeed, TradeType.sell);

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
    chartData = getChartData(widget.currencyPair!);
    lastDataIndex = chartData!.length - 1;
    // Timer.periodic(const Duration(seconds: 2), updateDataSource);
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
          dataSource: chartData!,
          color: Colors.white,
          xValueMapper: (LiveData sales, _) => sales.time.toInt(),
          yValueMapper: (LiveData sales, _) => sales.speed,
        ),
        LineSeries<LiveData, int>(
          dataSource: [chartData![lastDataIndex]],
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
          dataSource: chartData!,
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
          xValueMapper: (LiveData sales, _) => sales.time,
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
        interval: 4,
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          final minutes = (details.value ~/ 60).toString().padLeft(2, '0');
          final secondsInt = (details.value % 60).toInt();
          final seconds = secondsInt.toString().padLeft(2, '0');

          return ChartAxisLabel('$minutes:$seconds', TextStyle());
        },
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        borderColor: Colors.white.withOpacity(0.3),
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
      double newSpeed = chartData![lastDataIndex].speed + randomChange;

      double minValue = getMinValue();
      double maxValue = getMaxValue();

      newSpeed = newSpeed.clamp(minValue, maxValue);

      chartData!.add(LiveData(time++, newSpeed,
          TradeType.buy)); // Изменено: используйте текущее значение времени
      lastDataIndex = chartData!.length - 1;
      if (chartData!.length > 19) {
        chartData!.removeAt(0);
        lastDataIndex--;
      }
    });
  }

  double getMinValue() {
    switch (widget.currencyPair!.name) {
      case 'EUR/USD':
        return 1.07086;
      case 'USD/JPY':
        return 150.0;
      case 'AUD/USD':
        return 0.64258;
      case 'USD/CAD':
        return 1.37656;
      case 'USD/CHF':
        return 0.89964;
      case 'USD/CNH':
        return 7.28920;
      case 'GBP/USD':
        return 1.22912;
      default:
        return 1.07086; // Значение по умолчанию
    }
  }

  double getMaxValue() {
    switch (widget.currencyPair!.name) {
      case 'EUR/USD':
        return 1.17086;
      case 'USD/JPY':
        return 151.0;
      case 'AUD/USD':
        return 0.74258;
      case 'USD/CAD':
        return 1.47656;
      case 'USD/CHF':
        return 0.99964;
      case 'USD/CNH':
        return 7.38920;
      case 'GBP/USD':
        return 1.32912;
      default:
        return 1.07086; // Значение по умолчанию
    }
  }

  @override
  void didUpdateWidget(covariant Linde oldWidget) {
    if (widget.currencyPair != oldWidget.currencyPair) {
      setState(() {
        // Очищаем списки при изменении валютной пары
        buyTrades.clear();
        sellTrades.clear();

        // Обновляем график при изменении валютной пары
        chartData = getChartData(widget.currencyPair!);
        lastDataIndex = chartData!.length - 1;
        time = chartData!.isEmpty ? 0 : chartData!.last.time + 1;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  List<LiveData> getChartData(CurrencyPair currencyPair) {
    double startValue = 1.0;

    if (currencyPair.name == 'EUR/USD') {
      startValue = 1.07086;
    } else if (currencyPair.name == 'USD/JPY') {
      startValue = 150.0;
    } else if (currencyPair.name == 'AUD/USD') {
      startValue = 0.64258;
    } else if (currencyPair.name == 'USD/CAD') {
      startValue = 1.37656;
    } else if (currencyPair.name == 'USD/CHF') {
      startValue = 0.89964;
    } else if (currencyPair.name == 'USD/CNH') {
      startValue = 7.28920;
    } else if (currencyPair.name == 'GBP/USD') {
      startValue = 1.22912;
    }

    List<LiveData> randomData = [];
    for (int i = 0; i < 20; i++) {
      double randomChange = (math.Random().nextDouble() - 0.5) * 0.001;
      double newSpeed = startValue + randomChange;
      newSpeed = newSpeed.clamp(
        getMinValue(),
        getMaxValue(),
      );

      randomData.add(LiveData(i, newSpeed, TradeType.buy));
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
