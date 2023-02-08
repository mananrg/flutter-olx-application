import 'package:flutter/material.dart';
import 'package:olx_app/LoginScreen/components/body.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LoginBody(),);
  }
}
