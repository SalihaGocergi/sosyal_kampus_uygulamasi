import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Users with ChangeNotifier {
  final String uid;
  final String ad;
  final String soyad;
  final String email;
  final String universite_ad;
  final String fakulte_ad;
  final String bolum_ad;
  final String sinif;
  final String kullaniciResim;
  final createdAt;
  final updatedAt;

  Users(
      {this.uid,
      this.ad,
      this.soyad,
      this.email,
      this.universite_ad,
      this.fakulte_ad,
      this.bolum_ad,
      this.sinif,
      this.kullaniciResim,
      this.createdAt,
      this.updatedAt});

  Users.fromFirestore(DocumentSnapshot document)
      : uid = document.id,
        ad = document.data()['ad'],
        soyad = document.data()['soyad'],
        email = document.data()['email'],
        universite_ad = document.data()['universite_ad'],
        fakulte_ad = document.data()['fakulte_ad'],
        bolum_ad = document.data()['bolum_ad'],
        sinif = document.data()['sinif'],
        kullaniciResim = document.data()['kullaniciResim'],
        //postAded = document.data()['postAded'],
        createdAt = document.data()['createdAt'],
        updatedAt = document.data()['updatedAt'];

}
