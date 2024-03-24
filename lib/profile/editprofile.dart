import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;

  const EditProfilePage(this.userId, {super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  String? img_url;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      Map<String, dynamic> userDataMap =
          userData.data() as Map<String, dynamic>;
      _nameController.text = userDataMap['Name'] ?? '';
      _phoneController.text = userDataMap['phone'] ?? '';
      img_url = userDataMap['file'];
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile != null) {
      try {
        final Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('profiles/${widget.userId}');
        await firebaseStorageRef.putFile(_imageFile!);
        String imageUrl = await firebaseStorageRef.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .update({
          'file': imageUrl,
        });
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

  Future<void> _updateProfileData() async {
    try {
      String name = _nameController.text;
      String phone = _phoneController.text;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .update({
        'Name': name,
        'phone': phone,
      });
    } catch (e) {
      print('Error updating profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: Wrap(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Photo Library'),
                            onTap: () {
                              _getImage(ImageSource.gallery);
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_camera),
                            title: const Text('Camera'),
                            onTap: () {
                              _getImage(ImageSource.camera);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Center(
                child: _imageFile != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(_imageFile!),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('$img_url'),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Contact',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () async {
                await _uploadImage();
                await _updateProfileData();
                Navigator.of(context).pop();
              },
              child: const Center(child: Text('Save')),
            ),
          ],
        ),
      ),
    );
  }
}
