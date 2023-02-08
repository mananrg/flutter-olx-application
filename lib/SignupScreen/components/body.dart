import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_app/DialogBox/errorDialog.dart';
import 'package:olx_app/DialogBox/loadingDialog.dart';
import 'package:olx_app/Widgets/already_have_an_account_acheck.dart';
import 'package:olx_app/Widgets/rounded_button.dart';
import 'package:olx_app/Widgets/rounded_input_field.dart';
import 'package:olx_app/Widgets/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../HomeScreen.dart';
import '../../LoginScreen/loginscreen.dart';
import '../../globalVar.dart';
import 'background.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:cloud_firestore/cloud_firestore.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    File file = File(pickedFile!.path);

    setState(() {
      _image = file;
    });
  }

  upload() async {
    showDialog(
        context: context,
        builder: (_) {
          return const LoadingAlertDialog(message: "Please Wait.....");
        });
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    firebaseStorage.Reference reference =
        firebaseStorage.FirebaseStorage.instance.ref().child(fileName);
    firebaseStorage.UploadTask uploadTask = reference.putFile(_image!);
    firebaseStorage.TaskSnapshot storageTaskSnapshot =
        await uploadTask.whenComplete(() {});
    await storageTaskSnapshot.ref.getDownloadURL().then((url) {
      userPhotoUrl = url;
      print(userPhotoUrl);
      _register();
    });
  }

  void _register() async {
    late User currentUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
      userId = currentUser.uid!;
      userEmail = currentUser.email!;
      getUserName = _nameController.text.trim();
      saveUserData();
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
    //await
    if (currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }

  void saveUserData() {
    Map<String, dynamic> userData = {
      'userName': _nameController.text.trim(),
      'uid': userId,
      'userNumber': _phoneController.text.trim(),
      'imgPro': userPhotoUrl,
      'time': DateTime.now(),
      'status': "approved"
    };
    print("*"*90);
    print("before");
    FirebaseFirestore.instance.collection("users").doc(userId).set(userData);
    print("*"*90);
    print("after");
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
                  upload();
                }
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
