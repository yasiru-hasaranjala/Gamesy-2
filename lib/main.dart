import 'package:flutter/material.dart';

import 'package:agora_flutter_quickstart/screens/wrapper.dart';
import 'package:agora_flutter_quickstart/services/auth.dart';
import 'package:agora_flutter_quickstart/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:agora_flutter_quickstart/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: kBlueColor,
          backgroundColor: kPrimaryColor,
          focusColor: kPrimaryColor,
          accentColor: kPrimaryColor,
          cursorColor: kBlueColor,
          hoverColor: kPrimaryColor,
          cardColor: kPrimaryLightColor,
          splashColor: kPrimaryColor,
          primarySwatch: createMaterialColor(Color(0xFF6F35A5)),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper(),
      ),
    );
  }

  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }
}
