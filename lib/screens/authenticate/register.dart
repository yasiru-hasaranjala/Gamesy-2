import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_flutter_quickstart/screens/authenticate/sign_in.dart';
import 'package:agora_flutter_quickstart/screens/home/home.dart';
import 'package:agora_flutter_quickstart/services/auth.dart';
import 'package:agora_flutter_quickstart/shared/background.dart';
import 'package:agora_flutter_quickstart/screens/authenticate/components/social_icon.dart';
import 'package:agora_flutter_quickstart/screens/authenticate/components/or_divider.dart';
import 'package:agora_flutter_quickstart/components/already_have_an_account_acheck.dart';
import 'package:agora_flutter_quickstart/components/rounded_button.dart';
import 'package:agora_flutter_quickstart/components/rounded_input_field.dart';
import 'package:agora_flutter_quickstart/components/rounded_password_field.dart';
import 'package:agora_flutter_quickstart/shared/constants.dart';
import 'package:agora_flutter_quickstart/shared/loading.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  File _image;

  // text field state
  String name = '';
  String email = '';
  String password = '';
  String error = '';

  Future getImage() async{
    final image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading ? Loading() : Scaffold(
      body: Background(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.08),
                Text(
                  'SIGNUP',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  child: Image.asset(
                    'assets/images/players1.png',
                    height: size.height * 0.24,
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                RoundedInputField(
                  hintText: "Your Name",
                  validator: (val) => val.isEmpty ? 'Enter Your Name': null,
                  onChanged: (val) {
                    setState(() => name = val);
                  },
                ),
                RoundedInputField2(
                  hintText: "Email",
                  validator: (val) => val.isEmpty ? 'Enter an valid Email': null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                RoundedPasswordField(
                  validator: (val) => val.length<6 ? 'Password should more than 6 Characters': null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                RoundedButton(
                  text: "SIGNUP",
                  press: () async {
                    if(_formKey.currentState.validate()){
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth
                          .registerWithEmailAndPassword(name, email, password);
                      if(result==null){
                        setState(() {
                          error = 'please supply a valid email';
                          loading = false;
                        });
                      }
                      else {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Home();
                              },
                            ),
                          );
                        });
                      }
                    }
                  },
                ),
                SizedBox(height: size.height * 0.01),
                error != '' ? Text(
                  error,
                  style: TextStyle(color: kActiveIconColor, fontSize: 14),
                ): Container(),
                SizedBox(height: size.height * 0.002),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignIn();
                        },
                      ),
                    );
                  },
                ),
                OrDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SocalIcon(
                      iconSrc: "assets/icons/facebook.svg",
                      press: () {},
                    ),
                    SocalIcon(
                      iconSrc: "assets/icons/twitter.svg",
                      press: () {},
                    ),
                    SocalIcon(
                      iconSrc: "assets/icons/google-plus.svg",
                      press: () {},
                    ),
                  ],
                )
              ],
            ),
          ),
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
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        //_imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      //_imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
