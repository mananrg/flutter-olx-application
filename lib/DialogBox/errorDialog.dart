import 'package:flutter/material.dart';
import 'package:olx_app/WelcomeScreen/welcomescreen.dart';

class ErrorAlertDialog extends StatelessWidget {
  const ErrorAlertDialog({Key? key, required this.message}) : super(key: key);

  final String message;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const WelcomeScreen(),
              ),
            );
          },
          child: const Center(
            child: Text("Ok"),
          ),
        ),
      ],
    );
  }
}
