import 'package:flutter/material.dart';
import 'package:cyclease/models/user.dart';

class RideProvider with ChangeNotifier {
  String? _rideId;

  String? get rideId => _rideId;

  void setRideId(String? value) {
    _rideId = value;
    notifyListeners();
  }
}