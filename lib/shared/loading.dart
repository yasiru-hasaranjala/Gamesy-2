import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:agora_flutter_quickstart/shared/constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: kBackgroundColor,
        child: Center(
          child: SpinKitChasingDots(
            color: kPrimaryColor,
            size: 50,
          ),
        ),
      ),
    );
  }
}
