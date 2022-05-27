import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/splash-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text('Loading...'),
          ),
          Center(
            child:
                CircularProgressIndicator(color: Theme.of(context).accentColor),
          )
        ],
      ),
    );
  }
}
