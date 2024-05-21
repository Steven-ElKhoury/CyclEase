// ignore_for_file: library_private_types_in_public_api
import 'package:audioplayers/audioplayers.dart';
import 'package:cyclease/audio_player.dart';
import 'package:cyclease/bluetooth_connect.dart';
import 'package:cyclease/choose_profile.dart';
import 'package:cyclease/profile_container.dart';
import 'package:cyclease/providers/profile_provider.dart';
import 'package:cyclease/services/MQTTAppState.dart';
import 'package:cyclease/services/mqtt_services.dart';
import 'package:cyclease/trainer.dart';
import 'package:cyclease/viewRides.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:cyclease/custom_formfield.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cyclease/services/ride_services.dart';
import 'package:cyclease/providers/ride_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class DashboardPage extends StatefulWidget {
  final BluetoothDevice? server;
  
  const DashboardPage({super.key, this.server});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _Message {
  int whom;  
  String text;

  _Message(this.whom, this.text);
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isRidingSessionActive = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static const clientID = 0;
  BluetoothConnection? connection;
  int _secondsElapsed = 0;
  Timer? _timer;
  List<_Message> messages = <_Message>[];
  String _messageBuffer = '';
  late MQTTManager? _manager;
  double _totalCaloriesBurned = 0;
  double currentSpeed = 0;
  double weight = 0;
  double _distanceTraveled = 0;
  final AudioPlayer player = AudioPlayer();
  
  
  void initializeMQTT() {
   MQTTAppState _currentState = Provider.of<MQTTAppState>(context, listen: false);
  _manager = MQTTManager(
    host: '', // Replace with your MQTT broker's IP
    topic: 'sensor_data', // Replace with your topic
    identifier: 'dashboard', // Replace with a unique identifier for this client
    state: _currentState!, // Create a new MQTTAppState
  );

  _manager?.initializeMQTTClient();
}

  String? _selectedBalancingAidLevel;

  bool isConnecting = true;
  bool get isConnected => connection?.isConnected ?? false;

  bool isDisconnecting = false;

  void requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
}

int calculateMetValue(speed){
  int metValue = 0;
  if (speed < 16) {
    metValue = 4;
  } else if (speed < 19) {
    metValue = 6; 
  } else if (speed < 22) {
    metValue = 8;
  } else if (speed < 26) {
    metValue = 10;
  } else {
    metValue = 16;
  }
  return metValue;
}

