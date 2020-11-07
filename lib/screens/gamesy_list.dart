import 'package:flutter/material.dart';
import 'package:agora_flutter_quickstart/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:agora_flutter_quickstart/screens/gamesy_tile.dart';

class GamesyList extends StatefulWidget {
  @override
  _GamesyListState createState() => _GamesyListState();
}

class _GamesyListState extends State<GamesyList> {
  @override
  Widget build(BuildContext context) {

    final gamesydb = Provider.of<List<UserModel>>(context);

    return ListView.builder(
      itemCount: gamesydb.length,
      itemBuilder: (context, index){
        return GamesyTile(userModel: gamesydb[index]);
      },
    );
  }
}

