import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Takipler with ChangeNotifier {
  final String id;
  final String takipEdilenId;

  Takipler({
    this.id,
    this.takipEdilenId,
  });

  Takipler.fromFirestore(DocumentSnapshot document)
      : id = document.id,
        takipEdilenId = document.data()['takipEdilenId:'];
}
