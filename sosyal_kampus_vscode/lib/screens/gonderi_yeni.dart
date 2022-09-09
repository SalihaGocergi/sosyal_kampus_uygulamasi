import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_kampus_vscode/models/user_isletmeci.dart';
import 'package:sosyal_kampus_vscode/models/user_ogrenciler.dart';
import 'package:sosyal_kampus_vscode/screens/anasayfa.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';
import 'package:sosyal_kampus_vscode/shared/appBar_widget.dart';
import 'package:sosyal_kampus_vscode/shared/constants.dart';

class YeniGonderi extends StatefulWidget {
  YeniGonderi(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  var hesapGecisi;
  var isim;
  final user;

  @override
  _YeniGonderiState createState() => _YeniGonderiState();
}

class _YeniGonderiState extends State<YeniGonderi> {
  final _newPostFormKey = GlobalKey<FormState>();

  bool loading = false;
  String error = '';
  final _dbOgrenci = DatabaseService();
  final _dbIsletmeci = DatabaseService2();

  final _aciklamaKontrol = TextEditingController();
  final _resimKontrol = TextEditingController();
  File resimFile;
  Users userOgrenci;
  UsersIsletmeci userIsletmeci;
  //var postAded;
  ImagePicker imagePicker;

  @override
  void initState() {
    /*
    if(widget.hesapGecisi == 0){
     
        Future getUserOgrenci() async {
        var currentUser = await DatabaseService().getProfile(widget.user.uid);
        setState(() {
          userOgrenci = currentUser;
          _aciklamaKontrol.text = currentUser.name;
          _resimKontrol.text = currentUser.userImage ?? '';
        });
      }

        getUserOgrenci();
        
    }
    if(widget.hesapGecisi == 1){
      Future getUserIsletmeci() async {
        var currentUser = await DatabaseService2().getProfile(widget.user.uid);
        setState(() {
          userIsletmeci = currentUser;
          _aciklamaKontrol.text = currentUser.name;
          _resimKontrol.text = currentUser.userImage ?? '';
        });
      }

        getUserIsletmeci();
    }
    */
    imagePicker = ImagePicker();
    super.initState();
  }

  @override
  void dispose() {
    _aciklamaKontrol.dispose();
    _resimKontrol.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //RESMİ FİREBASE EKLEME İŞLEMİ YAPACAĞIZ
    Future resimEkleme(BuildContext context) async {
      String fileName = basename(resimFile.path);
      var firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      
      //RESMİ YÜKLEME
      UploadTask uploadTask = firebaseStorageRef.putFile(File(resimFile.path));
      var url = await (await uploadTask).ref.getDownloadURL();
      // Firebase kimlik doğrulamasına göre kullanıcı girişi
      final user = Provider.of<User>(context, listen: false);
      if (widget.hesapGecisi == 0) {
        dynamic result = await _dbOgrenci.gonderiEkle(
          user.uid,
          _aciklamaKontrol.text,
          url.toString(), //.trim()   _resim.resolveSymbolicLinksSync()
        );

        return result;
      }
      if (widget.hesapGecisi == 1) {
        dynamic result = await _dbIsletmeci.gonderiEkle(
          user.uid,
          _aciklamaKontrol.text,
          url.toString(), //.trim()   _resim.resolveSymbolicLinksSync()
        );
        return result;
      }
      _resimKontrol.text =url.toString(); //_resimKontrol.text = url.toString();
      print('resim yüklendi');
      print("resimm yoluuuuu iç : " + _resimKontrol.text);
    }

    // ignore: unused_element
    Future getUser() async {
      var currentUser = await DatabaseService().getProfile(widget.user.uid);
      setState(() {
        userOgrenci = currentUser;
      });
    }

    //TELEFON GALERİSİNDEN RESİM SEÇTİRME
    Future getImage() async {
      // ignore: deprecated_member_use
      final resim = await imagePicker.getImage(
        source: ImageSource.gallery,
      );
      setState(() {
        resimFile = File(resim.path);
      });
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBarWidget(
          title: "Yeni Gönderi",
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: SingleChildScrollView(
          child: Form(
            key: _newPostFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GÖNDERİ EKLE",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(
                  children: [
                    ClipRect(
                      child: Container(
                        height: 230,
                        width: 450,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade600)),
                        child: Center(
                          child: (resimFile != null)
                              ? Image.file(
                                  File(resimFile.path),
                                  fit: BoxFit.fill,
                                )
                              : (_resimKontrol.text != '')
                                  ? Image.network(
                                      _resimKontrol.text,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.network(
                                      'https://image.flaticon.com/icons/png/128/3342/3342137.png',
                                      fit: BoxFit.fill,
                                    ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 180,
                      left: 320,
                      child: IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            size: 50.0,
                            color: Colors.deepOrange.shade500,
                          ),
                          onPressed: () {
                            getImage();
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  //TextField kullan
                  "Açıklama Yaz",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    // maxLines: 3, //max. satır sayısı
                  ),
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Açıklama giriniz'),
                  controller: _aciklamaKontrol,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Lütfen açıklama giriniz";
                    }
                    return null;
                  },
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text("Gönderiyi kaydet"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () async {
                        dynamic result = resimEkleme(context);
                        if (_newPostFormKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          try {
                            if (result != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Anasayfa(
                                      user: widget.user,
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
                      }),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14.0,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
