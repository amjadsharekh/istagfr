import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:istagfr/app_localization.dart';

class Splash extends StatelessWidget {
  int duration = 0;
  Widget goToPage;

  Splash({this.goToPage, this.duration});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    Future.delayed(Duration(seconds: this.duration), () {
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => this.goToPage));
     // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => this.goToPage));
    });

    return Scaffold(
        body: Container(
      //color: Colors.white,
      alignment: Alignment.center,
      child: Image(
          width: 250,
          height: 250,
          //color: Colors.white,
          image: ExactAssetImage((
            "assets/"+AppLocalization.of(context).translate('logo0'))+".png",
          )),
    ));
  }
}
