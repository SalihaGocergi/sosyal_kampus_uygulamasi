import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:sosyal_kampus_vscode/models/post.dart';
import 'package:sosyal_kampus_vscode/models/user_ogrenciler.dart';
import 'package:sosyal_kampus_vscode/models/yorumlar.dart';
import 'package:sosyal_kampus_vscode/services/auth.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';
import 'package:sosyal_kampus_vscode/shared/appBar_widget.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';
import 'package:sosyal_kampus_vscode/shared/yorum_yap_button.dart';
import 'package:sosyal_kampus_vscode/shared/kullanici_bilgileri.dart';

class GonderiAyrintiOgrenci extends StatefulWidget {
  GonderiAyrintiOgrenci({
    Key key,
    @required this.post,
    @required this.user,
    @required this.hesapGecisi,
    @required this.isim,
  }) : super(key: key);
  final Post post;
  final Users user;
  var hesapGecisi;
  var isim;

  @override
  _GonderiAyrintiOgrenciState createState() => _GonderiAyrintiOgrenciState();
}

int sayac = 0;

class _GonderiAyrintiOgrenciState extends State<GonderiAyrintiOgrenci> {
  final _dbOgrenci = AuthService();

  bool loading = false;
  String error = '';
  Users user;
  var yorumYapanAdKontrol = "";
  var yorumYapanSoyadKontrol = "";
  var yorumYapanResimKontrol = "";
  File resimFile;

  @override
  Widget build(BuildContext context) {
    //print("Giriş yapan kullanıcı id: ${user.uid}");
    print("Post id: ${widget.post.id}");
    print("Gelen user id: ${widget.user.uid}");

    return loading
        ? Loading()
        : Scaffold(
            floatingActionButton: MyFloatingActionButton(
              post: widget.post,
              user: widget.user,
              hesapGecisi: widget.hesapGecisi,
              isim: widget.isim,
            ),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(45.0),
              child: AppBarWidget(
                title: "Yorumlar",
              ),
            ),
            body: ListTile(
              title: ListView(
                children: [
                  gonderiGovdesi(context),
                  SizedBox(
                    height: 5,
                  ),
                  yorumlarGovdesi()
                ],
              ),
            ),
          );
  }

  Column yorumlarGovdesi() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Yorumlar",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Divider(
          color: Colors.black,
          thickness: 1.0,
        ),
        //BU ALANA LİSTVİEWBUİLDER KULLANACAĞIM
        StreamBuilder<List<Yorumlar>>(
          stream:
              DatabaseService(uid: widget.user.uid, GonderiId: widget.post.id)
                  .bireyselKullaniciYorumlar,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Yorumlar> yorum = snapshot.data;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: yorum.length,
                itemBuilder: (context, index) {
                  //getUser(yorum[index].yorumYapanId);
                  //print("Yorum yapan idDDDDDDDDD: ${yorum[index].yorumYapanId}");
                  return FutureBuilder<dynamic>(
                      future: ogrenciKullaniciBilgi(yorum[index].yorumYapanId),
                      builder: (context, snapshot2) {
                        if (snapshot2.hasData) {
                          return Column(
                            children: [
                              Container(
                                //height: 80,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.black12)),
                                child: ListTile(
                                  leading: ClipOval(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: (resimFile != null)
                                          ? Image.file(
                                              File(resimFile.path),
                                              fit: BoxFit.cover,
                                            )
                                          : ("${snapshot2.data['kullaniciResim']}" !=
                                                  "")
                                              ? Image.network(
                                                  "${snapshot2.data['kullaniciResim']}",
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  ('assets/profil.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                    ),
                                  ),
                                  title: Text(
                                    "${snapshot2.data['ad']} " +
                                        "${snapshot2.data['soyad']}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "${yorum[index].yorum}",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black54),
                                  ),
                                  dense: true,
                                  trailing: Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                    size: 22,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          );
                        } else {
                          return Loading();
                        }
                      });
                },
              );
            } else {
              return Loading();
            }
          },
        ),
      ],
    );
  }

  Padding gonderiGovdesi(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        child: Container(
          height: 390,
          width: 500,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: (resimFile != null)
                          ? Image.file(
                              File(resimFile.path),
                              fit: BoxFit.cover,
                            )
                          : (widget.user.kullaniciResim != "")
                              ? Image.network(
                                  widget.user.kullaniciResim,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  ('assets/profil.png'),
                                  fit: BoxFit.cover,
                                ),
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 160,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.user.ad + " " + widget.user.soyad,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Text(
                          //'${posts[index].createdAt.toDate()}',
                          DateFormat('dd/MM/yyyy').format(DateTime.parse(
                              '${widget.post.createdAt.toDate()}')),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "${widget.post.aciklama}",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 200,
                width: (MediaQuery.of(context).size.width - 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  //color: Colors.deepOrangeAccent,
                  image: DecorationImage(
                      image: NetworkImage(
                        '${widget.post.resimUrl}',
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Divider(
                color: Colors.black54,
                thickness: 1.0,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      AntDesign.star,
                      //içi dolu  AntDesign.staro => içi boş anlamında
                      color: Colors.red,
                      size: 25,
                    ),
                    Icon(
                      AntDesign.star,
                      color: Colors.red,
                      size: 25,
                    ),
                    Icon(
                      AntDesign.star,
                      color: Colors.red,
                      size: 25,
                    ),
                    Icon(
                      AntDesign.star,
                      color: Colors.red,
                      size: 25,
                    ),
                    Icon(
                      AntDesign.staro,
                      color: Colors.red,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getUser(String yorumYapanId) {
    print("Gelennnn id: ${yorumYapanId}");
    FirebaseFirestore.instance
        .collection('users')
        .doc('9llKrCnWfmYhxhE4Xq5P0tedBLC2')
        .collection('ogrenciler')
        .doc(yorumYapanId)
        .get()
        .then((gelenVeri) {
      setState(() {
        yorumYapanAdKontrol = gelenVeri.data()["ad"];
        yorumYapanSoyadKontrol = gelenVeri.data()["soyad"];
      });
    });

    //user = yorumYapanKullanici;
    print("yorumm yapann addddd: ${yorumYapanAdKontrol}");
    //_yorumYapanAdKontrol = user.ad;
    //_yorumYapanResimKontrol.text = user.userImage ?? '';
  }
}
