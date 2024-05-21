import 'package:cyclease/services/MQTTAppState.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrainerPage extends StatefulWidget {
  @override
  _TrainerPageState createState() => _TrainerPageState();
}

class _TrainerPageState extends State<TrainerPage> {
  MQTTAppState? _currentState;

  @override
  Widget build(BuildContext context) {
    _currentState = Provider.of<MQTTAppState>(context, listen: true);
    double imuData = _currentState?.getImuData ?? 0;  // Get the IMU data from the MQTTAppState

    // Calculate the color based on imuData
    double absImuData = imuData.abs();
    double colorValue = (absImuData > 2 ? 1 : absImuData) * 255;
    Color color = Color.lerp(Colors.green, Colors.red, colorValue)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Trainer'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        color: color,
        child: Center(
          child: imuData < 0 ? Icon(Icons.arrow_back, size: 100.0) : Icon(Icons.arrow_forward, size: 100.0),  // Arrow
        ),
      ),
    );
  }
}