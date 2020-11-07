import 'package:flutter/material.dart';
import 'package:agora_flutter_quickstart/screens/authenticate/authenticate.dart';
import 'package:agora_flutter_quickstart/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:agora_flutter_quickstart/models/user.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);

    if(user == null){
      return Authenticate();
    } else{
      return Home();
    }

  }
}
