import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sosyal_kampus_vscode/shared/appBar_widget.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';
import 'package:sosyal_kampus_vscode/shared/kullanici_bilgileri.dart';

class OgrenciKisiselBilgiler extends StatefulWidget {
  OgrenciKisiselBilgiler({Key key, @required this.user}) : super(key: key);
  final user;
  _OgrenciKisiselBilgilerState createState() => _OgrenciKisiselBilgilerState();
}

class _OgrenciKisiselBilgilerState extends State<OgrenciKisiselBilgiler> {
  bool loading = false;
  String error = '';
  File resimFile;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(45.0),
              child: AppBarWidget(
                title: "Kişisel Bilgiler",
              ),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(children: [
                
                
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset(
                            ('assets/arkaplan.jpeg'),
                            fit: BoxFit.cover,
                          ),
                  ),
                SingleChildScrollView(
                child: FutureBuilder<dynamic>(
                  future: ogrenciKullaniciBilgi(widget.user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 25,
                          ),
                          Center(
                            child: ClipOval(
                              child: Container(
                                height: 150, //fit: BoxFit.cover
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(38),
                                ),
                                child: (resimFile != null)
                                    ? Image.file(
                                        File(resimFile.path),
                                        fit: BoxFit.cover,
                                      )
                                    : ("${snapshot.data['kullaniciResim']}" !=
                                            "")
                                        ? Image.network(
                                            "${snapshot.data['kullaniciResim']}",
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            ('assets/profil.png'),
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                          ),
                          Divider(
                            height: 50,
                            thickness: 2, //genişlik
                            color: Colors.deepOrange,
                            indent: 90, //soldan boşluk
                            endIndent: 90, //sağdan boşluk
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                            child: Text(
                              "Kişisel Bilgiler",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                            child: Row(
                              children: [
                                Text(
                                  "Ad:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "${snapshot.data['ad']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                            child: Row(
                              children: [
                                Text(
                                  "Soyad:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${snapshot.data['soyad']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 50,
                            thickness: 2, //genişlik
                            color: Colors.deepOrange,
                            indent: 30, //soldan boşluk
                            endIndent: 30, //sağdan boşluk
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                            child: Text(
                              "Okul Bilgileri",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                            child: Row(
                              children: [
                                Text(
                                  "Üniversite Ad:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${snapshot.data['universite_ad']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                            child: Row(
                              children: [
                                Text(
                                  "Fakülte Ad:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "${snapshot.data['fakulte_ad']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                            child: Row(
                              children: [
                                Text(
                                  "Bölüm Ad:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 35,
                                ),
                                Text(
                                  "${snapshot.data['bolum_ad']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                            child: Row(
                              children: [
                                Text(
                                  "Sınıf:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 75,
                                ),
                                Text(
                                  "${snapshot.data['sinif']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),

                          /*
                          Resimm yerleştirme
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              30,
                              5,
                              30,
                              5,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  //borderRadius: BorderRadius.circular(38),
                                  //color: Colors.blue,
                                ),
                              alignment: Alignment.bottomLeft,
                              //height: 200,
                              //width: 300,
                              child: FittedBox(
                                child: Image.asset('assets/bilgiler.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          */
                        ],
                      );
                    } else {
                      return Loading();
                    }
                  },
                ),
              ),],),
            ),
          );
  }
}
