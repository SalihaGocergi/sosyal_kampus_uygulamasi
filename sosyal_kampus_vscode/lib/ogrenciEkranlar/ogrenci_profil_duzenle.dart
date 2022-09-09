import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_kampus_vscode/models/user_ogrenciler.dart';
import 'package:sosyal_kampus_vscode/ogrenciEkranlar/ogrenci_profil.dart';
import 'package:sosyal_kampus_vscode/screens/anasayfa.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';
import 'package:sosyal_kampus_vscode/shared/appBar_widget.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';

class OgrenciProfilDuzenle extends StatefulWidget {
  OgrenciProfilDuzenle(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  var user;
  var hesapGecisi;
  var isim;
  @override
  _OgrenciProfilDuzenleState createState() => _OgrenciProfilDuzenleState();
}

class _OgrenciProfilDuzenleState extends State<OgrenciProfilDuzenle> {
  bool loading = false;
  String error = '';
  final _updateFormKey = GlobalKey<FormState>();
  final _emailKontrol = TextEditingController();
  final _adKontrol = TextEditingController();
  final _soyadKontrol = TextEditingController();
  final _universiteAdKontrol = TextEditingController();
  final _fakulteAdKontrol = TextEditingController();
  final _bolumAdKontrol = TextEditingController();
  final _sinifKontrol = TextEditingController();
  final _kullaniciResimKontrol = TextEditingController();
  String indirmeBaglatisi;

  ImagePicker imagePicker;
  File resimFile;
  var url;
  Users user;

  @override
  void dispose() {
    _adKontrol.dispose();
    _emailKontrol.dispose();
    _soyadKontrol.dispose();
    _universiteAdKontrol.dispose();
    _fakulteAdKontrol.dispose();
    _bolumAdKontrol.dispose();
    _sinifKontrol.dispose();
    _kullaniciResimKontrol.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future getUser() async {
      Users currentUser = await DatabaseService().getProfile(widget.user.uid);
      setState(() {
        user = currentUser;
        _adKontrol.text = user.ad;
        _emailKontrol.text = user.email;
        _soyadKontrol.text = user.soyad;
        _universiteAdKontrol.text = user.universite_ad;
        _fakulteAdKontrol.text = user.fakulte_ad;
        _bolumAdKontrol.text = user.bolum_ad;
        _sinifKontrol.text = user.sinif;
        _kullaniciResimKontrol.text = user.kullaniciResim;
      });
    }

    getUser();
    imagePicker = ImagePicker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future resmiGaleridenGetirVeStorageEkleme() async {
      final resim = await imagePicker.getImage(
        source: ImageSource.gallery,
      );
      setState(() {
        resimFile = File(resim.path); //File(resim?.path ?? _resimKontrol.text)
      });

      String fileName = basename(resimFile.path);
      var firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);

      //RESMİ YÜKLEME
      UploadTask uploadTask = firebaseStorageRef.putFile(File(resimFile.path));
      url = await (await uploadTask).ref.getDownloadURL();
      setState(() {
        indirmeBaglatisi = url;
        _kullaniciResimKontrol.text = url;
      });
      print("resmiGaleridenGetirVeStorageEkleme urllllllll: $indirmeBaglatisi");
    }

    searchIndexUploadData(User user, String name) {
      final database = FirebaseFirestore.instance;
      List<String> splitList = name.split(' ');
      List<String> indexList = [];

      for (int i = 0; i < splitList.length; i++) {
        for (int j = 0; j < splitList[i].length + i; j++) {
          indexList.add(splitList[i].substring(0, j).toLowerCase());
        }
      }

      database
          .collection('users')
          .doc('9llKrCnWfmYhxhE4Xq5P0tedBLC2')
          .collection('ogrenciler')
          .doc(user.uid)
          .update({'arananIndex': indexList});

      //.set({'product' : name, 'arananIndex' : indexList});
    }

    Future gonderiGuncelle(BuildContext context) async {
      // Firebase kimlik doğrulamasına göre kullanıcı girişi
      //final user = Provider.of<User>(context, listen: false);

      dynamic result = await DatabaseService(uid: widget.user.uid).editProfile(
        widget.user.uid,
        _emailKontrol.text,
        _adKontrol.text,
        _soyadKontrol.text,
        indirmeBaglatisi, //.trim()   _resim.resolveSymbolicLinksSync()
        _universiteAdKontrol.text,
        _fakulteAdKontrol.text,
        _bolumAdKontrol.text,
        _sinifKontrol.text,
      );
      searchIndexUploadData(widget.user, _adKontrol.text);
      return result;
    }

    return loading
        ? Loading()
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(45.0),
              child: AppBar(
                title: Text("Profil Düzenle"),
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
              child: SingleChildScrollView(
                child: Form(
                  key: _updateFormKey,
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 25,
                      ),
                      Center(
                        child: Stack(
                          children: <Widget>[
                            ClipOval(
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
                                    : (_kullaniciResimKontrol.text != "")
                                        ? Image.network(
                                            _kullaniciResimKontrol.text,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            ('assets/profil.png'),
                                            fit: BoxFit.cover,
                                          ),
                              ),
                            ),
                            Positioned(
                              top: 85,
                              left: 85,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    color: Colors.grey,
                                    size: 50.0,
                                  ),
                                  onPressed: () {
                                    resmiGaleridenGetirVeStorageEkleme();
                                  }),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 50,
                        thickness: 2, //genişlik
                        color: Colors.deepOrange,
                        indent: 40, //soldan boşluk
                        endIndent: 40, //sağdan boşluk
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            hintText: 'Adınız',
                            labelText: 'Ad *',
                          ),
                          controller: _adKontrol,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen isim giriniz";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            hintText: 'Soyadınız',
                            labelText: 'Soyad *',
                          ),
                          controller: _soyadKontrol,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen soyadınızı giriniz";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.drive_file_rename_outline),
                            hintText: 'Örn. Necmettin Erbakan',
                            labelText: 'Üniversite Ad *',
                          ),
                          controller: _universiteAdKontrol,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen üniversite adını giriniz";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.drive_file_rename_outline),
                            hintText: 'Örn. Mühendislik',
                            labelText: 'Fakülte Ad *',
                          ),
                          controller: _fakulteAdKontrol,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen fakülte adını giriniz";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.drive_file_rename_outline),
                            hintText: 'Örn. Bilgisayar Mühendisliği',
                            labelText: 'Bolum Ad *',
                          ),
                          controller: _bolumAdKontrol,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen bölüm adını giriniz";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.drive_file_rename_outline),
                            hintText: 'Örn. 4',
                            labelText: 'Sınıf *',
                          ),
                          controller: _sinifKontrol,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Lütfen sınıfınızı giriniz";
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Container(
                          alignment: Alignment.bottomRight,
                          child: RaisedButton.icon(
                            color: Colors.deepOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: () {
                              if (_updateFormKey.currentState.validate()) {
                                dynamic result = gonderiGuncelle(context);
                                setState(() {
                                  loading = true;
                                });
                                try {
                                  if (result != null) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OgrenciProfil(
                                            user: user,
                                            hesapGecisi: widget.hesapGecisi,
                                            isim: widget.isim),
                                      ),
                                    );
                                  } else {
                                    setState(() {
                                      error = 'Bilgilerini kontrol ediniz!';
                                      loading = false;
                                    });
                                  }
                                } catch (e) {
                                  print('Hata Oluştu!!: $e');
                                }
                              }
                            },
                            icon: Icon(Icons.update),
                            label: Text("GÜNCELLE"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
