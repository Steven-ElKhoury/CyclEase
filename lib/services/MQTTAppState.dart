import 'package:flutter/cupertino.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }
class MQTTAppState with ChangeNotifier {
  MQTTAppConnectionState _appConnectionState = MQTTAppConnectionState.disconnected;
  double _imuData = 0.0;
  double _speed = 0.0; // Assuming speed is a double
  double _pwm = 0.0; // Assuming pwm is a double
  double _ultrasonicData = 0.0; // Assuming ultrasonic data is a double

  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  void setImuData(double data) {
    _imuData = data;
    notifyListeners();
  }

  void setSpeed(double speed) {
    _speed = speed;
    notifyListeners();
  }

  void setPwm(double pwm) {
    _pwm = pwm;
    notifyListeners();
  }

  void setUltrasonicData(double data) {
    _ultrasonicData = data;
    notifyListeners();
  }

  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;
  double get getImuData => _imuData;
  double get getSpeed => _speed;
  double get getPwm => _pwm;
  double get getUltrasonicData => _ultrasonicData;
}