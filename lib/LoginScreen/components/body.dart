import 'package:flutter/material.dart';
import 'package:olx_app/LoginScreen/components/background.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:olx_app/SignupScreen/signupscreen.dart';
import 'package:olx_app/Widgets/rounded_button.dart';
import '../../Widgets/already_have_an_account_acheck.dart';
import '../../Widgets/rounded_input_field.dart';
import '../../Widgets/rounded_password_field.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return LoginBackground(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.03,
          ),
          SvgPicture.asset(
            "assets/icons/login.svg",
            height: size.height * 0.35,
          ),
          RoundedPasswordField(
            onChanged: (value) {
              _passwordController.text = value;
            },
          ),
          RoundedInputField(
            hintText: "Email",
            icon: Icons.person,
            onChanged: (value) {
              _emailController.text = value;
            },
          ),
          RoundedPasswordField(
            onChanged: (value) {
              _passwordController.text = value;
            },
          ),
          RoundedButton(text: "LOGIN", press: () {}),
          SizedBox(
            height: size.height * 0.03,
          ),
          AlreadyHaveAnAccountCheck(
            login: true,
            press: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SignUpScreen();
                }),
              );
            },
          ),
        ],
      ),
    ));
  }
}
