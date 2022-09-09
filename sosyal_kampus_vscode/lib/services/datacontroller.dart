import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  Future getData(String collection) async {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot =
        await firebaseFirestore.collection(collection).get();
    return snapshot.docs;
  }

  Future queryData(String queryString) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc('9llKrCnWfmYhxhE4Xq5P0tedBLC2')
        .collection('ogrenciler')
        .where('ad', isGreaterThanOrEqualTo: queryString) //isGreaterThanOrEqualTo
        .get();
  }
}
