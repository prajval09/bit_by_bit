import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kisanlink/utils/farmercontainer.dart';

class Farmers extends StatefulWidget {
  @override
  _FarmersState createState() => _FarmersState();
}

class _FarmersState extends State<Farmers> {
  late Future<List<Map<String, dynamic>>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
  }

  Future<List<Map<String, dynamic>>> _fetchUserData() async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> currentUserDoc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUserUid)
            .get();
    final currentUserCity = currentUserDoc['city'];

    QuerySnapshot<Map<String, dynamic>> usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<Map<String, dynamic>> sameCityUsers = [];
    List<Map<String, dynamic>> otherUsers = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> userDoc
        in usersSnapshot.docs) {
      final userCity = userDoc['city'];
      final userImageUrl = userDoc['file'];
      final userName = userDoc['Name'];
      final userID = userDoc['uid'];

      Map<String, dynamic> userData = {
        'file': userImageUrl,
        'Name': userName,
        'city': userCity,
        'uid': userID,
      };

      if (userCity == currentUserCity) {
        sameCityUsers.add(userData);
      } else {
        otherUsers.add(userData);
      }
    }

    // Concatenate lists
    List<Map<String, dynamic>> userDataList = [];
    userDataList.addAll(sameCityUsers);
    userDataList.addAll(otherUsers);

    return userDataList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmers Near Me'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _userDataFuture,
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
            List<Map<String, dynamic>> userDataList = snapshot.data!;
            return ListView.separated(
              padding: EdgeInsets.all(20),
              separatorBuilder: (context, index) => SizedBox(height: 20),
              itemCount: userDataList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> userData = userDataList[index];
                return FarmerContainer(
                    userId: userData['uid'],
                    imageUrl: userData['file'],
                    name: userData['Name'],
                    city: userData['city']);
                // ListTile(
                //   leading: CircleAvatar(
                //     backgroundImage: NetworkImage(userData['file']),
                //   ),
                //   title: Text(userData['Name']),
                //   subtitle: Text(userData['city']),
                //   onTap: () {
                //     // Handle onTap
                //   },
                // );
              },
            );
          }
        },
      ),
    );
  }
}
