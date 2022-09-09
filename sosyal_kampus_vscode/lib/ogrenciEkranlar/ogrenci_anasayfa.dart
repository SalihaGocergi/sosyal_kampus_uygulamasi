import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_kampus_vscode/mesajlasma/chatrooms.dart';
import 'package:sosyal_kampus_vscode/screens/arama.dart';
import 'package:sosyal_kampus_vscode/ogrenciEkranlar/anasayfa_ogrenci_gonderiler.dart';
import 'package:sosyal_kampus_vscode/screens/mesajla%C5%9Fma.dart';

class OgrenciAnasayfa extends StatefulWidget {
  OgrenciAnasayfa(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  var hesapGecisi;
  var isim;
  var user;

  @override
  _OgrenciAnasayfaState createState() => _OgrenciAnasayfaState();
}

class _OgrenciAnasayfaState extends State<OgrenciAnasayfa>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final databaseReference = FirebaseFirestore.instance;
  //var gelenAd = "";
  //var gelenSoyad = "";

  TabController _tabController;
  //var posts;
  //var users;

  @override
  void initState() {
    super.initState();
    //getData();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: TabBarView(
          controller: _tabController,
          children: [
            OgrenciAnasayfaGonderiler(
                user: widget.user,
                hesapGecisi: widget.hesapGecisi,
                isim: widget.isim),
            Arama(
                user: widget.user,
                hesapGecisi: widget.hesapGecisi,
                isim: widget.isim),
            Mesajlasma(
                user: widget.user,
                hesapGecisi: widget.hesapGecisi,
                isim: widget.isim),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (currentIndex) {
            setState(() {
              _currentIndex = currentIndex;
            });

            _tabController.animateTo(_currentIndex);
          },
          items: [
            BottomNavigationBarItem(
              title: Text("Anasayfa"),
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              title: Text("Arama"),
              icon: Icon(Icons.search),
            ),
            BottomNavigationBarItem(
              title: Text("Mesaj"),
              icon: Icon(Icons.message_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
