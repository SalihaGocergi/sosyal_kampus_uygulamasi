import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Post with ChangeNotifier {
  final String id;
  final String aciklama;
  final String resimUrl;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Post({
    this.id,
    this.aciklama,
    this.resimUrl,
    this.createdAt,
    this.updatedAt,
  });

  Post.fromFirestore(DocumentSnapshot document)
      : id = document.id,
        aciklama = document.data()['aciklama'],
        resimUrl = document.data()['resimUrl'],
        createdAt = document.data()['createdAt'],
        updatedAt = document.data()['updatedAt'];
}
