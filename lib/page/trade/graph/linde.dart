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

class LindeState extends State<Linde> {
  late List<LiveData> chartData;
  late int lastDataIndex;
  bool showBuyMarker = false;
  int buyMarkerIndex = -1;

  void showBuyMarkerOnChart() {
    setState(() {
      showBuyMarker = true;
      buyMarkerIndex = lastDataIndex;
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
      series: <LineSeries<LiveData, int>>[
        LineSeries<LiveData, int>(
          dataSource: chartData,
          color: Colors.white,
          xValueMapper: (LiveData sales, _) => sales.time,
          yValueMapper: (LiveData sales, _) => sales.speed,
        ),
        LineSeries<LiveData, int>(
          dataSource: [chartData[lastDataIndex]],
          xValueMapper: (LiveData sales, _) => sales.time,
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
          xValueMapper: (LiveData sales, _) => sales.time,
          yValueMapper: (LiveData sales, _) => sales.speed,
          dataLabelSettings: DataLabelSettings(
            isVisible: showBuyMarker,
            builder: (data, point, series, pointIndex, seriesIndex) {
              if (data.pointIndex == buyMarkerIndex) {
                return Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Buy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
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
      double randomChange = (math.Random().nextDouble() - 0.5) * 0.01;
      double newSpeed = chartData[lastDataIndex].speed + randomChange;
      newSpeed = newSpeed.clamp(1.07086, 1.17086);

      chartData.add(LiveData(time++, newSpeed));
      lastDataIndex = chartData.length - 1;

      if (chartData.length > 19) {
        chartData.removeAt(0);
        lastDataIndex--;
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
  final int time;
  final num speed;
}
