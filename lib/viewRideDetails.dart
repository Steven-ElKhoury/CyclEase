import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cyclease/models/sensordata.dart';
import 'dart:math';

class RideDetailsPage extends StatelessWidget {
  final String rideId;
  final List<SensorData> sensorData;

  RideDetailsPage({
    required this.rideId,
    required this.sensorData,
  });


  @override
  Widget build(BuildContext context) {
    DateTime startTime = sensorData.first.time;  // Get the start time of the ride
    int totalMinutes = sensorData.last.time.difference(startTime).inMinutes + 1;  // Calculate the total duration in minutes
    
    double averagePower = sensorData.map((data) => data.powerPercentage).reduce((a, b) => a + b) / sensorData.length;


    return Scaffold(
      appBar: AppBar(
        title: Text('Ride Details'),
      ),
      body: Column(children: [
        Expanded(
          child:  Padding(
        padding: EdgeInsets.all(16.0),
        child: PageView.builder(
          itemCount: totalMinutes,
          itemBuilder: (context, index) {
            List<SensorData> minuteData = sensorData.where((data) {
              int minute = data.time.difference(startTime).inMinutes;
              return minute == index;
            }).toList();
            List<FlSpot> powerData = minuteData.map((data) => FlSpot(data.time.difference(startTime).inSeconds.toDouble(), data.powerPercentage / 255 * 100)).toList();
            List<FlSpot> balanceData = minuteData.map((data) => FlSpot(data.time.difference(startTime).inSeconds.toDouble(), data.balanceLevel * 33.33)).toList();
            List<FlSpot> speedData = minuteData.map((data) => FlSpot(data.time.difference(startTime).inSeconds.toDouble(), data.speed)).toList();
             
            return ListView(
              children: [
                Text('Power'),
                SizedBox(height: 8),
                SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      minX: index * 60,  // Start time is index * 60
                      maxX: (index + 1) * 60,  // End time is (index + 1) * 60
                      minY: -10,  // Minimum y-value is 0
                      maxY: 100,  // Maximum y-value is 100
                      lineBarsData: [
                        LineChartBarData(
                          spots: powerData,
                          color: Colors.red,  // Power data is red
                        ),
                        LineChartBarData(
                          spots: balanceData,
                          color: Colors.blue,  // Balance level data is blue
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16), 
                Text('Speed'),
               SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    minX: index * 60,  // Start time is index * 60
                    maxX: (index + 1) * 60,  // End time is (index + 1) * 60
                    minY: speedData.map((spot) => spot.y).reduce(min),  // Minimum y-value is the minimum speed
                    maxY: speedData.map((spot) => spot.y).reduce(max),  // Maximum y-value is the maximum speed
                    lineBarsData: [
                      LineChartBarData(
                        spots: speedData,
                        isCurved: true,
                        preventCurveOverShooting: true,  // Prevent the line from overflowing
                      ),
                    ],
                  ),
                ),
              ),
                // Add more charts as needed
              ],
            );
          },
        ),
      ),  
    ),
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Average Power: ${(averagePower/255*100).toStringAsFixed(2)}%',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
  ],)
    );
  }
}