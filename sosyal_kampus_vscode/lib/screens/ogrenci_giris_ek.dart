import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_kampus_vscode/screens/anasayfa.dart';
import 'package:sosyal_kampus_vscode/services/auth.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';


class OgrenciGirisiEk extends StatefulWidget {
  OgrenciGirisiEk(
      {Key key,
      @required this.hesapGecisi,
      @required this.isim,
      @required this.email,
      @required this.sifre,
      @required this.ad,
      @required this.soyad})
      : super(key: key);
  var hesapGecisi;

  var isim;
  var email, sifre, ad, soyad;

  @override
  _OgrenciGirisiEkState createState() => _OgrenciGirisiEkState();
}

class _OgrenciGirisiEkState extends State<OgrenciGirisiEk> {
  final _registerFormKey =
      GlobalKey<FormState>(); //form kullanmak için tanımlama yaptık

  bool loading = false;
  String error = '';

  //text'lerden aldığımız değerler için değişken tanımı
  final _universiteAdiKontrol = TextEditingController();
  final _fakulteAdiKontrol = TextEditingController();
  final _bolumAdiKontrol = TextEditingController();
  final _sinifKontrol = TextEditingController();

  final _auth = AuthService();

  @override
  void dispose() {
    _universiteAdiKontrol.dispose();
    _fakulteAdiKontrol.dispose();
    _bolumAdiKontrol.dispose();
    _sinifKontrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(45.0), child: AppBar()),
            resizeToAvoidBottomInset: false,
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _registerFormKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      elevation: 20,
                      //color: Colors.blue.shade300,
                      child: Container(
                        height: 570,
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ), //butonların konumlarını değiştirdi

                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.deepOrange,
                                ),
                                hintText: "Örn. Necmettin Erbakan",
                                labelText: "Üniversite Ad",
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepOrange, width: 2)),
                                //üstünde değilken olan renk
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepOrange.shade900,
                                        width:
                                            2)), //üstüne geldiğinde olan renk
                              ),
                              controller: _universiteAdiKontrol,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Lütfen üniversite adını giriniz";
                                }
                                return null;
                              },
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.deepOrange,
                                ),
                                hintText: "Örn. Mühendislik",
                                labelText: "Fakülte Ad",
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepOrange, width: 2)),
                                //üstünde değilken olan renk
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepOrange.shade900,
                                        width:
                                            2)), //üstüne geldiğinde olan renk
                              ),
                              controller: _fakulteAdiKontrol,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Lütfen fakulte adını giriniz";
                                }
                                return null;
                              },
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.deepOrange,
                                ),
                                hintText: "Örn. Bilgisayar Mühendisliği",
                                labelText: "Bölüm Ad",
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepOrange, width: 2)),
                                //üstünde değilken olan renk
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepOrange.shade900,
                                        width:
                                            2)), //üstüne geldiğinde olan renk
                              ),
                              controller: _bolumAdiKontrol,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Lütfen bolum adini giriniz";
                                }
                                return null;
                              },
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.deepOrange,
                                ),
                                hintText: "Örn. 4",
                                labelText: "Sınıf",
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepOrange, width: 2)),
                                //üstünde değilken olan renk
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.deepOrange.shade900,
                                        width:
                                            2)), //üstüne geldiğinde olan renk
                              ),
                              controller: _sinifKontrol,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Lütfen sınıfınızı giriniz";
                                }
                                return null;
                              },
                            ),

                            SizedBox(
                              height: 30,
                            ),
                            RaisedButton.icon(
                              label: Text("ÜYELİĞİ TAMAMLA"),
                              icon: Icon(Icons.arrow_forward_ios),
                              color: Colors.deepOrange,
                              disabledColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding:
                                  const EdgeInsets.fromLTRB(80, 20, 80, 20),
                              elevation: 10.0,
                              //gölgelendirme
                              onPressed: () async {
                                if (_registerFormKey.currentState.validate()) {
                                  //eğer yukarıdan gelen değerlerin hepsi kabul edilmiş ise işlemler yapılsın
                                  setState(() {
                                    loading = true;
                                  });
                                  try {
                                    // Kullanıcıyı firebase kimlik doğrulamasına göre kaydet
                                    User user = await _auth
                                        .registerWithEmailAndPassword(
                                      widget.email,
                                      widget.sifre,
                                      widget.ad,
                                      widget.soyad,
                                      _universiteAdiKontrol.text,
                                      _fakulteAdiKontrol.text,
                                      _bolumAdiKontrol.text,
                                      _sinifKontrol.text,
                                    );
                                    if (user != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Anasayfa(
                                              user: user,
                                              hesapGecisi: widget.hesapGecisi,
                                              isim: widget.isim,),
                                        ),
                                      );
                                    } else {
                                      setState(() {
                                        error = 'Bilgilerinizi kontrol ediniz!';
                                        loading = false;
                                      });
                                    }
                                  } catch (e) {
                                    print('Hata Oluştu!!: $e');
                                  }
                                }
                              },
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
                ),
              ),
            ),
          );
  }

  Future<DateTime> tarihSec(BuildContext context) {
    return showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now(),
      lastDate: DateTime(2023),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
  }
}
