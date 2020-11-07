import 'package:flutter/material.dart';
import 'package:agora_flutter_quickstart/shared/background.dart';
import 'package:agora_flutter_quickstart/components/rounded_button.dart';
class ScoreScreen extends StatefulWidget {
  @override
  _ScoreScreenState createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //body: LoginScreen(),

      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Match- FOE Volleyball match",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              SizedBox(height: size.height * 0.03),
              new Container(
                child: new Image.asset(
                  'assets/images/players1.png',
                  height: size.height * 0.05,
                ),
              ),
              SizedBox(
                height: size.height * 0.1,
                width: size.width * 0.8,
              ),
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(' Team 1 '),
                      Text(' vs '),
                      Text(' Team 2 '),
                    ],
                  ),
                  SizedBox(
                    child: Text('Set 4'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(' 24 '),
                      Text(' : '),
                      Text(' 17 '),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(' 1 sets '),
                      Text(' : '),
                      Text(' 2 sets '),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.1,
                width: size.width * 0.8,
              ),
              RoundedButton(
                text: "Watch Live",
                press: () {

                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
