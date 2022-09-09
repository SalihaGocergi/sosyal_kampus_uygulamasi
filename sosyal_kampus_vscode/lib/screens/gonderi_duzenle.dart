import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_kampus_vscode/isletmeciEkranlar/isletmeci_profil.dart';
import 'package:sosyal_kampus_vscode/models/post.dart';
import 'package:sosyal_kampus_vscode/ogrenciEkranlar/ogrenci_profil.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';
import 'package:sosyal_kampus_vscode/shared/appBar_widget.dart';
import 'package:sosyal_kampus_vscode/shared/constants.dart';

class GonderiDuzenle extends StatefulWidget {
  GonderiDuzenle(
      {Key key,
      @required this.user,
      @required this.post,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  final Post post;
  final user;
  var hesapGecisi;
  var isim;
  @override
  _GonderiDuzenleState createState() => _GonderiDuzenleState();
}

class _GonderiDuzenleState extends State<GonderiDuzenle> {
  final _editPostFormKey = GlobalKey<FormState>();

  bool loading = false;
  String error = '';
  final _aciklamaKontrol = TextEditingController();
  final _resimKontrol = TextEditingController();
  String indirmeBaglatisi;

  ImagePicker imagePicker;
  File resimFile;
  var url;

  @override
  void dispose() {
    _aciklamaKontrol.dispose();
    _resimKontrol.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _aciklamaKontrol.text = widget.post.aciklama;
    _resimKontrol.text = widget.post.resimUrl;
    indirmeBaglatisi = _resimKontrol.text;

    imagePicker = ImagePicker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    //TELEFON GALERİSİNDEN RESİM SEÇTİRME
    Future resmiGaleridenGetirVeStorageEkleme() async {
      // ignore: deprecated_member_use
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
        _resimKontrol.text = url;
      });
      print("resmiGaleridenGetirVeStorageEkleme urllllllll: $indirmeBaglatisi");
    }

    Future gonderiGuncelle(BuildContext context) async {
      // Firebase kimlik doğrulamasına göre kullanıcı girişi
      final user = Provider.of<User>(context, listen: false);

      if(widget.hesapGecisi == 0){
        dynamic result = await DatabaseService(uid: widget.user.uid).editPost(
        widget.post.id,
        _aciklamaKontrol.text,
        indirmeBaglatisi,
      );
      return result;
      }

      if(widget.hesapGecisi == 1){
        dynamic result = await DatabaseService2(uid: widget.user.uid).editPost(
        widget.post.id,
        _aciklamaKontrol.text,
        indirmeBaglatisi,
      );
      return result;
      }
      
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBarWidget(
          title: "Gönderi Düzenle",
        ),
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: SingleChildScrollView(
          child: Form(
            key: _editPostFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GÖNDERİ DÜZENLE",
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
                            resmiGaleridenGetirVeStorageEkleme();
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Açıklama Yaz",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    // maxLines: 3, //max. satır sayısı
                  ),
                ),
                TextFormField(
                  //TextField kullan
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
                      child: Text("Gönderiyi Güncelle"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (_editPostFormKey.currentState.validate()) {
                          dynamic result = gonderiGuncelle(context);
                          setState(() {
                            loading = true;
                          });
                          try {
                            if (result != null) {

                              if(widget.hesapGecisi == 0){
                                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OgrenciProfil(
                                      user: user,
                                      hesapGecisi: widget.hesapGecisi,
                                      isim: widget.isim),
                                ),
                              );
                              }

                              if(widget.hesapGecisi == 1){
                                  Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IsletmeciProfil(
                                      user: user,
                                      hesapGecisi: widget.hesapGecisi,
                                      isim: widget.isim),
                                ),
                              );
                              }
                              
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
