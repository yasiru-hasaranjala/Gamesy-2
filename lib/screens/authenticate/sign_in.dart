import 'package:flutter/material.dart';
import 'package:agora_flutter_quickstart/screens/authenticate/register.dart';
import 'package:agora_flutter_quickstart/screens/home/home.dart';
import 'package:agora_flutter_quickstart/services/auth.dart';
import 'package:agora_flutter_quickstart/shared/background.dart';
import 'package:agora_flutter_quickstart/components/already_have_an_account_acheck.dart';
import 'package:agora_flutter_quickstart/components/rounded_button.dart';
import 'package:agora_flutter_quickstart/components/rounded_input_field.dart';
import 'package:agora_flutter_quickstart/components/rounded_password_field.dart';
import 'package:agora_flutter_quickstart/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading ? Loading() : Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: size.height * 0.01),
                Container(
                  child: Image.asset(
                    'assets/images/players1.png',
                    height: size.height * 0.35,
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                RoundedInputField(
                  hintText: "Your Email",
                  validator: (val) => val.isEmpty ? 'Enter an valid Email': null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                RoundedPasswordField(
                  validator: (val) => val.length<6 ?
                  'Password should more than 6 Characters': null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                RoundedButton(
                  text: "LOGIN",
                  press: () async {
                    if(_formKey.currentState.validate()){
                      setState(() {
                        loading = true;
                      });
                      dynamic result = await _auth
                          .signInWithEmailAndPassword(email, password);
                      if(result==null){
                        setState(() {
                          error = 'could not sign in with those credentials';
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
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
                SizedBox(height: size.height * 0.01),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Register();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ),

      ),
    );
  }
}
