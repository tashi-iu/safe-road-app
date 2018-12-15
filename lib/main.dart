import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import './util/upload.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, double> _startLocation;
  Map<String, double> _currentLocation;

  StreamSubscription<Map<String, double>> _locationSubscription;

  Location _location = new Location();
  bool _permission = false;
  String error;

  bool currentWidget = true;

  bool _switchBool = false;

  @override
  void initState() {
    super.initState();

    initPlatformState();

    _locationSubscription =
        _location.onLocationChanged().listen((Map<String, double> result) {
      setState(() {
        _currentLocation = result;
      });
    });
  }

  initPlatformState() async {
    Map<String, double> location;

    try {
      _permission = await _location.hasPermission();
      location = await _location.getLocation();

      error = null;
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
            'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }

    setState(() {
      _startLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: new Text(
          'Dashboard',
          style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w700,
              color: Colors.black87),
        ),
        actions: <Widget>[
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _switchBool ? Colors.green : Colors.red,
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 16.0),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 24.0),
          )
        ],
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 18.0),
            child: Text(_currentLocation != null
                ? 'Latitude: ${_currentLocation.values.elementAt(2)}\n'
                : 'Error: $error\n'),
          ),
          Container(
            padding: EdgeInsets.only(left: 18.0),
            child: Text(_currentLocation != null
                ? 'Longitude: ${_currentLocation.values.elementAt(5)}\n'
                : 'Error: $error\n'),
          ),
          Container(
            padding: EdgeInsets.only(left: 18.0),
            child: Text(
                _permission ? 'Has permission : Yes' : "Has permission : No"),
          ),
          SwitchListTile(
            title: const Text('Record location information'),
            value: _switchBool,
            onChanged: (bool value) {
              setState(() {
                _toggleFunc();
                _switchBool = value;
              });
            },
            secondary: const Icon(Icons.cloud_upload),
          ),
        ],
      ),
    ));
  }

  void _toggleFunc() {
    if (!_switchBool) {
      const fiveSec = const Duration(seconds: 5);
      new Timer.periodic(fiveSec, (Timer T) {
        postData(_currentLocation);
      });
      print("Tracking ON");
    } else {
      print("Tracking OFF");
      return null;
    }
  }
}
