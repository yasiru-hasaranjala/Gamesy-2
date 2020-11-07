import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:agora_flutter_quickstart/screens/details_screen.dart';
import 'package:agora_flutter_quickstart/screens/new_event.dart';
import 'package:agora_flutter_quickstart/shared/constants.dart';
import 'package:agora_flutter_quickstart/components/category_card.dart';
import 'package:agora_flutter_quickstart/components/search_bar.dart';

class CreateEvent extends StatelessWidget {

  final List<String> iconPaths = [
    'assets/images/basketball.png',
    'assets/images/volleyball.png',
    'assets/images/football.png',
    'assets/images/badminton.png',
    'assets/images/rugby.png',
    'assets/images/tennis.png',
    'assets/images/cricket.png',
  ];
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 0.03,
                      blurRadius: 2,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: kLightColor,
                  image: DecorationImage(
                    alignment: Alignment.centerLeft,
                    image: AssetImage(
                      "assets/images/undraw_pilates_gpdb.png",
                    ),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 15,right: 15),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      width: size.width*0.9,
                      child: Text(
                        "Create New Event",
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(fontWeight: FontWeight.w700, color: kPrimaryColor),
                      ),
                    ),
                    SearchBar(),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: .85,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: <Widget>[
                      SportCard(
                          iconPaths[0],
                              (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return NewEvent(sport: 'Basketball',);
                                },
                              ),
                            );
                          }
                      ),
                      SportCard(
                          iconPaths[1],
                              (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return NewEvent(sport: 'Volleyball',);
                                },
                              ),
                            );
                          }
                      ),
                      SportCard(
                          iconPaths[2],
                              (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return NewEvent(sport: 'Football',);
                                },
                              ),
                            );
                          }
                      ),
                      SportCard(
                          iconPaths[3],
                              (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return NewEvent(sport: 'Badminton',);
                                },
                              ),
                            );
                          }
                      ),
                      SportCard(
                          iconPaths[4],
                              (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return NewEvent(sport: 'Rugby',);
                                },
                              ),
                            );
                          }
                      ),
                      SportCard(
                          iconPaths[5],
                              (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return NewEvent(sport: 'Tennis',);
                                },
                              ),
                            );
                          }
                      ),
                      SportCard(
                          iconPaths[6],
                              (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return NewEvent(sport: 'Cricket',);
                                },
                              ),
                            );
                          }
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SportCard extends StatelessWidget {
  final String path;
  final Function press;
  SportCard(this.path,this.press);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.fromLTRB(5, 15, 15, 5),
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 10,right: 2, left: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kLightColor,
          boxShadow: [
            BoxShadow(
              spreadRadius: 0.001,
              blurRadius: 2,
              offset: Offset(1, 1), // changes position of shadow
            ),
          ],
          image: DecorationImage(
            image: ExactAssetImage(path),
          ),
        ),
      ),
      onTap: press,
    );
  }
}
