import 'package:agora_flutter_quickstart/src/pages/call.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:agora_flutter_quickstart/components/rounded_button.dart';
import 'package:agora_flutter_quickstart/components/rounded_input_field.dart';
import 'package:agora_flutter_quickstart/components/rounded_password_field.dart';
import 'package:agora_flutter_quickstart/shared/constants.dart';
import 'package:agora_flutter_quickstart/services/database.dart';

class AsAdmin extends StatefulWidget {
  @override
  _AsAdminState createState() => _AsAdminState();
}

class _AsAdminState extends State<AsAdmin> {

  String eventID;
  final DatabaseService  _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Stack(
      children: <Widget>[
        Container(
          // Here the height of the container is 45% of our total height
          height: size.height * .45,
          decoration: BoxDecoration(
            color: Colors.indigo,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      child: Container(
                        height: 46,
                        width: 52,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/users/man.jpg'),
                              fit: BoxFit.fill,
                              alignment: Alignment.topCenter,
                            ),
                            border: Border.all(color: kPrimaryLightColor)
                        ),

                      ),
                      onTap: (){
                        Scaffold.of(context).openEndDrawer();
                      },
                    ),
                  ),
                  Text(
                    "Start As Admin",
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
                      SizedBox(height: size.height * 0.01),
                      Text(
                        'Join for an Event As Admin',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: kLightColor
                        ),
                      ),
                      SizedBox(height: size.height * 0.13),
                      Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: 5,
                        child: Text(
                          'Event ID',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      RoundedInputField(
                        hintText: 'Event ID',
                        onChanged: (value) {
                          setState(() {
                            eventID = value;
                          });
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
                      RoundedButton(
                        text: 'Start Now',
                        color: Colors.indigo,
                        press: () async {
                          //await _db.saveMatch('Team1','Team2',0,0,0,0);
                          switch (eventID) {
                            case 'Football231':
                              go();
                              break;
                            case 'Volleyball231':
                              go();
                              break;
                            case 'Tennis231':
                              go();
                              break;
                            case 'Basketball231':
                              go();
                              break;
                            case 'Cricket231':
                              go();
                              break;
                            case 'Rugby231':
                              go();
                              break;
                            case 'Badminton231':
                              go();
                              break;
                            default:
                              _showPicker;
                              break;
                          }
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
    );
  }
  void go() async{
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CallPage(
          channelName: eventID,
          role: ClientRole.Broadcaster,
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              margin: EdgeInsets.only(bottom: 60),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      title: Text('Wrong EventID'),
                      onTap: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          );
        }
    );
  }
}