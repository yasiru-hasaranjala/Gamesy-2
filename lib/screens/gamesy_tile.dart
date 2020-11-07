import 'package:flutter/material.dart';
import 'package:agora_flutter_quickstart/models/user_model.dart';
import 'package:agora_flutter_quickstart/shared/constants.dart';

class GamesyTile extends StatelessWidget {

  final UserModel userModel;
  GamesyTile({ this.userModel });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: kShadowColor,
          ),
          title: Text(userModel.name),
          subtitle: Text('Takes ${userModel.email} this'),
        ),
      ),
    );
  }
}
