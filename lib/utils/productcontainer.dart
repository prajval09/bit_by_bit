import 'package:flutter/material.dart';
import 'package:kisanlink/ShopByProduct/details.dart';

class ProductItem extends StatelessWidget {
  final String docId;
  final String imageUrl;
  final String name;
  final String type;
  final String price;

  const ProductItem({
    Key? key,
    required this.docId,
    required this.imageUrl,
    required this.name,
    required this.type,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(width: 1.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.fill,
            width: double.infinity,
            height: 100,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Name : $name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Type : $type',
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  'price : $price',
                  style: TextStyle(fontSize: 14),
                ),
                Center(
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => Details(docId: docId))));
                    },
                    child: Text('View Details'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
