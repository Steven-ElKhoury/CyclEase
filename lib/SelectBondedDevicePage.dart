import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import './BluetoothDeviceListEntry.dart';

class SelectBondedDevicePage extends StatefulWidget {
  final bool checkAvailability;

  const SelectBondedDevicePage({super.key, this.checkAvailability = true});

  @override
  _SelectBondedDevicePage createState() => new _SelectBondedDevicePage();
}

enum _DeviceAvailability {
  // ignore: unused_field
  no,
  maybe,
  yes,
}

class _DeviceWithAvailability {
  BluetoothDevice? device;
  _DeviceAvailability availability;
  int rssi;

  _DeviceWithAvailability(this.device, this.availability, [this.rssi = 0]);
}

class _SelectBondedDevicePage extends State<SelectBondedDevicePage> {
  List<_DeviceWithAvailability> devices = <_DeviceWithAvailability>[];

  StreamSubscription<BluetoothDiscoveryResult>? _discoveryStreamSubscription;
  bool _isDiscovering = false;

  _SelectBondedDevicePage();

  @override
  void initState() {
    super.initState();

    _isDiscovering = widget.checkAvailability;

    if (_isDiscovering) {
      _startDiscovery();
    }

    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .map(
              (device) => _DeviceWithAvailability(
                device,
                widget.checkAvailability
                    ? _DeviceAvailability.maybe
                    : _DeviceAvailability.yes,
              ),
            )
            .toList();
      });
    });
  }

  void _restartDiscovery() {
    setState(() {
      _isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        Iterator i = devices.iterator;
        while (i.moveNext()) {
          // ignore: no_leading_underscores_for_local_identifiers
          var _device = i.current;
          if (_device.device == r.device) {
            _device.availability = _DeviceAvailability.yes;
            _device.rssi = r.rssi;
          }
        }
      });
    });

    _discoveryStreamSubscription?.onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }

  @override
  void dispose() {
    _discoveryStreamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDeviceListEntry> list = devices
        // ignore: no_leading_underscores_for_local_identifiers
        .map((_device) => BluetoothDeviceListEntry(
              device: _device.device!,
              rssi: _device.rssi,
              enabled: _device.availability == _DeviceAvailability.yes,
              onTap: () {
                Navigator.of(context).pop(_device.device);
              },
            ))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select device'),
        actions: <Widget>[
          _isDiscovering
              ? FittedBox(
                  child: Container(
                    margin:const  EdgeInsets.all(16.0),
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.replay),
                  onPressed: _restartDiscovery,
                )
        ],
      ),
      body: ListView(children: list),
    );
  }
}