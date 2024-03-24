import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class EditProductPage extends StatefulWidget {
  final String documentId;

  const EditProductPage({Key? key, required this.documentId}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _typeController;
  late TextEditingController _quantityController;
  String? _selectedCategory;
  String? _selectedLot;
  late TextEditingController _priceController;
  List<String> _imageUrls = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _typeController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    _getServiceDetails();
  }

  Future<void> _getServiceDetails() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.documentId)
          .get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'];
          _descriptionController.text = data['description'];
          _typeController.text = data['type'];
          _selectedCategory = data['category'];
          _quantityController.text = data['quantity'];
          _selectedLot = data['lot'];
          _priceController.text = data['price'].toString();
          _imageUrls = List<String>.from(data['imageUrls'] ?? []);
        });
      }
    } catch (e) {
      print('Error getting service details: $e');
    }
  }

  Future<void> _updateService() async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.documentId)
          .update({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'type': _typeController.text,
        'category': _selectedCategory,
        'quantity': _quantityController.text,
        'lot': _selectedLot,
        'price': num.parse(_priceController.text),
        'imageUrls': _imageUrls,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service updated successfully')));
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Success'),
              content: const Text('Service updated successfully!'),
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
          });
    } catch (e) {
      print('Error updating service: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating service')));
    }
  }

  Future<void> _selectImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      File selectedImage = File(pickedFile.path);
      String imageUrl = await _uploadImage(selectedImage);
      setState(() {
        if (_imageUrls.length >= 3) {
          _imageUrls.removeAt(0);
        }
        _imageUrls.add(imageUrl);
      });
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child('${DateTime.now().millisecondsSinceEpoch}');
      firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask;
      String downloadURL = await ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: [
                  'Animal Food',
                  'Seed',
                  'Fertilizer',
                  'Pesticide',
                  'Other'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
              const SizedBox(height: 30),
              const Center(child: Text('Availability')),
              const SizedBox(height: 20),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedLot,
                onChanged: (newValue) {
                  setState(() {
                    _selectedLot = newValue!;
                  });
                },
                items: ['Quintal', 'Ton', 'Kg', 'gram', 'Number', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Lot Type'),
              ),
              const SizedBox(height: 20),
              // Display existing images
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _imageUrls
                    .map((imageUrl) => Image.network(
                          imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectImage(ImageSource.gallery),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Select from Gallery'),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectImage(ImageSource.camera),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Take a Photo'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateService,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
