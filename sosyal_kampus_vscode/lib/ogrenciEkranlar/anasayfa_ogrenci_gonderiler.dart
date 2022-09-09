import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_kampus_vscode/models/post.dart';
import 'package:sosyal_kampus_vscode/models/user_ogrenciler.dart';
import 'package:sosyal_kampus_vscode/ogrenciEkranlar/gonderi_ayrinti_ogrenci.dart';
import 'package:sosyal_kampus_vscode/ogrenciEkranlar/ogrenci_profil.dart';
import 'package:sosyal_kampus_vscode/screens/anasayfa_drawer.dart';
import 'package:sosyal_kampus_vscode/screens/gonderi_yeni.dart';
import 'package:sosyal_kampus_vscode/screens/login.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';
import 'package:sosyal_kampus_vscode/shared/get_date_text.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';

class OgrenciAnasayfaGonderiler extends StatefulWidget {
  OgrenciAnasayfaGonderiler(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  var hesapGecisi;
  var isim;
  var user;

  @override
  _OgrenciAnasayfaGonderilerState createState() =>
      _OgrenciAnasayfaGonderilerState();
}

class _OgrenciAnasayfaGonderilerState extends State<OgrenciAnasayfaGonderiler> {
  @override
  Widget build(BuildContext context) {
    final user =
        Provider.of<User>(context); //user.uid => giriş yapan kullanıcı id'si
    final bool isAuthenticated = user != null;
    var users;
    File resimFile;
    users = Provider.of<List<Users>>(context) ?? [];
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          title: Text("${widget.isim} Anasayfa"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xFFff5722), Color(0xFFc7b198)],
              ),
            ),
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.add_alert),
              onPressed: () => {}, //Navigator.of(context).pop(null),
            ),
          ],
        ),
      ),
      drawer: AnasayfaDrawer(
        user: widget.user,
        hesapGecisi: widget.hesapGecisi,
        isim: widget.isim,
      ),
      body: Container(
        child: Center(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: StreamBuilder<List<Post>>(
                    stream: DatabaseService(uid: users[index].uid)
                        .bireyselKullaniciGonderiler,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Post> postss = snapshot.data;
                        //print("Uzunlukkkkk: ${postss.length}");
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: postss.length,
                            itemBuilder: (context, indexx) {
                              //print("post adet: $indexx");
                              return Center(
                                //LİSTTİLE OLARAK DURUYORDU
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
                                          Row(
                                            children: <Widget>[
                                              InkWell(
                                                child: ClipOval(
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
                                                        : ("${users[index].kullaniciResim}" !=
                                                                "")
                                                            ? Image.network(
                                                                "${users[index].kullaniciResim}",
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
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            OgrenciProfil(
                                                                user: users[
                                                                    index],
                                                                hesapGecisi: widget
                                                                    .hesapGecisi,
                                                                isim: widget
                                                                    .isim)),
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    160,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Container(
                                                      child: Text(
                                                        "${users[index].ad} " +
                                                            "${users[index].soyad}",
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
                                                          postss, indexx),
                                                      builder:
                                                          (BuildContext context,
                                                              AsyncSnapshot
                                                                  snapshot) {
                                                        if (snapshot.hasData) {
                                                          return Text(
                                                            //'${posts[index].createdAt.toDate()}',
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
                                            ],
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              "${postss[indexx].aciklama}",
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
                                                      '${postss[indexx].resimUrl}'),
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
                                            alignment: Alignment.bottomRight,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
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
                                                            GonderiAyrintiOgrenci(
                                                          post: postss[indexx],
                                                          user: users[index],
                                                          hesapGecisi: widget
                                                              .hesapGecisi,
                                                          isim: widget.isim,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  iconSize: 24,
                                                ),
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
                            });
                      } else {
                        return Loading();
                      }
                    }),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          if (isAuthenticated) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => YeniGonderi(
                    user: user,
                    hesapGecisi: widget.hesapGecisi,
                    isim: widget.isim),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LogIn(
                  isim: widget.isim,
                  hesapGecisi: widget.hesapGecisi,
                ),
              ),
            );
          }
        },
        tooltip: isAuthenticated ? 'Yeni Post' : 'Login',
        child: isAuthenticated
            ? Icon(
                Icons.note_add,
              )
            : Icon(
                Icons.settings_backup_restore,
              ),
      ),
    );
  }
}
