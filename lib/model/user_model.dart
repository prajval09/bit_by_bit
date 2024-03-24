// ignore: unused_import
import 'dart:typed_data';

class UserModel {
  String? uid;
  String? email;
  String? phone;
  String? city;
  String? Name;
  String? file;

  UserModel(
      {this.uid, this.email, this.phone, this.city, this.Name, this.file});

  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        phone: map['phone'],
        Name: map['Name'],
        city: map['city'],
        file: map['file']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'phone': phone,
      'Name': Name,
      'city': city,
      'file': file,
    };
  }
}
