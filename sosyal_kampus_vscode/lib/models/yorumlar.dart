import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Yorumlar with ChangeNotifier {
  final String id;
  final String yorumYapanId;
  final String yorum;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Yorumlar({
    this.id,
    this.yorumYapanId,
    this.yorum,
    this.createdAt,
    this.updatedAt,
  });

  Yorumlar.fromFirestore(DocumentSnapshot document)
      : id = document.id,
        yorumYapanId = document.data()['yorumYapanId:'],
        yorum = document.data()['yorum'],
        createdAt = document.data()['createdAt'],
        updatedAt = document.data()['updatedAt'];
}
