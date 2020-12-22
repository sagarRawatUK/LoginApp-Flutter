import 'package:LoginApp/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isUserLoggedIn;
  String userName;
  String userImage = "";

  @override
  void initState() {
    super.initState();
    initSharedPrefrences();
  }

  initSharedPrefrences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getKeys());
    setState(() {
      isUserLoggedIn = prefs.getBool("ISUSERLOGGEDIN");
      userName = prefs.getString("USERNAME");
      userImage = prefs.getString("USERIMAGE");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isUserLoggedIn != null
          ? isUserLoggedIn
              ? HomePage(userName, userImage)
              : LoginPage()
          : Container(
              child: Center(
                child: LoginPage(),
              ),
            ),
    );
  }
}
