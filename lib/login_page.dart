// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login/home_page.dart';
import 'package:login/model/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Login",
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(
                height: 60,
              ),
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(hintText: "Email"),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: TextField(
                          controller: _passController,
                          obscureText: true,
                          decoration: InputDecoration(hintText: "Password"),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(fontSize: 32, color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });

                    var signInHandle =
                        signIn(_emailController.text, _passController.text);
                    signInHandle.then((userData) {
                      // print(object);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    }).catchError((error) {});
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FlatButton(
                child: const Text('Forgot password'),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<UserData> signIn(String email, String pass) async {
  var url = Uri.parse('https://selfu-api-demo.xeersoft.co.th/api/login/v2');
  Map body = {"username": email, "password": pass};

  var res = await http.post(url, body: body);

  if (res.statusCode == 200) {
    var userData = UserData.fromJson(jsonDecode(res.body));

    return userData;
  } else {
    throw Exception("Error");
  }
}
