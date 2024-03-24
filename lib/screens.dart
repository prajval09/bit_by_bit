import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kisanlink/MyStore/mystore.dart';
import 'package:kisanlink/ShopByProduct/products.dart';
import 'package:kisanlink/farmersNearby/farmersnear.dart';
import 'package:kisanlink/homescreen/home.dart';
import 'package:kisanlink/profile/profile.dart';

class Screens extends StatefulWidget {
  const Screens({super.key});

  @override
  State<Screens> createState() => _ScreensState();
}

class _ScreensState extends State<Screens> {
  int _pageIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    User user = _auth.currentUser!;
    List pages = [
      HomeScreen(),
      Farmers(),
      ProductShop(),
      MyStore(),
      ProfilePage(user.uid, context),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: (value) {
            setState(() {
              _pageIndex = value;
            });
          },
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.red,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.pin_drop), label: 'Farmers Nearby'),
            BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Shop'),
            BottomNavigationBarItem(icon: Icon(Icons.store), label: 'My Store'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: 'Profile'),
          ]),
      body: pages[_pageIndex],
    );
  }
}
