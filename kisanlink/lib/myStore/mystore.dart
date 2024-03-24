import 'package:flutter/material.dart';
import 'package:kisanlink/myStore/productsection.dart';
import 'package:kisanlink/myStore/reachdata.dart';

class MyStore extends StatefulWidget {
  const MyStore({super.key});

  @override
  State<MyStore> createState() => _MyStoreState();
}

class _MyStoreState extends State<MyStore> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('My Store'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Product'),
              Tab(text: 'Reach'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyProductSection(),
            ReachPage(),
          ],
        ),
      ),
    );
  }
}
