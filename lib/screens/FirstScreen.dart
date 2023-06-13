import 'package:chat_application/screens/LoginScreen.dart';
import 'package:chat_application/screens/SignupScreen.dart';
import 'package:flutter/material.dart';

import '../CusomizedData.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Spacer(),
            LoginSIngupButton(
              text: 'Login',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            const SizedBox(
              height: 10,
            ),
            LoginSIngupButton(
              text: 'Signup',
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignupScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
