import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agora_flutter_quickstart/models/user_model.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });

  //collection reference users
  final CollectionReference userCollection =
  Firestore.instance.collection('users');

  Future updateUserData(String name, String email, int number) async {
    return await userCollection.document(uid).setData({
      'name': name,
      'email': email,
      'number': number,
    });
  }



  //collection reference events
  final CollectionReference eventCollection =
  Firestore.instance.collection('events');

  Future updateEventData(evName, organizer, pw, name1, name2,
      description, date, time) async {
    return await eventCollection.document(uid).setData({
      'name': evName,
      'organizer': organizer,
      'pw': pw,
      'team1': name1,
      'team12':name2,
      'des': description,
      'date': date,
      'time': time,
    });
  }

  Future saveEvent(evName, organizer, pw, name1, name2,
      _description, date, time) async {
    try{
      //create a new document for the event
      await DatabaseService().updateEventData(evName, organizer,
          pw, name1, name2, _description, date, time);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  //gamesy list from snapshot
  List<UserModel> _userListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return UserModel(
        name: doc.data['name'] ?? '',
        email: doc.data['email'] ?? '',
        number: doc.data['number'] ?? 0,
      );
    }).toList();
  }

  //get gamesy stream
  Stream<List<UserModel>> get gamesydbs {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  Future getEventData() async {
    return await eventCollection.document().get();
  }

  //collection reference events
  final CollectionReference matchCollection =
  Firestore.instance.collection('match');


  Future updateMatchData(t1,t2,p1,p2,s1,s2) async {
    return await matchCollection.document(uid).setData({
      't1':t1,
      't2':t2,
      'p1': p1,
      'p2': p2,
      's1': s1,
      's2': s2,

    });
  }

  Future saveMatch(t1,t2,p1,p2,s1,s2) async {
    try{
      //create a new document for the event
      await DatabaseService().updateMatchData(t1,t2,p1,p2,s1,s2);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  Future getMatchData() async {
    return await matchCollection.document().get();
  }
}