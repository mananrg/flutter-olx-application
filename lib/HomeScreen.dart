import 'package:flutter/material.dart';
import 'package:olx_app/WelcomeScreen/welcomescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:olx_app/globalVar.dart';
import 'package:olx_app/uploadAdScreen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  getUserAddress() async {
    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = newPosition;
    placemarks = await placemarkFromCoordinates(
        position!.longitude, position!.latitude!);
    Placemark placemark = placemarks![0];
    String newCompleteAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare} ${placemark.subThoroughfare} ${placemark.locality} ${placemark.subAdministrativeArea} ${placemark.administrativeArea} ${placemark.postalCode} ${placemark.country}';
    completeAddress = newCompleteAddress;
    print(completeAddress);
    return completeAddress;
  }
  @override
  void initState(){
super.initState();
getUserAddress();
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    Widget? showItemList() {}
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.search,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              auth.signOut().then((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WelcomeScreen(),
                  ),
                );
              });
            },
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.login_outlined,
                color: Colors.white,
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade300, Colors.deepPurple],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text("Home Page"),
        centerTitle: false,
      ),
      body: Center(
        child: Container(
          width: _screenWidth,
          child: showItemList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Post',
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const UploadAdScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
