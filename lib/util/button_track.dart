import 'package:flutter/material.dart';

class ButtonTrack extends StatefulWidget {
  @override
  _ButtonTrackState createState() => new _ButtonTrackState();
}

class _ButtonTrackState extends State<ButtonTrack> {
  bool _switchBool = false;
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: const Text('Record location information'),
      value: _switchBool,
      onChanged: (bool value) {
        setState(() {
          _toggleFunc();
          _switchBool = value;
        });
      },
      secondary: const Icon(Icons.cloud_upload),
    );
  }
  void _toggleFunc() {
    if (_switchBool){
      // turn on sending/saving data
    }else {
      // turn off sending/saving data
    }
  }
}
