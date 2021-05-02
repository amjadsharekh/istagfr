import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  int x =  prefs.getInt('favC');
  static dynamic counterText = {"count": "ابدأ الاستغفار", "color": Color(0xFF1B6948)};
  static bool val = false;
  static bool val2 = false;
  static int custm = 0;
  static SharedPreferences prefs;
  static SharedPreferences prefss;
  static SharedPreferences prefsss;
  static SharedPreferences prefssss;

  static saveData(int color) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      'favC',
      color,
    );
  }

  static getData() async {
    prefs = await SharedPreferences.getInstance();
    // setState(() {
    counterText['count'] = prefs.getInt('favC') ?? 0;
    // });
  }

  static saveDataaaa(bool color) async {
    prefssss = await SharedPreferences.getInstance();
    await prefssss.setBool(
      'favCCCC',
      color,
    );
  }

  static getDataaaa() async {
    prefssss = await SharedPreferences.getInstance();
    //setState(() {
    val2 = prefssss.getBool('favCCCC') ?? false;
    //});
  }

  static saveDataaa(int color) async {
    prefsss = await SharedPreferences.getInstance();
    await prefsss.setInt(
      'favCCC',
      color,
    );
  }

  static getDataaa() async {
    prefsss = await SharedPreferences.getInstance();
    // setState(() {
    custm = prefsss.getInt('favCCC') ?? 0;
    // });
  }

  static saveDataa(bool color) async {
    prefss = await SharedPreferences.getInstance();
    await prefss.setBool(
      'favCC',
      color,
    );
  }

  static getDataa() async {
    prefss = await SharedPreferences.getInstance();
    // setState(() {
    val = prefss.getBool('favCC') ?? false;
    // });
  }

  static Future openLink({
    @required String url,
  }) =>
      _launchUrl(url);

  static Future openEmail({
    @required String toEmail,
    @required String subject,
    @required String body,
  }) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';

    await _launchUrl(url);
  }

  static Future _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
/*

  static Future openPhoneCall({@required String phoneNumber}) async {
    final url = 'tel:$phoneNumber';

    await _launchUrl(url);
  }

  static Future openSMS({@required String phoneNumber}) async {
    final url = 'sms:$phoneNumber';

    await _launchUrl(url);
  }


  */
}
