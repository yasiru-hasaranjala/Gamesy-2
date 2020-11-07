import 'package:flutter/material.dart';
import 'post.dart';


TextStyle textStyle = new TextStyle(
  fontFamily: 'Gotham',
  color: Colors.white,
);
TextStyle textStyleBold = new TextStyle(
  fontFamily: 'Gotham',
  fontWeight: FontWeight.bold,
  color: Colors.white,
);
TextStyle textStyleLigthGrey = new TextStyle(
  fontFamily: 'Gotham',
  color: Colors.grey,
);

List<Post> userPosts = [
  new Post(
    new AssetImage('assets/images/users/user.jpg'),
    'joker',
    'assets/images/users/user-2.jpg', "My first post",
    false,
    false,
  ),
  new Post(new AssetImage('assets/images/users/user-3.jpg'),
    'akarsh', 'assets/images/users/user-4.jpg' ,
    "This is such a great post though",
    false,
    false,
  ),
];
