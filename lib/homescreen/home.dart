import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kisanlink/ShopByProduct/products.dart';
import 'package:kisanlink/farmersNearby/farmersnear.dart';
import 'package:kisanlink/utils/weather.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _username = '';
  late String _profilePicUrl = '';
  late String _usercity = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        _username = userSnapshot['Name'];
        _profilePicUrl = userSnapshot['file'];
        _usercity = userSnapshot['city'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KisanLink'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: _username.isNotEmpty ? 16 : 100),
            if (_username.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$_username!',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    backgroundImage: NetworkImage(_profilePicUrl),
                    radius: 20,
                  ),
                ],
              ),
            if (_username.isEmpty) CircularProgressIndicator(),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ProductShop())));
                  },
                  child: Container(
                    height: 180,
                    width: 150,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.yellow[400],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 75),
                        Text('Shop', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) => Farmers())));
                  },
                  child: Container(
                    height: 180,
                    width: 150,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(50, 213, 131, 1.000),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset('assets/icons/farmer.png'),
                        Text('Farmers', style: TextStyle(fontSize: 22)),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weather',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                WeatherContainer(city: _usercity),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
