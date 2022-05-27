import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(String email, String pass, String userName, File image,
      bool isLogin, BuildContext ctx) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: pass);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: pass);
        /////////////////////////////////////////////

        final bucketRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child(authResult.user.uid + '.jpg');

        await bucketRef.putFile(image);

        final profilePicUrl = await bucketRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'username': userName,
          'email': email,
          'image_url': profilePicUrl,
        });
      }
    } catch (error) {
      var message = 'An error occurred, please check credentials!';

      if (error.message != null) {
        message = error.message;
      }

      Scaffold.of(ctx).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        duration: Duration(seconds: 2),
        content: Text(message),
      ));

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
