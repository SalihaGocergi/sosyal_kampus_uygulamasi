import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_kampus_vscode/models/user.dart';
import 'package:sosyal_kampus_vscode/screens/yeni_gonderi.dart';
import 'package:sosyal_kampus_vscode/services/auth.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';


class OgrenciProfil extends StatefulWidget {
  //Users user;
  OgrenciProfil(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  final user;
  var hesapGecisi;
  var isim;

  @override
  _OgrenciProfilState createState() => _OgrenciProfilState();
}

class _OgrenciProfilState extends State<OgrenciProfil>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  String error = '';
  final _auth = AuthService();
  Users user;
  File _image;
  final databaseReference = FirebaseFirestore.instance;
  var gelenAd = "";
  var gelenSoyad = "";
  var gelenUniversiteAd = "";
  var gelenBolumAd = "";
  var gelenSinif = "";

  int _currentIndex = 0;

  List<Widget> _tabList = [
    //Gonderilerim(user: user),
    Container(
      color: Colors.red,
    ),
    Container(
      color: Colors.purple,
    )
  ];

  TabController _tabController;

  @override
  void initState() {
     getData();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(45.0), child: AppBar()),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.deepOrange),
                        borderRadius: BorderRadius.circular(16)),
                    margin: EdgeInsets.all(10),
                    height: 200,
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 30, 0, 30),
                            child: Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    image: DecorationImage(
                                        image:
                                            AssetImage('assets/profilll.png'),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(5.0),
                                  //width: MediaQuery.of(context).size.width - 160,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "${gelenAd + " " + gelenSoyad} ",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${gelenUniversiteAd + " Üniversitesi"}",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        gelenBolumAd,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        "${gelenSinif + " .Sınıf"}",
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 0, 270, 0),
                          child: Container(
                            width: 110,
                            height: 32,
                            child: Center(
                              child: Text("Profil Düzenle"),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: TabBar(
                      controller: _tabController,
                      // give the indicator a decoration (color and border radius)
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                        color: Colors.deepOrange,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        // first tab [you can add an icon using the icon property]
                        Tab(
                          text: 'Paylaşımlar',
                        ),

                        // second tab [you can add an icon using the icon property]
                        Tab(
                          text: 'Kişiler',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        //Gonderilerim(user: user),
                        Container(
                          child: Center(
                            child: Text("GÖNDERİLERİM"),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Text("KİŞİLER"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // tab bar view here

            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.deepOrange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YeniGonderi(
                          user: widget.user,hesapGecisi: widget.hesapGecisi, isim: widget.isim),
                    ),
                  );
                },
                tooltip: 'Yeni Post',
                child: Icon(Icons.note_add)),
          );
  }

  Widget getData() {
    databaseReference
        .collection("users")
        .doc('9llKrCnWfmYhxhE4Xq5P0tedBLC2')
        .collection("ogrenciler")
        .get()
        .then((QuerySnapshot snapshot) {
      //print("kullanıcı: ${widget.user.uid}");
      snapshot.docs.forEach((doc) {
        //print("kullanıcıdataa: ${f.data["email"]}");
        if (widget.user.email == doc["email"]) {
          setState(() {
            gelenAd = doc["ad"];
            gelenSoyad = doc["soyad"];
            gelenUniversiteAd = doc["universite_ad"];
            gelenBolumAd = doc["bolum_ad"];
            gelenSinif = doc["sinif"];
          });
        }
      });
    });
  }
  
}

Widget VeriGonder(BuildContext context, List<DocumentSnapshot> snapshot) {
  return ListView(
    scrollDirection: Axis.vertical,
    padding: EdgeInsets.all(10.0),
    children: snapshot
        .map(
          (data) => InkWell(
            onTap: () {},
            child: ListTile(
              subtitle: Center(
                child: Text(
                  data["ad"],
                  style: TextStyle(fontSize: 25, color: Colors.blueGrey),
                ),
              ),
            ),
          ),
        )
        .toList(),
  );
}

/*
TabBarView(
controller: _tabController,
children: _tabList,),
Nav(currentIndex: _currentIndex,
onTap: (currentIndex){

setState(() {
_currentIndex = currentIndex;
});

_tabController.animateTo(_currentIndex);

},
items: [
BottomNavigationBarItem(
title: Text("Paylaşılan"),
icon: Icon(Icons.wysiwyg),
),
BottomNavigationBarItem(
title: Text("Beğeniler"),
icon: Icon(Icons.thumb_up),
),
BottomNavigationBarItem(
title: Text("Kişiler"),
icon: Icon(Icons.people_outline_sharp),
),
],
),
 */
