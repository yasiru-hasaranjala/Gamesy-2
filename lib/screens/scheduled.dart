import 'package:agora_flutter_quickstart/models/event.dart';
import 'package:agora_flutter_quickstart/services/auth.dart';
import 'package:agora_flutter_quickstart/src/pages/call.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:agora_flutter_quickstart/shared/constants.dart';

class Scheduled extends StatefulWidget {

  @override
  _ScheduledState createState() => _ScheduledState();
}

class _ScheduledState extends State<Scheduled> {

  final List<String> iconPaths = [
    'assets/images/basketball.png',
    'assets/images/volleyball.png',
    'assets/images/football.png',
    'assets/images/badminton.png',
    'assets/images/rugby.png',
    'assets/images/tennis.png',
    'assets/images/cricket.png',
  ];

  final databaseReference = Firestore.instance;
  int eventCount=0;
  List<String> names = [];
  List<String> descriptions = [];
  List<String> organizers = [];
  List<String> sports = [];

  @override
  void initState() {
    listEvent();
    getEvent();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //this gonna give us total height and with of our device
    return Stack(
      children: <Widget>[
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 2),
                decoration: BoxDecoration(
                  color: kBackgroundColor,
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
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.all(15),
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
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 15,bottom: 4),
                      child: Text(
                        'Open Events',
                        style: Theme.of(context)
                            .textTheme
                            .headline4
                            .copyWith(fontWeight: FontWeight.w900, color: kPrimaryColor,),
                      ),
                    ),
                  ],
                ),
              ),
              eventCount == 0 ? Container() : Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                  alignment: Alignment.center,
                  child: GridView.count(
                    crossAxisCount: 1,
                    childAspectRatio: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 15,
                    children: List.generate(eventCount, (index) {
                      return EventCard(names[index], descriptions[index],
                          organizers[index], sports[index] );
                    }),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void getEvent() async{
    await databaseReference
        .collection("events")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
     setState(() {
       eventCount=snapshot.documents.length;
     });
    });
  }

  void listEvent() async{
    await databaseReference
        .collection('events')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {
        setState(() {
          names.add(f.data['name']);
          descriptions.add(f.data['des']);
          organizers.add(f.data['organizer']);
          //print(f.data['des'].split(' ')[0].toLowerCase());
          sports.add(f.data['des'].split(' ')[0].toLowerCase());
        });
      });
    });
  }
}

class EventCard extends StatefulWidget {

  final name;
  final des;
  final organizer;
  final sport;
  EventCard(this.name,this.des,this.organizer,this.sport);
  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context)
        .size; //this gonna give us total height and with of our device
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              spreadRadius: 0.01,
              blurRadius: 1,
              offset: Offset(0.5, 0.5), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Image.asset(
                'assets/images/'+widget.sport+'.png',
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, left: 10),
              width: size.width * 0.56,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.name,
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                    softWrap: false,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      fontWeight: FontWeight.w900,
                      color: kPrimaryColor,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.organizer,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      fontWeight: FontWeight.w500,
                      color: kPrimaryColor.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(height: 9,),
                  Text(
                    widget.des,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    softWrap: false,
                    style: Theme.of(context).textTheme.headline4.copyWith(
                      fontWeight: FontWeight.w600,
                      color: kPrimaryColor.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ButtonTheme(
                        height: 30,
                        minWidth: 90,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: RaisedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallPage(
                                  channelName: capitalize(widget.sport+'231'),
                                  role: ClientRole.Audience,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Watch Now',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white
                            ),
                          ),
                          color: kPrimaryColor,
                        ),
                      ),
                      ButtonTheme(
                        height: 30,
                        minWidth: 90,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: RaisedButton(
                          onPressed: () {},
                          child: const Text(
                            'Details',
                            style: TextStyle(
                                fontSize: 11,
                                color: kPrimaryColor
                            ),
                          ),
                          color: kLightColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  String capitalize(word) {
    return "${word[0].toUpperCase()}${word.substring(1)}";
  }
}
