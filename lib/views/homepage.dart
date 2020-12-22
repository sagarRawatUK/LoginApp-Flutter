import 'package:LoginApp/helper/authGoogle.dart';
import 'package:LoginApp/views/login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String userName;
  final String userImage;
  HomePage(this.userName, this.userImage);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("LoginApp"),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                AuthService().signOutGoogle();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image(
                  image: NetworkImage(widget.userImage, scale: 0.8),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: Text(
                widget.userName,
                style: GoogleFonts.raleway(fontSize: 15),
              )),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                child: Text("Logout"),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  AuthService().signOutGoogle();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              )
            ],
          ),
        ));
  }
}
