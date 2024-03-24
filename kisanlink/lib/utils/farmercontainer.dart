import 'package:flutter/material.dart';

class FarmerContainer extends StatelessWidget {
  final String userId;
  final String imageUrl;
  final String name;
  final String city;

  const FarmerContainer({
    required this.userId,
    required this.imageUrl,
    required this.name,
    required this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(imageUrl),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(height: 10),
                  Text(
                    'Name : $name',
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'City : $city',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                // Handle button press using the userId
                print('Contacting user with ID: $userId');
              },
              child: Text('View'),
            ),
          ),
        ],
      ),
    );
  }
}
