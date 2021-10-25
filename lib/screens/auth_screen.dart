import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/auth/auth_form.dart ';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;

  Future<void> _submitAuthData(String email, String username,
      File? userImageFile, String password, bool isLogin) async {
    try {
      if (isLogin) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        if (userImageFile == null) {
          return;
        }
        final _authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        print('--------Path of Image is ${userImageFile.path}');

        try {
          final _ref = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child(_authResult.user!.uid + '.jpg');

          await _ref.putFile(userImageFile);

          final imageUrl = await _ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(_authResult.user!.uid)
              .set({
            'username': username,
            'email': email,
            'image_url': imageUrl
          });
        } catch (error) {
          return;
        }
      }
    } on FirebaseAuthException catch (e) {
      var errorMessage =
          e.message ?? 'Error occurred, please check your credentials!';
      print(errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$errorMessage'),
        backgroundColor: Theme.of(context).errorColor,
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$error'),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthData,
      ),
    ));
  }
}
