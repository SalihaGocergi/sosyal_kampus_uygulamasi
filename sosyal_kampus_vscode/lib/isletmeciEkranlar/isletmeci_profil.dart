import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sosyal_kampus_vscode/isletmeciEkranlar/isletmeci_kisisel_bilgiler.dart';
import 'package:sosyal_kampus_vscode/isletmeciEkranlar/isletmeci_gonderiler.dart';
import 'package:sosyal_kampus_vscode/isletmeciEkranlar/isletmeci_profil_duzenle.dart';
import 'package:sosyal_kampus_vscode/models/user_isletmeci.dart';
import 'package:sosyal_kampus_vscode/screens/anasayfa.dart';
import 'package:sosyal_kampus_vscode/screens/gonderi_yeni.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';
import 'package:sosyal_kampus_vscode/shared/appBar_widget.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';

class IsletmeciProfil extends StatefulWidget {
  IsletmeciProfil(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  final user;
  var hesapGecisi;
  var isim;

  @override
  _IsletmeciProfilState createState() => _IsletmeciProfilState();
}

class _IsletmeciProfilState extends State<IsletmeciProfil>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  String error = '';

  TabController _tabController;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    final kullanici = Provider.of<User>(context);
    return loading
        ? Loading()
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(45.0),
              child: AppBar(
                title: Text("Profil"),
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[Color(0xFFff5722), Color(0xFFc7b198)],
                    ),
                  ),
                ),
                actions: <Widget>[
                  new IconButton(
                    icon: new Icon(Icons.home_rounded),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Anasayfa(
                              user: widget.user,
                              hesapGecisi: widget.hesapGecisi,
                              isim: widget.isim),
                        ),
                      );
                    }, 
                  ),
                ],
              ),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IsletmeciProfilKismi(
                    kullanici: kullanici,
                    user: widget.user,
                    hesapGecisi: widget.hesapGecisi,
                    isim: widget.isim,
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          5.0,
                        ),
                        color: Colors.deepOrange,
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black,
                      tabs: [
                        Tab(
                          text: 'Paylaşımlar',
                        ),
                        Tab(
                          text: 'Takipçi',
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Container(
                          child: Center(
                            child: IsletmeciGonderiler(
                              user: widget.user,
                              hesapGecisi: widget.hesapGecisi,
                              isim: widget.isim,
                            ),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Container(
                              child: Text("takipçi"),
                            ), /* OgrenciProfilKisiler(
                                  user: widget.user,
                                  hesapGecisi: widget.hesapGecisi,
                                  isim: widget.isim),*/
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.deepOrange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => YeniGonderi(
                          user: widget.user,
                          hesapGecisi: widget.hesapGecisi,
                          isim: widget.isim),
                    ),
                  );
                },
                tooltip: 'Yeni Post',
                child: Icon(Icons.note_add)),
          );
  }
}

class IsletmeciProfilKismi extends StatefulWidget {
  IsletmeciProfilKismi(
      {Key key,
      @required this.kullanici,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  final user;
  var hesapGecisi;
  var isim;
  var kullanici;

  @override
  _IsletmeciProfilKismiState createState() => _IsletmeciProfilKismiState();
}

class _IsletmeciProfilKismiState extends State<IsletmeciProfilKismi> {
  final gelenAd = TextEditingController();
  final gelenTel = TextEditingController();
  final gelenAdres = TextEditingController();
  final gelenKullaniciResim = TextEditingController();
  var takipEdilenUid = "";
  UsersIsletmeci userVeri;
  File resimFile;
  bool takipteMi = false;
  @override
  void dispose() {
    gelenAd.dispose();
    gelenTel.dispose();
    gelenAdres.dispose();
    gelenKullaniciResim.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future getUser() async {
      UsersIsletmeci currentUser =
          await DatabaseService2().getProfile(widget.user.uid);
      setState(() {
        userVeri = currentUser;
        gelenAd.text = userVeri.name;
        gelenTel.text = userVeri.tel;
        gelenAdres.text = userVeri.address;
        gelenKullaniciResim.text = userVeri.userImage;
      });
    }

    getUser();
    takipteMiKontrol();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool loading = false;
    String error = '';

    Future takipEtme(BuildContext context) async {
      dynamic result = await DatabaseService()
          .takipEkle(widget.kullanici.uid, widget.user.uid);
      return result;
    }

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.deepOrange),
          borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.all(10),
      height: 200,
      child: Column(
        children: [
          profilBilgileriGovdesi(),
          profilBilgilerGovdesiButtonAlani(context, takipEtme, error, loading),
        ],
      ),
    );
  }

