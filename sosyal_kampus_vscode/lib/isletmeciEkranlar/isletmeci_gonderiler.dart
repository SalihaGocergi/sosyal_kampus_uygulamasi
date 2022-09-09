import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_kampus_vscode/isletmeciEkranlar/gonderi_ayrinti_isletmeci.dart';
import 'package:sosyal_kampus_vscode/models/post.dart';
import 'package:sosyal_kampus_vscode/screens/gonderi_duzenle.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';
import 'package:sosyal_kampus_vscode/shared/get_date_text.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';
import 'package:sosyal_kampus_vscode/shared/kullanici_bilgileri.dart';

class IsletmeciGonderiler extends StatefulWidget {
  IsletmeciGonderiler(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  final user;
  var hesapGecisi;
  var isim;
  @override
  _IsletmeciGonderilerState createState() => _IsletmeciGonderilerState();
}

class _IsletmeciGonderilerState extends State<IsletmeciGonderiler> {
  bool loading = false;
  String error = '';
  var gelenAciklama = "";
  var gelenResim = "";
  File resimFile;

  final databaseReference = FirebaseFirestore.instance;

  @override
  void initState() {
    getPostData();
  }

  @override
  Widget build(BuildContext context) {
    final girisYapanKullanici = Provider.of<User>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListTile(
                title: FutureBuilder<dynamic>(
                    future: isletmeciKullaniciBilgi(widget.user.uid),
                    builder: (context, snapshot2) {
                      if (snapshot2.hasData) {
                        return StreamBuilder<List<Post>>(
                          stream: DatabaseService2(uid: widget.user.uid)
                              .bireyselKullaniciGonderiler,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Post> posts = snapshot.data;
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: posts.length,
                                  itemBuilder: (context, index) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(16),
                                          elevation: 4,
                                          child: Container(
                                            height: 410,
                                            width: 500,
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              children: [
                                                ListTile(
                                                  dense: true,
                                                  leading: ClipOval(
                                                    child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                20),
                                                      ),
                                                      child: (resimFile != null)
                                                          ? Image.file(
                                                              File(
                                                                  resimFile.path),
                                                              fit: BoxFit.cover,
                                                            )
                                                          : ("${snapshot2.data['userImage']}" !=
                                                                  "")
                                                              ? Image.network(
                                                                  "${snapshot2.data['userImage']}",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : Image.asset(
                                                                  ('assets/profil.png'),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                    ),
                                                  ),
                                                  title: Container(
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        160,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Text(
                                                            "${snapshot2.data['name']}",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        FutureBuilder(
                                                          future: getDateText(
                                                              posts, index),
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot
                                                                  snapshot) {
                                                            if (snapshot
                                                                .hasData) {
                                                              return Text(
                                                                snapshot.data,
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .grey),
                                                              );
                                                            } else {
                                                              return CircularProgressIndicator();
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  trailing: Column(
                                                    children: [
                                                      if (girisYapanKullanici
                                                              .uid ==
                                                          widget.user.uid) ...[
                                                        Flexible(
                                                          child: PopupMenuButton(
                                                            //POSTUN YANINDA SAĞ TARAFTA DÜZENLE SİL MENÜSÜ
                                                            onSelected:
                                                                (result) async {
                                                              final type =
                                                                  result['type'];
                                                              final post =
                                                                  result['value'];
                                                              switch (type) {
                                                                case 'edit':
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              GonderiDuzenle(
                                                                        user: widget
                                                                            .user,
                                                                        post:
                                                                            post,
                                                                        hesapGecisi:
                                                                            widget
                                                                                .hesapGecisi,
                                                                        isim: widget
                                                                            .isim,
                                                                      ),
                                                                    ),
                                                                  );
                                                                  break;
                                                                case 'delete':
                                                                  DatabaseService2(
                                                                          uid: widget
                                                                              .user
                                                                              .uid)
                                                                      .deletePost(
                                                                          post.id);
                                                                  break;
                                                              }
                                                            },
                                                            itemBuilder: (BuildContext
                                                                    context) =>
                                                                <PopupMenuEntry>[
                                                              PopupMenuItem(
                                                                  value: {
                                                                    'type':
                                                                        'edit',
                                                                    'value':
                                                                        posts[
                                                                            index]
                                                                  },
                                                                  child: Text(
                                                                      'Düzenle')),
                                                              PopupMenuItem(
                                                                  value: {
                                                                    'type':
                                                                        'delete',
                                                                    'value':
                                                                        posts[
                                                                            index]
                                                                  },
                                                                  child: Text(
                                                                      'Sil')),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                      if (girisYapanKullanici
                                                              .uid !=
                                                          widget.user.uid) ...[
                                                        Flexible(child: Text("")),
                                                      ],
                                                    ],
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.all(0),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  alignment: Alignment.bottomLeft,
                                                  child: Text(
                                                    "${posts[index].aciklama}",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Container(
                                                  height: 200,
                                                  width: (MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      50),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(5),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            '${posts[index].resimUrl}'),
                                                        //image.toString()
                                                        //fit: BoxFit.scaleDown,
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
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      /*
                                                      IconButton(
                                                        icon: Icon(
                                                          Icons.message_outlined,
                                                          color: Colors.black,
                                                          size: 25,
                                                        ),
                                                        
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  GonderiAyrintiIsletmeci(
                                                                post:
                                                                    posts[index],
                                                                user: widget.user,
                                                                hesapGecisi: widget
                                                                    .hesapGecisi,
                                                                isim: widget.isim,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        
                                                        iconSize: 24,
                                                      ),
                                                      */
                                                      
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.end,
                                                        children: [
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
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  );
                            } else {
                              return Loading();
                            }
                          },
                        );
                      } else {
                        return Loading();
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
      //getPostData(),
    );
  }

  Widget getPostData() {
    databaseReference
        .collection("users")
        .doc('9llKrCnWfmYhxhE4Xq5P0tedBLC2')
        .collection("ogrenciler")
        .doc(widget.user.uid)
        .collection("isletmeciler")
        .get()
        .then((QuerySnapshot snapshot) {
      //print("kullanıcı: ${widget.user}");
      snapshot.docs.forEach((f) {
        //print("kullanıcıdataa: ${f.data()["soyad"]}");
        if (widget.user.email == f.data()["email"]) {
          setState(() {
            gelenAciklama = f.data()["aciklama"];
            gelenResim = f.data()["resimUrl"];
          });
        }
      });
    });
  }
}
