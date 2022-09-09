import 'package:cloud_firestore/cloud_firestore.dart';

class UsersIsletmeci {
  final String uid;
  final String name;
  final String address;
  final String tel;
  final String email;
  final String userImage;
  final createdAt;
  final updatedAt;

  UsersIsletmeci(
      {this.uid,
      this.name,
      this.address,
      this.tel,
      this.email,
      this.userImage,
      this.createdAt,
      this.updatedAt});

  UsersIsletmeci.fromFirestore(DocumentSnapshot document)
      : uid = document.id,
        name = document.data()['name'],
        address = document.data()['address'],
        tel = document.data()['tel'],
        email = document.data()['email'],
        userImage = document.data()['userImage'],
        createdAt = document.data()['createdAt'],
        updatedAt = document.data()['updatedAt'];
}
