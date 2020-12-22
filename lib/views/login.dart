import 'package:LoginApp/helper/authGoogle.dart';
import 'package:LoginApp/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userName;
  String userImage;
  bool _isLoggedIn = false;
  bool isLoading = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  _loginWithFB() async {
    final result = await facebookLogin.logIn(['email']);
    facebookLogin.loginBehavior = FacebookLoginBehavior.nativeWithFallback;

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          isLoading = true;
          userProfile = profile;
          userName = userProfile["name"];
          userImage = userProfile["picture"]["data"]["url"];
          _isLoggedIn = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("ISUSERLOGGEDIN", true);
        prefs.setString("USERNAME", userName);
        prefs.setString("USERIMAGE", userImage);
        print(prefs.getKeys());
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(userName, userImage)));
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LoginApp"),
      ),
      body: Container(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SignInButton(
                      Buttons.Google,
                      onPressed: () {
                        AuthService().signin().then((value) async {
                          setState(() {
                            isLoading = true;
                          });
                          print("Login successful");
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool("ISUSERLOGGEDIN", true);
                          prefs.setString("USERNAME", value.displayName);
                          prefs.setString("USERIMAGE", value.photoURL);
                          print(prefs.getKeys());
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                      value.displayName,
                                      value.photoURL.toString())));
                        });
                      },
                    ),
                    SignInButton(
                      Buttons.Facebook,
                      onPressed: () {
                        _loginWithFB();
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
