  import 'package:cloud_firestore/cloud_firestore.dart';

Future ogrenciKullaniciBilgi(String kullaniciId) async {
    var yorumYapan = await FirebaseFirestore.instance
        .collection('users')
        .doc("9llKrCnWfmYhxhE4Xq5P0tedBLC2")
        .collection("ogrenciler")
        .doc(kullaniciId)
        .get();
    return yorumYapan;
  }

Future isletmeciKullaniciBilgi(String kullaniciId) async {
    var yorumYapan = await FirebaseFirestore.instance
        .collection('users')
        .doc("9llKrCnWfmYhxhE4Xq5P0tedBLC2")
        .collection("isletmeciler")
        .doc(kullaniciId)
        .get();
    return yorumYapan;
  }