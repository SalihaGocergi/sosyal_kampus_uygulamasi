import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_kampus_vscode/isletmeciEkranlar/isletmeci_anasayfa.dart';
import 'package:sosyal_kampus_vscode/ogrenciEkranlar/ogrenci_anasayfa.dart';
import 'package:sosyal_kampus_vscode/screens/anasayfa_drawer.dart';
import 'package:sosyal_kampus_vscode/screens/login.dart';
import 'package:sosyal_kampus_vscode/screens/gonderi_yeni.dart';
import 'package:sosyal_kampus_vscode/ogrenciEkranlar/anasayfa_ogrenci_gonderiler.dart';
import 'package:sosyal_kampus_vscode/shared/appBar_widget.dart';

class Anasayfa extends StatelessWidget {
  Anasayfa(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  var hesapGecisi;
  var isim;
  var user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (hesapGecisi == 0) ...[
          Flexible(child: OgrenciAnasayfa(user: user, hesapGecisi: hesapGecisi, isim: isim)),
        ],
        if (hesapGecisi == 1) ...[
          Flexible(child: IsletmeciAnasayfa(user: user, hesapGecisi: hesapGecisi, isim: isim)),
        ],
      ],
    );
  }
}
