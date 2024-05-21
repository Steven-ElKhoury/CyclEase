 class SensorData {
    final DateTime time;
    final double powerPercentage;
    final double speed;
    final int balanceLevel;

  SensorData({
    required this.time,
    required this.powerPercentage,
    required this.speed,
    required this.balanceLevel,
  });

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      time: DateTime.parse(json['timestamp']),
      powerPercentage: json['pwm'].toDouble(),
      speed: json['speed'].toDouble(),
      balanceLevel: json['balanceLevel'] == 'off' || json['balanceLevel']==null ? 0 : json['balanceLevel'],
    );
  }
}
