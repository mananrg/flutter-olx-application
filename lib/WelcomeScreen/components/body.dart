import 'package:flutter/material.dart';
import 'package:olx_app/SignupScreen/signupscreen.dart';
import 'package:olx_app/WelcomeScreen/components/background.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:olx_app/Widgets/rounded_button.dart';

import '../../LoginScreen/loginscreen.dart';

class WelcomeBody extends StatelessWidget {
  const WelcomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WelcomeBackground(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'OLX CLONE',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Signatra',
                fontSize: 60,
                color: Colors.deepPurple[100],
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            SvgPicture.asset(
              'assets/icons/chat.svg',
              height: size.height * 0.45,
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            RoundedButton(text: 'LOGIN', press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            }),
            RoundedButton(text: 'SIGNUP', press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const SignUpScreen();
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
