import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kisanlink/login/login.dart';
import 'package:kisanlink/profile/editprofile.dart';
import 'package:kisanlink/profile/passchange.dart';
import 'package:kisanlink/utils/labelcontainer.dart';

class ProfilePage extends StatelessWidget {
  final String userId;
  final BuildContext context;

  const ProfilePage(this.userId, this.context, {super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(child: Text('No data found!'));
        } else {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          String name = userData['Name'];
          String email = userData['email'];
          String profileImageUrl = userData['file'];

          return buildProfileUI(name, email, profileImageUrl);
        }
      },
    );
  }

  Widget buildProfileUI(String name, String email, String profileImageUrl) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(profileImageUrl),
            ),
            const SizedBox(height: 20),
            Text(
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              email,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Labelcontainer(
                title: 'Edit Profile',
                subtitle: 'Name, Email, Profile',
                icon: Icons.account_box_outlined,
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage(userId)));
                }),
            const SizedBox(height: 20),
            Labelcontainer(
                title: 'Password',
                subtitle: 'change password',
                icon: Icons.key_outlined,
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PasswordChangePage()));
                }),
            const SizedBox(height: 200),
            ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: const Icon(Icons.exit_to_app),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
