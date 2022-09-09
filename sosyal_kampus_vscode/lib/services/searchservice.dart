import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService{
  searchOgrenciByName(String searchField){
    return FirebaseFirestore.instance
        .collection('users')
        .doc('9llKrCnWfmYhxhE4Xq5P0tedBLC2')
        .collection('ogrenciler')
        .where('ad_control', isEqualTo: searchField.substring(0,1).toUpperCase())
        .get();
  }
  searchIsletmeciByName(String searchField){
    return FirebaseFirestore.instance
        .collection('users')
        .doc('9llKrCnWfmYhxhE4Xq5P0tedBLC2')
        .collection('isletmeciler')
        .where('ad_control', isEqualTo: searchField.substring(0,1).toUpperCase())
        .get();
  }
}