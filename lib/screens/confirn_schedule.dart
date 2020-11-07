import 'package:flutter/material.dart';
import 'package:agora_flutter_quickstart/components/rounded_button.dart';
import 'package:agora_flutter_quickstart/screens/home/home.dart';
import 'package:agora_flutter_quickstart/shared/constants.dart';

class ConfirmSchedule extends StatelessWidget {

  String sport;
  String pw;
  ConfirmSchedule( this.sport, this.pw);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            // Here the height of the container is 45% of our total height
            height: size.height * .45,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              image: DecorationImage(
                alignment: Alignment.centerLeft,
                image: AssetImage("assets/images/undraw_pilates_gpdb.png"),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 15,left: 15, right: 15,bottom: 1),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.07,
                      width: size.width,
                    ),
                    Text(
                      "Confirm Schedule",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(fontWeight: FontWeight.w900, color: kLightColor),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: size.height * 0.03,
                          width: size.width,
                        ),
                        Container(
                          child: Image.asset(
                            'assets/images/players1.png',
                            height: size.height * 0.17,
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Text(
                          "Join for an Event As Admin",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: kLightColor
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Align(
                          alignment: Alignment.center,
                          widthFactor: 5,
                          heightFactor: 2,
                          child: Text(
                            "Event ID",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),

                          ),
                        ),
                        Container(
                          width: size.width *0.8,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          color: kPrimaryColor.withOpacity(0.4),
                          child: Text(
                            sport+'231',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: kLightColor,
                              fontSize: 24
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Align(
                          alignment: Alignment.center,
                          widthFactor: 2.4,
                          heightFactor: 2,
                          child:Text(
                            'Admin Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          width: size.width *0.8,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          color: kPrimaryColor.withOpacity(0.4),
                          child: Text(
                            pw,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: kLightColor,
                                fontSize: 18
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.06),
                        RoundedButton(
                          text: "Confirm",
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Home();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}