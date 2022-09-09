import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Gonderilerim extends StatefulWidget {
  Gonderilerim({Key key, @required this.user}) : super(key: key);
  final user;
  @override
  _GonderilerimState createState() => _GonderilerimState();
}

class _GonderilerimState extends State<Gonderilerim> {
  bool loading = false;
  String error = '';
  var gelenAciklama = "";
  var gelenResim = "";

  final databaseReference = FirebaseFirestore.instance;

  @override
  void initState() {
    //getPostData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*
      appBar: AppBar(
        title: Text('Gönderiler'),
      ),

       */
      body: Container(), //getPostData(),
    );
  }
/*
  Widget getPostData() {
    databaseReference
        .collection("users")
        .doc('9llKrCnWfmYhxhE4Xq5P0tedBLC2')
        .collection("ogrenciler")
        .doc(widget.user.uid)
        .collection("gonderiler")
        .getDocs()
        .then((QuerySnapshot snapshot) {
      print("kullanıcı: ${widget.user}");
      snapshot.docs.forEach((f) {
        print("kullanıcıdataa: ${f.data["soyad"]}");
        if (widget.user.email == f.data["email"]) {
          setState(() {
            gelenAciklama = f.data["aciklama"];
            gelenResim = f.data["resimUrl"];
          });
        }
      });
    });
  }
  */
}
