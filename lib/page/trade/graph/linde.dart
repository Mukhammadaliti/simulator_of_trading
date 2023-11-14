import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Linde extends StatefulWidget {
  const Linde({Key? key}) : super(key: key);

  @override
  _LindeState createState() => _LindeState();
}

class _LindeState extends State<Linde> {
  late List<LiveData> chartData;
  late int lastDataIndex;

  void initState() {
    chartData = getChartData();
    lastDataIndex = chartData.length - 1;
    Timer.periodic(const Duration(seconds: 2), updateDataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SfCartesianChart(
          borderWidth: 0,
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
      LiveData(2, 1.10524),
      LiveData(3, 1.10526),
      LiveData(4, 1.10528),
      LiveData(5, 1.10530),
      LiveData(6, 1.10532),
      LiveData(7, 1.10534),
      LiveData(8, 1.10636),
      LiveData(9, 1.10638),
      LiveData(10, 1.10640),
      LiveData(11, 1.10642),
    ];
  }
}

class LiveData {
  LiveData(this.time, this.speed);
  final int time;
  final num speed;
}
