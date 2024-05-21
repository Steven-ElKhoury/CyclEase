// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:cyclease/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cyclease/communication.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import './SelectBondedDevicePage.dart';
//import './ChatPage.dart';

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});
  @override
  _BluetoothPage createState() => _BluetoothPage();
}

class _BluetoothPage extends State<BluetoothPage> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  String _address = "...";
  String _name = "...";


  Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
  ].request();

  statuses.forEach((permission, status) {
    if (status != PermissionStatus.granted) {
      //print('${permission.toString()} permission not granted!');
    }
  });
}


  @override
  void initState() {
    super.initState();
    requestPermissions();
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
          return false;
        }
      await Future.delayed(const Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address ?? '...';
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name ?? '...';
      });
    });

    // Listen for futher state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
  }

  // This code is just a example if you need to change page and you need to communicate to the raspberry again
  void init() async {
    Communication com = Communication();
    await com.connectBl(_address);
    com.sendMessage("Hello");
    setState(() {});
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Bluetooth Serial'),
      ),
      body: ListView(
        children: <Widget>[
          const Divider(),
          const ListTile(title: Text('General')),
          SwitchListTile(
            title: const Text('Enable Bluetooth'),
            value: _bluetoothState.isEnabled,
            onChanged: (bool value) {
              // Do the request and update with the true value then
              future() async {
                // async lambda seems to not working
                if (value) {
                  await FlutterBluetoothSerial.instance.requestEnable();
                } else {
                  await FlutterBluetoothSerial.instance.requestDisable();
                }
              }
      
              future().then((_) {
                setState(() {});
              });
            },
          ),
          ListTile(
            title: const Text('Bluetooth status'),
            subtitle: Text(_bluetoothState.toString()),
            trailing: ElevatedButton(
              child: const Text('Settings'),
              onPressed: () {
                FlutterBluetoothSerial.instance.openSettings();
              },
            ),
          ),
          ListTile(
            title: const Text('Local adapter address'),
            subtitle: Text(_address),
          ),
          ListTile(
            title: const Text('Local adapter name'),
            subtitle: Text(_name),
            onLongPress: null,
          ),
          const Divider(),
          const ListTile(title: Text('Devices discovery and connection')),
          ListTile(
            title: ElevatedButton(
              child: const Text('Connect to paired device'),
              onPressed: () async {
                final BluetoothDevice selectedDevice =
                    await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const SelectBondedDevicePage(checkAvailability: false);
                    },
                  ),
                );
      
                //print('Connect -> selected ' + selectedDevice.address);
                // ignore: use_build_context_synchronously
                _toDashboard(context, selectedDevice);
                            },
            ),
          ),
        ],
      ),
    );
  }

  // void _startChat(BuildContext context, BluetoothDevice server) {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) {
  //         return ChatPage(server: server);
  //       },
  //     ),
  //   );
  // }

  void _toDashboard(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return DashboardPage(server: server);
        },
      ),
    );
  }

}
