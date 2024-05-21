import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cyclease/services/ride_services.dart';
import 'package:cyclease/viewRideDetails.dart';
import 'package:cyclease/models/sensordata.dart';

class RideInfoWidget extends StatefulWidget {
  final String rideId;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final double caloriesBurned;
  final double distanceTraveled;
  final int duration;
  final List<Ride> rides;

  final void Function(String) onDelete;

  RideInfoWidget({
    required this.rideId,
    required this.startDateTime,
    required this.endDateTime,
    required this.caloriesBurned,
    required this.distanceTraveled,
    required this.duration,
    required this.rides,
    required this.onDelete,
  });

  @override
  _RideInfoWidgetState createState() => _RideInfoWidgetState();
}

 class _RideInfoWidgetState extends State<RideInfoWidget> {
  @override
  Widget build(BuildContext context) {
    Duration rideDuration = Duration(seconds: widget.duration);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(rideDuration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(rideDuration.inSeconds.remainder(60));

    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ride'),
                SizedBox(height: 8),
                Text('Start: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.startDateTime)}'),
                Text('End: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.endDateTime)}'),
                Text('Calories Burned: ${widget.caloriesBurned.toStringAsFixed(2)}'),
                Text('Distance Traveled: ${widget.distanceTraveled.toStringAsFixed(2)} km'),
                Text('Duration: ${rideDuration.inHours}:$twoDigitMinutes:$twoDigitSeconds'),
              ],
            ),
            Positioned(
              right: 0,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  deleteRide(widget.rideId);
                  widget.onDelete(widget.rideId);
                }
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: IconButton(
                icon: Icon(Icons.arrow_forward),
              onPressed: () async {
                try {
                  List<SensorData> sensorData = await getSensorData(widget.rideId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RideDetailsPage(
                        rideId: widget.rideId,
                        sensorData: sensorData,
                      ),
                    ),
                  );
                } catch (e) {
                  print('Error getting sensor data: $e');
                }
              },
              ),
            ),
          ],
        ),
      ),
    );
  }
}