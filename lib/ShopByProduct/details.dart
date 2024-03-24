import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kisanlink/utils/textbox.dart';

class Details extends StatefulWidget {
  final String docId;

  const Details({
    required this.docId,
    Key? key,
  }) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Future<DocumentSnapshot<Map<String, dynamic>>> _detailsFuture;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _fetchDetails();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _fetchDetails() async {
    try {
      return await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.docId)
          .get();
    } catch (e) {
      print('Error fetching details: $e');
      throw Exception('Failed to fetch details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: _detailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Loading...'),
              backgroundColor: Colors.green,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          final data = snapshot.data!.data()!;
          final images = List<String>.from(data['imageUrls']);
          final product_name = data['name'];
          final product_category = data['category'];
          final product_type = data['type'];
          final product_price = data['price'].toString();
          final product_quantity = data['quantity'];
          final product_lot = data['lot'];
          final product_description = data['description'];
          final userId = data['user'];

          return Scaffold(
            appBar: AppBar(
              title: Text('Details'),
              backgroundColor: Colors.green,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Image.network(images[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Name : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextBox(product_name),
                  const SizedBox(height: 20),
                  const Text(
                    'Category : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextBox(product_category),
                  const SizedBox(height: 20),
                  const Text(
                    'type : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextBox(product_type),
                  const SizedBox(height: 20),
                  const Text(
                    'Description : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.7),
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Text(product_description),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Price : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextBox(product_price),
                  const SizedBox(height: 40),
                  const Text(
                    '__________________________________________________________',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                      child: Text('Availability',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  const Text(
                    'Quantity : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextBox(product_quantity),
                  const SizedBox(height: 20),
                  const Text(
                    'Lot : ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextBox(product_lot),
                  const SizedBox(height: 20),
                  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (userSnapshot.hasError) {
                        return Text(
                            'Error fetching user details: ${userSnapshot.error}');
                      } else {
                        userData = userSnapshot.data!.data()!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            const Text(
                              '__________________________________________________________',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 20),
                            const Center(
                                child: Text('Seller Details',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                            const SizedBox(height: 10),
                            const Text(
                              'Seller Name : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            TextBox(userData!['Name']),
                            // const SizedBox(height: 20),
                            // const Text(
                            //   'Contact : ',
                            //   style: TextStyle(fontWeight: FontWeight.bold),
                            // ),
                            // const SizedBox(height: 5),
                            // TextBox(userData!['phone']),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              elevation: 8,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    reach(context, userData!['uid'], widget.docId);
                  },
                  child: const Text('Reach'),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

Future<void> reach(BuildContext context, String sid, String pid) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user = _auth.currentUser!;
  try {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reaching out"),
          content: Text("Please wait while we process your request..."),
        );
      },
    );

    final existingReach = await FirebaseFirestore.instance
        .collection('reach')
        .where('buyer', isEqualTo: user.uid)
        .where('seller', isEqualTo: sid)
        .where('product', isEqualTo: pid)
        .get();

    if (existingReach.docs.isNotEmpty) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Already Reached"),
            content: Text(
                "You've already reached out to the seller for this product!"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    final currentDate = DateTime.now();
    final formattedDate =
        "${currentDate.year}-${currentDate.month}-${currentDate.day}";
    final formattedTime =
        "${currentDate.hour}:${currentDate.minute}:${currentDate.second}";

    await FirebaseFirestore.instance.collection('reach').add({
      'buyer': user.uid,
      'seller': sid,
      'product': pid,
      'date': formattedDate,
      'time': formattedTime,
    });

    Navigator.pop(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Success"),
          content: Text("You've successfully reached out to the seller!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  } catch (e) {
    Navigator.pop(context);

    print('Error : $e');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(
              "Failed to reach out to the seller. Please try again later."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
