import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:olx_app/DialogBox/loadingDialog.dart';
import 'package:olx_app/globalVar.dart';
import 'package:path/path.dart' as Path;

import 'HomeScreen.dart';

class UploadAdScreen extends StatefulWidget {
  const UploadAdScreen({Key? key}) : super(key: key);

  @override
  State<UploadAdScreen> createState() => _UploadAdScreenState();
}

class _UploadAdScreenState extends State<UploadAdScreen> {
  bool uploading = false, next = false;
  double val = 0;
  late CollectionReference imageRef;
  late firebase_storage.Reference ref;
  String imgFile = "",
      imgFile1 = "",
      imgFile2 = "",
      imgFile3 = "",
      imgFile4 = "",
      imgFile5 = "";
  final List<File> _image = [];
  List<String> urlsList = [];
  final picker = ImagePicker();

  FirebaseAuth auth = FirebaseAuth.instance;
  String userName = "";
  String userNumber = "";
  String itemPrice = "";
  String itemModel = "";
  String itemColor = "";
  String description = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          next ? "Please write Item's Info" : "Choose the Image",
          style: const TextStyle(
            fontSize: 18.0,
            fontFamily: "Lobster",
            letterSpacing: 2.0,
          ),
        ),
        actions: [
          next
              ? Container()
              : ElevatedButton(
                  onPressed: () {
                    if (_image.length == 5) {
                      setState(() {
                        uploading = true;
                        next = true;
                      });
                    } else {
                      showToast(
                        "Please select 5 images only....",
                        seconds: 2,
                      );
                    }
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                        fontFamily: "Varela",
                        fontSize: 18.0,
                        color: Colors.white),
                  ),
                ),
        ],
      ),
      body: next
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration:
                          const InputDecoration(hintText: "Enter your Name"),
                      onChanged: (val) {
                        userName = val;
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(
                          hintText: "Enter Your Phone Number"),
                      onChanged: (val) {
                        userNumber = val;
                      },
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(hintText: "Enter Item Price"),
                      onChanged: (val) {
                        itemPrice = val;
                      },
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(hintText: "Enter Item Name"),
                      onChanged: (val) {
                        itemModel = val;
                      },
                    ),
                    TextField(
                      decoration:
                          const InputDecoration(hintText: "Enter Item Color"),
                      onChanged: (val) {
                        itemColor = val;
                      },
                    ),
                    TextField(
                      decoration: const InputDecoration(
                          hintText: "Write some Item's Description"),
                      onChanged: (val) {
                        description = val;
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (con) {
                                return const LoadingAlertDialog(
                                    message: "Loading....");
                              });
                          uploadFile().whenComplete(() {
                            Map<String, dynamic> adData = {
                              'userName': this.userName,
                              'uid': auth.currentUser?.uid,
                              'userNumber': this.userNumber,
                              'itemPrice': this.itemPrice,
                              'itemModel': this.itemModel,
                              'itemColor': this.itemColor,
                              'description': this.description,
                              'urlImage1': urlsList[0].toString(),
                              'urlImage2': urlsList[1].toString(),
                              'urlImage3': urlsList[2].toString(),
                              'urlImage4': urlsList[3].toString(),
                              'urlImage5': urlsList[4].toString(),
                              'imgPro': userImageUrl,
                              'lat': position?.latitude,
                              'lng': position?.longitude,
                              'address': completeAddress,
                              'time': DateTime.now(),
                              'status': "not approved",
                            };
                            FirebaseFirestore.instance
                                .collection('items')
                                .add(adData)
                                .then((value) {
                              print("Data Added Successfuly");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const HomeScreen()));
                            }).catchError((onError){
                              print(onError);
                            });
                          });
                        },
                        child: const Text(
                          'Upload',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            )
          : Stack(children: [
              Container(
                padding: const EdgeInsets.all(4),
                child: GridView.builder(
                  itemCount: _image.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return index == 0
                        ? Center(
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () =>
                                  !uploading ? chooseImage() : null,
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(
                                  _image[index - 1],
                                ),
                              ),
                            ),
                          );
                  },
                ),
              ),
              uploading
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: const Text(
                              "Uploading....",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CircularProgressIndicator(
                            value: val,
                            valueColor:
                                const AlwaysStoppedAnimation(Colors.green),
                          )
                        ],
                      ),
                    )
                  : Container()
            ]),
    );
  }

  Future uploadFile() async {
    int i = 1;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('image/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          urlsList.add(value);
          i++;
        });
      });
    }
  }

  void showToast(String msg, {required int seconds}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: Duration(seconds: seconds),
    ));
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile?.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(
          File(response.file!.path),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    imageRef = FirebaseFirestore.instance.collection('imageUrls');
  }
}
