import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:istagfr/utils.dart';
import 'package:vibration/vibration.dart';

class PowerMode extends StatefulWidget {
  @override
  _PowerModeState createState() => _PowerModeState();
}

class _PowerModeState extends State<PowerMode> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
  }

  int _counter = Utils.counterText['count'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor:  Colors.black,
      //  brightness: Brightness.dark,
        elevation: 0,
      ),
      body: InkWell(
        onLongPress: () {
          if (Utils.val) {
            Vibration.vibrate(duration: 100);
          }

          setState(() {
            _counter = 0;
            Utils.saveData(_counter);
          });
        },
        onTap: () {
          if (Utils.val) {
            Vibration.vibrate(duration: 30);
          }
          if (_counter == Utils.custm - 1 && Utils.val2 == true) {
            Vibration.vibrate(duration: 500);
          }
          setState(() {
            _counter++;
            Utils.saveData(_counter);
          });
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            "$_counter",
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
