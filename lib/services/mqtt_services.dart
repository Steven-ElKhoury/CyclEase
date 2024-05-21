import 'dart:convert';
import 'package:cyclease/services/MQTTAppState.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTManager {
  // Private instance of client
  final MQTTAppState _currentState;
  MqttServerClient? _client;
  final String _identifier;
  final String _host;
  final String _topic;

  // Constructor
  // ignore: sort_constructors_first
  MQTTManager(
      {required String host,
      required String topic,
      required String identifier,
      required MQTTAppState state})
      : _identifier = identifier,
        _host = host,
        _topic = topic,
        _currentState = state;

  void initializeMQTTClient() async{
    _client = MqttServerClient(_host, _identifier);
    _client!.port = 1883;
    _client!.keepAlivePeriod = 20;
    _client!.onDisconnected = onDisconnected;
    _client!.secure = false;
    _client!.logging(on: true);

    /// Add the successful connection callback
    _client!.onConnected = onConnected;
    _client!.onSubscribed = onSubscribed;


    final MqttConnectMessage connMess = MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic(
            'willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    _client!.connectionMessage = connMess;
    try {
      await _client?.connect();
    } catch (e) {
      print('Exception: $e');
      _client?.disconnect();
    }

    // Check we are connected
    if (_client?.connectionStatus!.state == MqttConnectionState.connected) {
      print('Client connected');
      _client?.subscribe('sensor_data', MqttQos.atLeastOnce);
    } else {
      print('ERROR: MQTT client connection failed - '
          'disconnecting, state is ${_client?.connectionStatus!.state}');
      _client?.disconnect();
    }

    // Listen for messages
  _client?.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
  final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
  final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message!);

  // Parse the payload
  final data = jsonDecode(payload);

  // Update the state variables
  _currentState.setUltrasonicData((data['UltraSonic'].toDouble()));
  _currentState.setSpeed((data['tachometer']).toDouble());
  _currentState.setPwm((data['PWM']).toDouble());
  _currentState.setImuData((data['IMU']).toDouble());
});
}

  // Connect to the host
  // ignore: avoid_void_async
  void connect() async {
    assert(_client != null);
    try {
      print('EXAMPLE::Mosquitto start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client!.connect();
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      disconnect();
    }
  }

  void disconnect() {
    print('Disconnected');
    _client!.disconnect();
  }

  void publish(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client!.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload!);
  }

  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  /// The successful connect callback
  void onConnected() {
    print('EXAMPLE::OnConnected client callback - Client connection was successful');
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
  }
}