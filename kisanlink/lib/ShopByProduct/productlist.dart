import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kisanlink/utils/productcontainer.dart';

class CategoryProductPage extends StatelessWidget {
  final String category;

  const CategoryProductPage({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProductGrid(category: category),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final String category;

  const ProductGrid({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser!;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: category)
          //.where('user', isNotEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No data available.'));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final documents = snapshot.data!.docs;
        return GridView.builder(
          padding: EdgeInsets.all(10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            mainAxisExtent: 300,
          ),
          scrollDirection: Axis.vertical,
          itemCount: documents.length,
          itemBuilder: (BuildContext context, int index) {
            final product = documents[index].data() as Map<String, dynamic>;
            final docId = documents[index].id;
            final imageUrl = product['imageUrls'][0];
            final name = product['name'];
            final type = product['type'];
            final price = product['price'].toString();

            return ProductItem(
              docId: docId,
              imageUrl: imageUrl,
              name: name,
              type: type,
              price: price,
            );
          },
        );
      },
    );
  }
}