  SingleChildScrollView profilBilgileriGovdesi() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 30, 0, 30),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                ),
                child: (resimFile != null)
                    ? Image.file(
                        File(resimFile.path),
                        fit: BoxFit.cover,
                      )
                    : (gelenKullaniciResim.text != "")
                        ? Image.network(
                            gelenKullaniciResim.text,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            ('assets/profil.png'),
                            fit: BoxFit.cover,
                          ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              //width: MediaQuery.of(context).size.width - 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${gelenAd.text}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${"Tel:        " + gelenTel.text}",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Colors.black87),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${"Adres:  " + gelenAdres.text}",
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
    );
  }

  Row profilBilgilerGovdesiButtonAlani(BuildContext context,
      Future takipEtme(BuildContext context), String error, bool loading) {
    return Row(
      children: [
        if (widget.user.uid == widget.kullanici.uid) ...[
          profilDuzenleButton(context),
        ],
        kisiselBilgilerButton(context),
        if (widget.user.uid != widget.kullanici.uid) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Container(
              width: 110,
              height: 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (takipteMi == true) ...[
                    takipEdiliyorButton(context),
                  ],
                  if (takipteMi == false) ...[
                    takipEtButton(takipEtme, context, error, loading),
                  ],
                ],
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
      ],
    );
  }

  Padding profilDuzenleButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
      child: Container(
        width: 110,
        height: 32,
        child: TextButton(
          child: Text("Profil Düzenle", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IsletmeciProfilDuzenle(
                  user: widget.user,
                  hesapGecisi: widget.hesapGecisi,
                  isim: widget.isim,
                ),
              ),
            );
          },
        ),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
      ),
    );
  }

  Padding kisiselBilgilerButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0), //270
      child: Container(
        width: 110,
        height: 32,
        child: TextButton(
          child:
              Text("Kişisel Bilgiler", style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      IsletmeciKisiselBilgiler(user: widget.user)),
            );
          },
        ),
        decoration: BoxDecoration(
          color: Colors.deepOrange,
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
      ),
    );
  }

  TextButton takipEtButton(Future takipEtme(BuildContext context),
      BuildContext context, String error, bool loading) {
    return TextButton(
      child: Text("Takip Et", style: TextStyle(color: Colors.white)),
      onPressed: () {
        dynamic result = takipEtme(context);
        try {
          if (result != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Takip ediliyor.'),
              duration: const Duration(milliseconds: 100),
              width: 100.0,
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ));
            /*
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OgrenciProfil(
                    user: widget.user,
                    hesapGecisi: widget.hesapGecisi,
                    isim: widget.isim),
              ),
            );
            */
          } else {
            setState(() {
              error = 'Bilgilerini kontrol ediniz!';
              loading = false;
            });
          }
        } catch (e) {
          print('Hata Oluştu!!: $e');
        }
      },
    );
  }

  TextButton takipEdiliyorButton(BuildContext context) {
    return TextButton(
      child: Text("Takip Ediliyor", style: TextStyle(color: Colors.white)),
      onPressed: () {
        Alert(context: context, title: "Takipten Çıkıyorsunuz", buttons: [
          DialogButton(
              color: Colors.orange[900],
              child: Text("Çık",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              onPressed: () {
                DatabaseService(uid: widget.kullanici.uid)
                    .takiptenCikar(takipEdilenUid);
/*
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OgrenciProfil(
                        user: widget.user,
                        hesapGecisi: widget.hesapGecisi,
                        isim: widget.isim),
                  ),
                );
                */
              })
        ]).show();
      },
    );
  }

  void takipteMiKontrol() {
    //final kullaniciGiris = Provider.of<User>(context);

    FirebaseFirestore.instance
        .collection("users")
        .doc('9llKrCnWfmYhxhE4Xq5P0tedBLC2')
        .collection("isletmeciler")
        .doc(widget.kullanici.uid)
        .collection("takipler")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((f) {
        if (widget.user.uid == f.data()["takipEdilenId:"]) {
          takipEdilenUid = f.id;
          setState(() {
            takipteMi = true;
          });
        } else {
          setState(() {
            takipteMi = false;
          });
        }
      });
    });
  }
}
