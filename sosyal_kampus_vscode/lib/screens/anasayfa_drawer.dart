import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosyal_kampus_vscode/isletmeciEkranlar/isletmeci_kisisel_bilgiler.dart';
import 'package:sosyal_kampus_vscode/isletmeciEkranlar/isletmeci_profil.dart';
import 'package:sosyal_kampus_vscode/models/user_ogrenciler.dart';
import 'package:sosyal_kampus_vscode/isletmeciEkranlar/isletmeci_hesap_olustur.dart';
import 'package:sosyal_kampus_vscode/models/user_isletmeci.dart';
import 'package:sosyal_kampus_vscode/screens/ilk_sayfa.dart';
import 'package:sosyal_kampus_vscode/screens/login.dart';
import 'package:sosyal_kampus_vscode/ogrenciEkranlar/ogrenci_hesap_olustur.dart';
import 'package:sosyal_kampus_vscode/ogrenciEkranlar/ogrenci_kisisel_bilgiler.dart';
import 'package:sosyal_kampus_vscode/ogrenciEkranlar/ogrenci_profil.dart';
import 'package:sosyal_kampus_vscode/services/auth.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';

class AnasayfaDrawer extends StatefulWidget {
  AnasayfaDrawer({
    Key key,
    @required this.user,
    @required this.hesapGecisi,
    @required this.isim,
  }) : super(key: key);
  var user;
  var hesapGecisi;
  var isim;

  @override
  _AnasayfaDrawerState createState() => _AnasayfaDrawerState();
}

class _AnasayfaDrawerState extends State<AnasayfaDrawer> {
  final AuthService _authOgrenci = AuthService();
  final AuthService2 _authIsletme = AuthService2();
  final gelenEmail = TextEditingController();
  final gelenAd = TextEditingController();
  final gelenSoyad = TextEditingController();
  final gelenKullaniciResim = TextEditingController();
  Users userOgrenciVeri;
  UsersIsletmeci userIsletmeciVeri;
  File resimFile;

  @override
  void dispose() {
    gelenEmail.dispose();
    gelenAd.dispose();
    gelenSoyad.dispose();
    gelenKullaniciResim.dispose();
    super.dispose();
  }

  SharedPreferences preferences;

  @override
  void initState() {
    if (widget.hesapGecisi == 0) {
      Future getUserOgrenci() async {
        Users currentUser = await DatabaseService().getProfile(widget.user.uid);
        setState(() {
          userOgrenciVeri = currentUser;
          gelenEmail.text = currentUser.email;
          gelenAd.text = userOgrenciVeri.ad;
          gelenSoyad.text = userOgrenciVeri.soyad;
          gelenKullaniciResim.text = userOgrenciVeri.kullaniciResim;
        });
      }

      getUserOgrenci();
    }
    if (widget.hesapGecisi == 1) {
      Future getUserIsletmeci() async {
        UsersIsletmeci currentUser =
            await DatabaseService2().getProfile(widget.user.uid);
        setState(() {
          userIsletmeciVeri = currentUser;
          gelenAd.text = userIsletmeciVeri.name;
          gelenSoyad.text = "";
          gelenKullaniciResim.text = userIsletmeciVeri.userImage;
        });
      }

      getUserIsletmeci();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final bool isAuthenticated = user != null;
    String email = '';

    if (isAuthenticated) {
      email = user.email;
    } else {
      email = 'Anonim';
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 140.0,
            child: DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[Color(0xFFff5722), Color(0xFFc7b198)],
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipOval(
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        //color: Colors.white,
                      ),
                      child: (resimFile != null)
                          ? Image.file(
                              File(resimFile.path),
                              fit: BoxFit.cover,
                            )
                          : ("${gelenKullaniciResim.text}" != "")
                              ? Image.network(
                                  "${gelenKullaniciResim.text}",
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  ('assets/profil.png'),
                                  fit: BoxFit.contain,
                                ),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      "${gelenAd.text + " " + gelenSoyad.text} ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (widget.hesapGecisi == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OgrenciProfil(
                                  user: widget.user,
                                  hesapGecisi: widget.hesapGecisi,
                                  isim: widget.isim)),
                        );
                      }
                      if (widget.hesapGecisi == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IsletmeciProfil(
                                  user: widget.user,
                                  hesapGecisi: widget.hesapGecisi,
                                  isim: widget.isim)),
                        );
                      }
                    },
                    padding: EdgeInsets.all(20),
                    textColor: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          if (isAuthenticated) ...[
            if (widget.hesapGecisi == 0) ...[
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Profil'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OgrenciProfil(
                              user: widget.user,
                              hesapGecisi: widget.hesapGecisi,
                              isim: widget.isim)),
                    );
                  },
                ),
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.featured_play_list_outlined),
                  title: Text('Gönderiler'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.featured_play_list_outlined),
                  title: Text('Kişisel Bilgiler'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OgrenciKisiselBilgiler(
                                user: user,
                              )),
                    );
                  },
                ),
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Çıkış'),
                  onTap: () async {
                    await _authOgrenci.signOut();
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LogIn(
                                hesapGecisi: widget.hesapGecisi,
                                isim: widget.isim,
                                email: user.email,
                              )),
                    );
                  },
                ),
              ),
            ],
            if (widget.hesapGecisi == 1) ...[
              InkWell(
                child: ListTile(
                    leading: Icon(Icons.account_circle),
                    title: Text('Profil'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => IsletmeciProfil(
                                user: widget.user,
                                hesapGecisi: widget.hesapGecisi,
                                isim: widget.isim)),
                      );
                    }),
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.featured_play_list_outlined),
                  title: Text('Gönderiler'),
                  onTap: () {
                    Navigator.pop(context);
                    /*Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyPosts(user:user)),
                  );*/
                  },
                ),
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.featured_play_list_outlined),
                  title: Text('Kişisel Bilgiler'),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IsletmeciKisiselBilgiler(
                                user: user,
                              )),
                    );
                  },
                ),
              ),
              InkWell(
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Çıkış'),
                  onTap: () async {
                    await _authIsletme.signOut();
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FirstPage()),
                    );
                  },
                ),
              ),
            ],
          ],
          if (!isAuthenticated) ...[
            InkWell(
              child: ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Login'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LogIn(
                            hesapGecisi: widget.hesapGecisi,
                            isim: widget.isim)),
                  );
                },
              ),
            ),
            InkWell(
              child: ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Kayıt Ol'),
                onTap: () {
                  Navigator.pop(context);
                  if (widget.hesapGecisi == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OgrenciHesapOlustur(
                              hesapGecisi: widget.hesapGecisi,
                              isim: widget.isim)),
                    );
                  }
                  if (widget.hesapGecisi == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => IsletmeciHesapOlustur(
                              hesapGecisi: widget.hesapGecisi,
                              isim: widget.isim)),
                    );
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
