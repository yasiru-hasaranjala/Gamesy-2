import 'package:agora_flutter_quickstart/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:agora_flutter_quickstart/screens/authenticate/sign_in.dart';
import 'package:agora_flutter_quickstart/services/auth.dart';
// ignore: must_be_immutable
class DrawerRight extends StatefulWidget {

  DrawerRight({
    Key key,
  }):super(key:key);
  @override
  _DrawerRightState createState() => _DrawerRightState();
}

class _DrawerRightState extends State<DrawerRight> {
  final AuthService _auth = AuthService();

  final databaseReference = Firestore.instance;

  String name = '';

  String email = '';

  String number = '';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Drawer(
      child: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                          color: kActiveIconColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(Icons.arrow_back, color: kLightColor),
                      ),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    StreamBuilder(
                        stream: Firestore.instance.collection('users').snapshots(),
                        builder: (context, snapshot) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                name ==''? 'Fetching Name...':name,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kDarkColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 1),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.email, color: kDarkColor ,size: 17),
                                    Text(
                                      name ==''? 'Fetching Email...':' '+email,
                                      style: TextStyle(
                                        wordSpacing: 2,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.call, color: kDarkColor ,size: 14),
                                    Text(
                                      ' 0770832456',
                                      style: TextStyle(
                                        fontSize: 12,
                                        wordSpacing: 2,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                    ),
                    GestureDetector(
                      child: Container(
                        height: 80,
                        width: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('assets/images/users/man.jpg'),
                            fit: BoxFit.fill,
                            alignment: Alignment.topCenter,
                          ),
                        ),

                      ),
                      onTap: () {

                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20,),
                    SizedBox(
                      child: Text(
                        'My past Events',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: kCoralColor,
                        ),
                      ),
                    ),
                    PastJobs('USJ BasketBall Finals','Nov 12'),
                    PastJobs('Football Semifinal FOE','Dec 05'),
                  ],
                ),
              )
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: 50,
                color: kCoralColor,
                child: Text(
                  'LOG OUT',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Bahnschrift',
                    fontWeight: FontWeight.bold,
                    color: kPrimaryLightColor,
                  ),
                ),
              ),
              onTap: () async{
                await _auth.signOut();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignIn();
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void getData() async{
    final user = await _auth.getCurrentuser;
    print(user.email);
    await databaseReference
        .collection("users")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) { if( user.email==f.data['email']) {
        print(f.data['name']);
        setState(() {
          name = f.data['name'];
          email =f.data['email'];
        });
      }
      });
    });
  }
}

class PastJobs extends StatelessWidget {
  String title;
  String date;
  PastJobs(this.title,this.date);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 5,right: 10, top: 20),
      height: 150,
      width: MediaQuery.of(context).size.width,
      color: Color(0x00000000),
      child: RaisedButton(
        color: kCoralColor.withOpacity(0.5),
        splashColor: kPrimaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        onPressed: (){},
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 40,
                    width: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/users/man.jpg'),
                        fit: BoxFit.fill,
                        alignment: Alignment.topCenter,
                      ),
                    ),

                  ),
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryLightColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.date_range, color: kShadowColor ,size: 17),
                                Text(
                                  ' '+date,
                                  style: TextStyle(
                                    wordSpacing: 2,
                                    letterSpacing: 2,
                                    color: kShadowColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Text(
                      'Clearly, sports can help you reach your fitness goals and'
                          ' maintain a healthy weight. However, they also '
                          'encourage healthy decision-making such as not smoking'
                          ' and not drinking. Sports also have hidden health '
                          'benefits such as lowering the chance of osteoporosis '
                          'or breast cancer later in life.',
                      style: TextStyle(
                        fontSize: 12,
                        color: kLightColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      softWrap: true,
                    ),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
