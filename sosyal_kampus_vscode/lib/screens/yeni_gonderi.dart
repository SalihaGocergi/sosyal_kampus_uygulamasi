import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_kampus_vscode/models/user.dart';
import 'package:sosyal_kampus_vscode/screens/anasayfa.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';
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
  final _db = DatabaseService();

  final _aciklamaKontrol = TextEditingController();
  final _resimKontrol = TextEditingController();
  PickedFile _resim;
  Users user;
  var postAded;
  ImagePicker imagePicker;

  @override
  void dispose() {
    _aciklamaKontrol.dispose();
    _resimKontrol.dispose();

    super.dispose();
  }

  @override
  void initState() {
    Future getUser() async {
      var currentUser = await DatabaseService().getProfile(widget.user.uid);
      setState(() {
        user = currentUser;
        _aciklamaKontrol.text = currentUser.name;
        _resimKontrol.text = currentUser.userImage ?? '';
        postAded = user.postAded;
      });
    }

    getUser();
    imagePicker = ImagePicker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_element
    Future getUser() async {
      var currentUser = await DatabaseService().getProfile(widget.user.uid);
      setState(() {
        user = currentUser;
      });
    }

    //TELEFON GALERİSİNDEN RESİM SEÇTİRME
    Future getImage() async {
      // ignore: deprecated_member_use
      var resim = await imagePicker.getImage(
        source: ImageSource.gallery,
      );
      setState(() {
        _resim = resim;
      });
    }

    //RESMİ FİREBASE EKLEME İŞLEMİ YAPACAĞIZ
    Future resimEkleme(BuildContext context) async {
      String fileName = basename(_resim.path);
      var firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);

      //.getParent()

      //RESMİ YÜKLEME
      UploadTask uploadTask = firebaseStorageRef.putFile(File(_resim.path));
      var url = await (await uploadTask
          .whenComplete(() => firebaseStorageRef.getDownloadURL()));
      // Firebase kimlik doğrulamasına göre kullanıcı girişi
      final user = Provider.of<User>(context, listen: false);

      dynamic result = await _db.createPost(
        user.uid,
        _aciklamaKontrol.text,
        url.toString(), //.trim()   _resim.resolveSymbolicLinksSync()
      );
      _resimKontrol.text =
          url.toString(); //_resimKontrol.text = url.toString();
      print('resim yüklendi');
      print("resimm yoluuuuu iç : " + _resimKontrol.text);

      /*
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Resim yüklendi')));
          */
      return result;
    }

    print("userrr postAded: $postAded");
    print("userrr: ${user.postAded}");
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(45.0),
          child: AppBar(),
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
                      Container(
                        height: 230,
                        width: 450,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade600)),
                        child: new SizedBox(
                          //width: 800,
                          //height: 300,
                          child: Center(
                            child: (_resim != null)
                                ? Image.file(
                                    File(_resim.path),
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
        ));
  }
}