void toggleRidingSession() async {
  if (_isRidingSessionActive) {
    String? rideId = Provider.of<RideProvider>(context, listen: false).rideId;
    stopRide(_distanceTraveled, _secondsElapsed, _totalCaloriesBurned, rideId!);
    // Cancel the timer
    _timer?.cancel();
    _timer = null;

    _manager?.disconnect();

  } else {
    MQTTAppState _currentState = Provider.of<MQTTAppState>(context, listen: false);
    
    initializeMQTT();

    if(_selectedBalancingAidLevel == null){
      _selectedBalancingAidLevel = 'Off';
    }
    
    // Reset values in MQTTAppSate
    _currentState.setSpeed(0.0);
    _currentState.setPwm(0.0);
    _currentState.setUltrasonicData(0.0);

    // Reset elapsed time and total calories burned
    _secondsElapsed = 0;
    _totalCaloriesBurned = 0;
    _distanceTraveled = 0;

    _sendMessage('Weight: '+ weight.toString());

    String childId = Provider.of<ProfileProvider>(context, listen: false).selectedProfile!.childId;
    String rideId = await startRide(childId);
    Provider.of<RideProvider>(context, listen: false).setRideId(rideId);

  
    // Start the timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
        
        //caloriesBurned
        int metValue = calculateMetValue(_currentState.getSpeed);
        weight = Provider.of<ProfileProvider>(context, listen: false).selectedProfile!.weight;
        double caloriesBurned = 0.0175 * metValue * weight * 1 / 60;
        _totalCaloriesBurned += caloriesBurned;

        // Distance Traveled
       _distanceTraveled += _currentState.getSpeed * 1/3600.0; // Assuming speed is in km per hour

       if (_currentState.getUltrasonicData < 40) {
            player.play(AssetSource('/assets/audio/alert.mp3'));
          }
          else{
            player.stop();
          }
      });

      sendSensorData(rideId, _currentState.getSpeed, _currentState.getPwm, _currentState.getImuData, _selectedBalancingAidLevel);

    });
  }
  setState(() {
    _isRidingSessionActive = !_isRidingSessionActive;
  });
}
  @override
  void initState() {
    super.initState();
    if (widget.server != null) {
      // ignore: no_leading_underscores_for_local_identifiers
    BluetoothConnection.toAddress(widget.server?.address ?? '').then((_connection){
      //print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
      connection?.input?.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          //print('Disconnecting locally!');
        } else {
          //print('Disconnected remotely!');
        }
        if (mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      //print('Cannot connect, exception occured');
      //print(error);
    });
  }
  }

   @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
    } 
    super.dispose();
  }

   Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         leading: Builder(
          builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
        actions: [
        Container(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BluetoothPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: Colors.blue[500],
              elevation: 3.0, // This controls the size of the shadow
            ),
            child: const Icon(Icons.bluetooth, color: Colors.white),
          ),
          ),
          const SizedBox(width:10),
           SizedBox(
             child: ElevatedButton(
               onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? emergencyContact = prefs.getString('emergencyContact');
                  if (emergencyContact != null && emergencyContact.isNotEmpty) {
                    // Make a phone call
                    Uri url = Uri.parse('tel:$emergencyContact');
                    _launchInBrowser(url);
                  }
                },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                backgroundColor: Colors.red[400],
                elevation: 3.0, // This controls the size of the shadow
              ),
              child: const Icon(Icons.warning_rounded, color: Colors.white,),
                       ),
           ),
          const SizedBox(width:10),
           SizedBox(
          child: ElevatedButton(
              onPressed: () async {
                requestStoragePermission();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MediaPlayer()),
                );  
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                elevation: 3.0, // This controls the size of the shadow
              ),
              child: const Icon(Icons.music_note),

                       ),
           ),
          const SizedBox(width:10),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
             DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
                  return      
                  SizedBox(
                    width: 110,
                    height: 110,
                    child: ProfileContainer(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ChooseProfile(),)
                        );
                      },
                      imageUrl: profileProvider.selectedProfile?.imageUrl ?? '',
                      name: profileProvider.selectedProfile?.name ?? '',
                    ),
                  );
                }
              ),
              ],
            ),
            ),

           ListTile(
                  leading: const Icon(Icons.directions_bike), // Add an icon
                  title: const Text('View Rides'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewRides(profileId: Provider.of<ProfileProvider>(context, listen: false).selectedProfile!.childId)), // Replace 'your-profile-id' with the actual profile ID
                    );
                  },
                ),
            ListTile(
              leading: const Icon(Icons.fitness_center),
              title: const Text('Trainer'),
              onTap:(){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrainerPage()),
                );
              },
            ),
            ListTile(
              leading:const Icon(Icons.account_circle),
              title: const Text('Emergency Contact'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    final TextEditingController _nameController = TextEditingController();
                    final TextEditingController _numberController = TextEditingController();

                    return AlertDialog(
                      title: const Text('Emergency Contact'),
                      content: Form(
                        key: _formKey, // Define this key in your widget
                        child: Column(
                          children: <Widget>[
                            Form(
                                child: Column(
                                children: [
                                CustomFormField(obscureText: false, validator: 'Please enter a name', placeholder: 'Name', textEditingController: _nameController, dataType: 'string',),
                                const SizedBox(height: 10.0),
                                CustomFormField(obscureText: false, validator: 'Please enter a valid number', placeholder: 'Number', textEditingController: _numberController, dataType: 'int'),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),    
                            Row(  
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    await prefs.setString('emergencyContact', _numberController.text);
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text('Submit'),
                              ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            ],
                            ),
                            ],
                        ),
                      ),    
                    );
                  },
                );
              },
            ),
           
          ],
        ),
      ),
     body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          buildBalancingAidLevelWidget(),
          buildTimeSpentRidingWidget(),
          buildDistanceTraveledWidget(),
          buildCurrentSpeedWidget(),
          buildPowerWidget(),
          buildCaloriesBurnedWidget(),
              ],
            ),
    bottomNavigationBar: Padding(
    padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
      onPressed: () {
        toggleRidingSession();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _isRidingSessionActive? Colors.red : Colors.blue,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        _isRidingSessionActive ? 'Stop Riding Session': 'Start Riding Session',
        style: const TextStyle(color: Colors.white),
      ),
    ),
  ),

    );
  }

    Widget buildBalancingAidLevelWidget() {
    return buildContainer(
      'Balancing Aid Level',
      DropdownButtonFormField<String>(
        isExpanded: true,
        value: _selectedBalancingAidLevel,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        hint: const Text('Select Balance Level'),
        style: const TextStyle(color: Colors.black),
        dropdownColor: Colors.grey[200],
        items: <String>['3', '2', '1', 'Off'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedBalancingAidLevel = newValue;
          });          
            _sendMessage(_selectedBalancingAidLevel.toString());
        },
      ),
    );
  }

  Widget buildTimeSpentRidingWidget() {
  int hours = _secondsElapsed ~/ 3600;
  int minutes = (_secondsElapsed % 3600) ~/ 60;
  int seconds = _secondsElapsed % 60;

  String timeSpentRiding = '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return buildContainer(
      'Time Spent Riding',
       Text(timeSpentRiding), // Placeholder value
    );
  }

