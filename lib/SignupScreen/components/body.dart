import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_app/WelcomeScreen/welcomescreen.dart';
import 'package:olx_app/Widgets/already_have_an_account_acheck.dart';
import 'package:olx_app/Widgets/rounded_button.dart';
import 'package:olx_app/Widgets/rounded_input_field.dart';
import 'package:olx_app/Widgets/rounded_password_field.dart';

import '../../LoginScreen/loginscreen.dart';
import 'background.dart';

class SignupBody extends StatefulWidget {
  @override
  _SignupBodyState createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {
  String userPhotoUrl = "";

  File? _image;
  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File file = File(pickedFile!.path);

    setState(() {
      _image = file;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SignupBackground(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    chooseImage();
                  },
                  child: CircleAvatar(
                    radius: _screenWidth * 0.20,
                    backgroundColor: Colors.deepPurple[100],
                    backgroundImage: _image == null ? null : FileImage(_image!),
                    child: _image == null
                        ? Icon(
                            Icons.add_photo_alternate,
                            size: _screenWidth * 0.20,
                            color: Colors.white,
                          )
                        : null,
                  )),
              SizedBox(height: _screenHeight * 0.01),
              RoundedInputField(
                hintText: "Name",
                icon: Icons.person,
                onChanged: (value) {
                  _nameController.text = value;
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
              RoundedButton(
                text: "SIGNUP",
                press: () {
                  print(_nameController.text);
                  print(_emailController.text);
                  print(_passwordController.text);
                  _nameController.clear();
                  _emailController.clear();
                  _passwordController.clear();
                },
              ),
              SizedBox(
                height: _screenHeight * 0.03,
              ),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const LoginScreen();
                    }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
