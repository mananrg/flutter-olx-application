import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:olx_app/HomeScreen.dart';
import 'package:olx_app/LoginScreen/components/background.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:olx_app/SignupScreen/signupscreen.dart';
import 'package:olx_app/Widgets/rounded_button.dart';
import '../../DialogBox/errorDialog.dart';
import '../../DialogBox/loadingDialog.dart';
import '../../Widgets/already_have_an_account_acheck.dart';
import '../../Widgets/rounded_input_field.dart';
import '../../Widgets/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../loginscreen.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void _login() async {
    showDialog(
        context: context,
        builder: (_) {
          return const LoadingAlertDialog(message: "Please Wait.....");
        });
    User? currentUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (con) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      getUserData(currentUser!.uid);
    } else {
      if (kDebugMode) {
        print("error");
      }
    }
  }

  getUserData(String uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((results) {
      String status = results.data()!['status'];
      if (status == "approved") {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else {
        _auth.signOut();
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
        showDialog(
            context: context,
            builder: (con) {
              return ErrorAlertDialog(
                message: "This account has been blocked by admin. Please contact our helpline",
              );
            });
      }
    });
  }

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
            RoundedButton(text: "LOGIN", press: () {
              _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty? _login():showDialog(context: context, builder: (con){
                return const ErrorAlertDialog(message: "Please write email and password for login");
              });
            }),
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
      ),
    );
  }
}