Widget buildDistanceTraveledWidget() {
  
  return buildContainer(
    'Distance Traveled',
    Text('${(_distanceTraveled).toStringAsFixed(2)} km'),
  );
}

Widget buildCurrentSpeedWidget() {
  MQTTAppState _currentState = Provider.of<MQTTAppState>(context, listen: true);
    return buildContainer(
      'Current Speed',
       Text('${(_currentState.getSpeed).toStringAsFixed(2)} km/h'), // Placeholder value
    );
}

  Widget buildPowerWidget() {
    MQTTAppState _currentState = Provider.of<MQTTAppState>(context, listen: true);
    return buildContainer(
      'Power',
      Text('${(_currentState.getPwm/255 *100).toStringAsFixed(2)} %'), // Assuming power is in watts
    );
  }

  Widget buildCaloriesBurnedWidget() {
    return buildContainer(
      'Calories Burned',
       Text('${_totalCaloriesBurned.toStringAsFixed(2)} calories'), // Placeholder value
    );
  }

  Widget buildContainer(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          child,
        ],
      ),
    );
  }
   void _onDataReceived(Uint8List data) {
    
    
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    // ignore: avoid_function_literals_in_foreach_calls
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);

    if(dataString.trim() == 'startMQTT'){
      initializeMQTT();

    }else{

    }

    if(dataString.trim() == 'stopMQTT'){
      _manager?.disconnect();
    }

  //    if (dataString.trim() != null) {

  //   }else{
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(dataString),
  //         content: const Text('The Raspberry Pi did not receive the command.'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('OK'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }


  }

  void _sendMessage(String text) async {
    text = text.trim();
    //textEditingController.clear();

    if (text.isNotEmpty) {
      try {
        // ignore: prefer_interpolation_to_compose_strings
        connection?.output.add(utf8.encode(text + "\r\n"));
        await connection?.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(const Duration(milliseconds: 333)).then((_) {
          //listScrollController.animateTo(
            //  listScrollController.position.maxScrollExtent,
              //duration: Duration(milliseconds: 333),
              //curve: Curves.easeOut);
        });
      } catch (e) { 
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }

}
