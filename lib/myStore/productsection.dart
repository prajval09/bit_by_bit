import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kisanlink/myStore/AddProduct/addproduct.dart';
import 'package:kisanlink/myStore/myproductlist.dart';

class MyProductSection extends StatefulWidget {
  const MyProductSection({super.key});

  @override
  State<MyProductSection> createState() => _MyProductSectionState();
}

class _MyProductSectionState extends State<MyProductSection> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    return Scaffold(
      body: ProductList(user!.uid),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddProduct()));
          },
          backgroundColor: Colors.red,
          heroTag: 'addButton',
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
