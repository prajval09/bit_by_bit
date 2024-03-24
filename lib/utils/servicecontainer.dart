import 'package:flutter/material.dart';

class ServiceContainer extends StatelessWidget {
  final String name;
  final String category;
  final String type;
  final String remain;
  final String lot;
  final String imageUrl;
  final num price;
  const ServiceContainer(this.name, this.category, this.type, this.remain,
      this.lot, this.imageUrl, this.price,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          //    topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          //    bottomRight: Radius.circular(10)
        ),
        //border: Border.all(width: 0.7),
        //boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(4, 4))]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                imageUrl,
                height: 130,
                width: 130,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Padding(padding: EdgeInsets.only(top: 20)),
                  Row(
                    children: [
                      const Text(
                        'Name   : ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(' $name', style: const TextStyle(fontSize: 15))
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Category : ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(' $category', style: const TextStyle(fontSize: 15))
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Type : ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(' $type', style: const TextStyle(fontSize: 15))
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Available : ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(' $remain $lot',
                          style: const TextStyle(fontSize: 15))
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Price    : ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(' Rs $price', style: const TextStyle(fontSize: 15))
                    ],
                  ),
                ],
              ),
            ],
          ),
          /*Icon(
            Icons.arrow_circle_right,
            color: Colors.black,
            size: 40,
          ),*/
          //Padding(padding: EdgeInsets.only(right: 5))
        ],
      ),
    );
  }
}
