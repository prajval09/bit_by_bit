import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kisanlink/model/reach.dart';

class ReachPage extends StatefulWidget {
  @override
  _ReachPageState createState() => _ReachPageState();
}

class _ReachPageState extends State<ReachPage> {
  late Future<List<ReachData>> _reachFuture;

  @override
  void initState() {
    super.initState();
    _reachFuture = _fetchReachData();
  }

  Future<List<ReachData>> _fetchReachData() async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> reachSnapshot = await FirebaseFirestore
        .instance
        .collection('reach')
        .where('seller', isEqualTo: currentUserUid)
        .get();

    List<ReachData> reachDataList = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> reachDoc
        in reachSnapshot.docs) {
      final buyerId = reachDoc['buyer'];
      final productId = reachDoc['product'];
      final date = reachDoc['date'];
      final time = reachDoc['time'];

      // Fetch buyer's information
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(buyerId)
          .get();
      final buyerName = userDoc['Name'];
      final buyerPhone = userDoc['phone'];
      final buyerImage = userDoc['file'];
      DocumentSnapshot<Map<String, dynamic>> productDoc =
          await FirebaseFirestore.instance
              .collection('products')
              .doc(productId)
              .get();
      final productImage = productDoc['imageUrls'][0];
      final productName = productDoc['name'];
      final productCategory = productDoc['category'];
      final productType = productDoc['type'];

      ReachData reachData = ReachData(
        buyerName: buyerName,
        buyerPhone: buyerPhone,
        buyerImage: buyerImage,
        productImage: productImage,
        productName: productName,
        productCategory: productCategory,
        productType: productType,
        date: date,
        time: time,
      );
      reachDataList.add(reachData);
    }

    reachDataList.sort((a, b) => b.date.compareTo(a.date));

    return reachDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ReachData>>(
        future: _reachFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<ReachData> reachDataList = snapshot.data!;
            return ListView.separated(
              padding: EdgeInsets.all(20),
              separatorBuilder: (context, index) => SizedBox(height: 20),
              itemCount: reachDataList.length,
              itemBuilder: (context, index) {
                ReachData reachData = reachDataList[index];
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(border: Border.all(width: 1.0)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(reachData.buyerImage),
                            radius: 50,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Buyer : ${reachData.buyerName}',
                                style: TextStyle(fontSize: 15),
                              ),
                              // const SizedBox(height: 10),
                              // Text(
                              //   'Contact : ${reachData.buyerPhone}',
                              //   style: TextStyle(fontSize: 15),
                              // ),
                              const SizedBox(height: 10),
                              Text(
                                'Date : ${reachData.date}',
                                style: TextStyle(fontSize: 15),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Time : ${reachData.time}',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '-----------------Requested For-------------------',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        color: Colors.amber[50],
                        padding: const EdgeInsets.only(left: 5),
                        height: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  reachData.productImage,
                                  height: 130,
                                  width: 130,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'Name   : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text(' ${reachData.productName}',
                                            style:
                                                const TextStyle(fontSize: 15))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Category : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text(' ${reachData.productCategory}',
                                            style:
                                                const TextStyle(fontSize: 15))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'Type : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                        Text(' ${reachData.productType}',
                                            style:
                                                const TextStyle(fontSize: 15))
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () {
                            // _launchCaller(reachData.buyerPhone);
                          },
                          child: Text('Contact'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  String formatPhoneNumber(String phoneNumber) {
    String cleanedPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (!cleanedPhoneNumber.startsWith('+')) {
      cleanedPhoneNumber = '+91$cleanedPhoneNumber';
    }

    return cleanedPhoneNumber;
  }

  void _launchCaller(String phoneNumber) async {
    final String formattedPhoneNumber = formatPhoneNumber(phoneNumber);
    final String telUrl = 'tel:$formattedPhoneNumber';
    if (await canLaunch(telUrl)) {
      await launch(telUrl);
    } else {
      throw 'Could not launch $telUrl';
    }
  }
}
