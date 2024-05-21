import 'dart:ffi';
import 'package:cyclease/providers/profile_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cyclease/utils/constants.dart';
import 'package:cyclease/models/sensordata.dart';

Future<String> startRide(String childId) async {
  final response = await http.post(
    Uri.parse('${Constants.uri}/api/startride'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'childId': childId,
      'startDateTime': DateTime.now().toIso8601String(),
    }),
  );

  if (response.statusCode == 201) {
     Map<String, dynamic> responseBody = jsonDecode(response.body);
     return responseBody['rideId'];
  } else {
    // If the server returns an unsuccessful response code, then throw an exception.
    return '';
  }
}

Future<void> sendSensorData(String rideId, double speed, double pwm, double rollAngle, String? balanceLevel) async {
  final response = await http.post(
    Uri.parse('${Constants.uri}/api/addSensorData/$rideId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'speed': speed,
      'pwm': pwm,
      'rollAngle': rollAngle,
      'balanceLevel': balanceLevel == null ? null : int.parse(balanceLevel),
      'timestamp': DateTime.now().toIso8601String(),
    }),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to send sensor data');
  }
}

Future<void> stopRide(double distance, int duration, double caloriesBurned, String rideId) async{
  final response = await http.put(
    Uri.parse('${Constants.uri}/api/stopride/$rideId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'distance': distance,
      'duration': duration,
      'caloriesBurned': caloriesBurned,
      'endDateTime': DateTime.now().toIso8601String(),
    }),
  );

  if (response.statusCode != 200) {
    // If the server did not return a 200 OK response, throw an exception.
    throw Exception('Failed to stop ride'); 
  }
}

Future<List<Ride>> getRides(String profileId) async {
  final response = await http.get(Uri.parse('${Constants.uri}/api/rides/$profileId'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((ride) => Ride.fromJson(ride)).toList();
  } else {
    throw Exception('Failed to load rides');
  }
}

class Ride {
  final String rideId;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final double caloriesBurned;
  final double distanceTraveled;
  final int duration;

  Ride({
    required this.rideId,
    required this.startDateTime,
    required this.endDateTime,
    required this.caloriesBurned,
    required this.distanceTraveled,
    required this.duration,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      rideId: json['_id'] ?? '',
      startDateTime: DateTime.parse(json['startDateTime']).add(Duration(hours: 3)),
      endDateTime: DateTime.parse(json['endDateTime']).add(Duration(hours: 3)),
      caloriesBurned: json['caloriesBurned'] != null ? json['caloriesBurned'].toDouble() : 0.0,
      distanceTraveled: json['distance'] != null ? json['distance'].toDouble() : 0.0,
      duration: json['duration'] ?? 0,
    );
  }
}

Future<void> deleteRide(String rideId) async {
    final response = await http.delete(
      Uri.parse('${Constants.uri}/api/deleteRide/$rideId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete ride');
    }
  }


 Future<List<SensorData>> getSensorData(String rideId) async {
    final response = await http.get(
      Uri.parse('${Constants.uri}/api/getSensorData/$rideId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => SensorData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load sensor data');
    } 
  }

