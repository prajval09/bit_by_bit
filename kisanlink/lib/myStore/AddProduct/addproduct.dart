import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  List<File> _imageFiles = [];
  String _name = '';
  String _quantity = '';
  String _lot = '';
  String _description = '';
  String _type = '';
  String _category = '';
  num? _price;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFiles.add(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  bool uploading = false; // State variable to track uploading state

  Future<void> _uploadImages() async {
    setState(() {
      uploading = true; // Set uploading state to true
    });

    User? user = _auth.currentUser;
    if (_imageFiles.isEmpty || _name.isEmpty) return;

    List<String> downloadUrls = [];

    for (int i = 0; i < _imageFiles.length; i++) {
      String imageName = _name.replaceAll(' ', '_') + '_$i';
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference storageReference = storage.ref().child('images/$imageName.png');

      UploadTask uploadTask = storageReference.putFile(_imageFiles[i]);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await snapshot.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
    }

    FirebaseFirestore.instance.collection('products').add({
      'name': _name,
      'user': user!.uid,
      'quantity': _quantity,
      'lot': _lot,
      'description': _description,
      'type': _type,
      'category': _category,
      'price': _price,
      'imageUrls': downloadUrls,
    });

    setState(() {
      uploading = false; // Set uploading state to false after uploading
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Submission Successful'),
          content: const Text('Your data has been submitted successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Category'),
                value: _category.isNotEmpty ? _category : null,
                items:
                    ['Animal Food', 'Seed', 'Fertilizer', 'Pesticide', 'Other']
                        .map((category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(category),
                            ))
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
                onSaved: (value) {
                  _category = value!;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Product Type';
                  }
                  return null;
                },
                onSaved: (value) {
                  _type = value!;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Price';
                  }
                  return null;
                },
                onSaved: (value) {
                  _price = num.parse(value!);
                },
              ),
              const SizedBox(height: 20.0),
              Text('Availability'),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _quantity = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Lot type'),
                value: _lot.isNotEmpty ? _lot : null,
                items: ['Quintal', 'Ton', 'Kg', 'gram', 'Number', 'Other']
                    .map((lot) => DropdownMenuItem<String>(
                          value: lot,
                          child: Text(lot),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _lot = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
                onSaved: (value) {
                  _lot = value!;
                },
              ),
              const SizedBox(height: 20.0),
              _imageFiles.isNotEmpty
                  ? Column(
                      children: _imageFiles
                          .map((imageFile) => Image.file(
                                imageFile,
                                height: 150,
                                width: 150,
                              ))
                          .toList(),
                    )
                  : Container(),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _getImage(ImageSource.gallery);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Select Image'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _getImage(ImageSource.camera);
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Take Picture'),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    await _uploadImages();
                    _formKey.currentState!.reset();
                    setState(() {
                      _imageFiles = [];
                    });
                  }
                },
                child: const Text('Add Service'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
