import 'package:flutter/material.dart';

import './screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import './screens/auth_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseFirestore.initializeApp();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat',
      theme: ThemeData(
        primaryColor: Color(0xff002222),
        accentColor: Color(0xffefddf4),
        accentColorBrightness: Brightness.dark,
        buttonTheme: ButtonTheme.of(context).copyWith(

          buttonColor: Color(0xff002222),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )
        ),
      ),

      home: AuthScreen(),
    );
  }
}
