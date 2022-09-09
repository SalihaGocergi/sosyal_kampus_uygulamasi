import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_kampus_vscode/helper/helper_functions.dart';
import 'package:sosyal_kampus_vscode/screens/ilk_sayfa.dart';
import 'package:sosyal_kampus_vscode/ogrenciEkranlar/ogrenci_hesap_olustur.dart';
import 'package:sosyal_kampus_vscode/screens/sifremi_unuttum.dart';
import 'package:sosyal_kampus_vscode/services/auth.dart';
import 'package:sosyal_kampus_vscode/services/database_mesajlasma.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';

import 'anasayfa.dart';
import '../isletmeciEkranlar/isletmeci_hesap_olustur.dart';

class LogIn extends StatefulWidget {
  LogIn(
      {Key key,
      @required this.hesapGecisi,
      @required this.isim,
      @required this.email})
      : super(key: key);
  var hesapGecisi;
  var isim;
  var email;

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _loginFormKey = GlobalKey<FormState>();

  bool loading = false;
  String error = '';
  final _emailKontrol = TextEditingController();
  final _sifreKontrol = TextEditingController();

  final _auth = AuthService();
  final _auth2 = AuthService2();
  @override
  void dispose() {
    _emailKontrol.dispose();
    _sifreKontrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : new WillPopScope(
            onWillPop: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FirstPage(),
              ),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: <Color>[
                              Color(0xFFff5722),
                              Color(0xFFc7b198)
                            ]),
                      ),
                    ),
                    Center(
                      child: Form(
                        key: _loginFormKey,
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
                                  Text(
                                    "${widget.isim} Hesap İşlemleri",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ), //butonların konumlarını değiştirdi
                                  TextFormField(
                                    //keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.deepOrange,
                                      ),
                                      hintText: "@example.com",
                                      labelText: "Email",
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepOrange,
                                              width: 2)),
                                      //üstünde değilken olan renk
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepOrange.shade900,
                                              width:
                                                  2)), //üstüne geldiğinde olan renk
                                    ),

                                    controller: widget.email ?? _emailKontrol,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Lütfen email giriniz";
                                      } else if (!EmailValidator.validate(
                                          value)) {
                                        return "Lütfen geçerli bir email giriniz";
                                      }
                                      return null;
                                    },
                                    //onSaved: (deger) => _emailAdres = deger,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextFormField(
                                    //keyboardType: TextInputType.text,
                                    //yazı görünürlüğü kapalı
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.deepOrange,
                                      ),
                                      hintText: "*******",
                                      labelText: "Şifre",
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepOrange,
                                              width: 2)),
                                      //üstünde değilken olan renk
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.deepOrange.shade900,
                                              width:
                                                  2)), //üstüne geldiğinde olan renk
                                    ),
                                    controller: _sifreKontrol,
                                    validator: (value) {
                                      if (value.length < 6) {
                                        return "En az 6 karakter girilmeli";
                                      } else
                                        return null;
                                    },
                                  ),
                                  sifremiUnuttumButon(context),
                                  SizedBox(
                                    height: 30,
                                  ),

                                  RaisedButton.icon(
                                    icon: Icon(Icons.account_circle),
                                    label: Text("GİRİŞ YAP"),
                                    color: Colors.deepOrange,
                                    disabledColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.fromLTRB(
                                        105, 20, 105, 20),
                                    elevation: 10.0,
                                    //gölgelendirme
                                    onPressed: () async {
                                      if (widget.hesapGecisi == 0) {
                                        if (_loginFormKey.currentState
                                            .validate()) {
                                          //alınan textlerden değerler doğru ise işleme giriş yapacaktır.
                                          setState(() {
                                            loading = true;
                                          });
                                          try {
                                            // Firebase kimlik doğrulamasına göre kullanıcı giriş yapın
                                            await _auth //User user =
                                                .logInWithEmailAndPassword(
                                                    _emailKontrol.text,
                                                    _sifreKontrol.text)
                                                .then((result) async {
                                              if (result != null) {
                                                QuerySnapshot userInfoSnapshot =
                                                    await DatabaseMethods()
                                                        .getUserInfo(
                                                            _emailKontrol.text);

                                                HelperFunctions
                                                    .saveUserLoggedInSharedPreference(
                                                        true);
                                                HelperFunctions
                                                    .saveUserNameSharedPreference(
                                                        userInfoSnapshot.docs[0]
                                                            .data()["ad"]);
                                                HelperFunctions
                                                    .saveUserEmailSharedPreference(
                                                        userInfoSnapshot.docs[0]
                                                            .data()["email"]);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Anasayfa(
                                                            user: result,
                                                            hesapGecisi: widget
                                                                .hesapGecisi,
                                                            isim: widget.isim),
                                                  ),
                                                );
                                              } else {
                                                setState(() {
                                                  error =
                                                      'Bilgilerini kontrol ediniz!';
                                                  loading = false;
                                                });
                                              }
                                            });
                                          } catch (e) {
                                            print('Hata Oluştu!!: $e');
                                          }
                                        }
                                      }
                                      if (widget.hesapGecisi == 1) {
                                        if (_loginFormKey.currentState
                                            .validate()) {
                                          //alınan textlerden değerler doğru ise işleme giriş yapacaktır.
                                          setState(() {
                                            loading = true;
                                          });
                                          try {
                                            // Firebase kimlik doğrulamasına göre kullanıcı giriş yapın
                                            await _auth2
                                                .logInWithEmailAndPassword(
                                                    _emailKontrol.text,
                                                    _sifreKontrol.text)
                                                .then((result) async {
                                              if (result != null) {
                                                QuerySnapshot userInfoSnapshot =
                                                    await DatabaseMethods()
                                                        .getUserInfoIsletmeci(
                                                            _emailKontrol.text);
                                                HelperFunctions
                                                    .saveUserLoggedInSharedPreference(
                                                        true);
                                                HelperFunctions
                                                    .saveUserNameSharedPreference(
                                                        userInfoSnapshot.docs[0]
                                                            .data()["name"]);
                                                HelperFunctions
                                                    .saveUserEmailSharedPreference(
                                                        userInfoSnapshot.docs[0]
                                                            .data()["email"]);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Anasayfa(
                                                            user: result,
                                                            hesapGecisi: widget
                                                                .hesapGecisi,
                                                            isim: widget.isim),
                                                  ),
                                                );
                                              } else {
                                                setState(() {
                                                  error =
                                                      'Bilgilerini kontrol ediniz!';
                                                  loading = false;
                                                });
                                              }
                                            });
                                          } catch (e) {
                                            print('Hata Oluştu!!: $e');
                                          }
                                        }
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),

                                  Text(error,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 14.0,
                                      )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'VEYA',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  RaisedButton.icon(
                                    icon: Icon(Icons.account_circle),
                                    label: Text("HESAP OLUŞTUR"),
                                    color: Colors.deepOrange,
                                    disabledColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.fromLTRB(
                                        80, 20, 80, 20),
                                    elevation: 10.0,
                                    //gölgelendirme

                                    onPressed: () {
                                      if (widget.hesapGecisi == 0) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OgrenciHesapOlustur(
                                                      hesapGecisi:
                                                          widget.hesapGecisi,
                                                      isim: widget.isim)),
                                        );
                                      }
                                      if (widget.hesapGecisi == 1) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IsletmeciHesapOlustur(
                                                      hesapGecisi:
                                                          widget.hesapGecisi,
                                                      isim: widget.isim)),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),

                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: FlatButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FirstPage(),
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.menu_open),
                                        label: Text(
                                          "Menü",
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                          textAlign:
                                              TextAlign.left, //bi işe yaramadı
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  FlatButton sifremiUnuttumButon(BuildContext context) {
    return FlatButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SifremiUnuttum(
                  hesapGecisi: widget.hesapGecisi, isim: widget.isim),
            ),
          );
        },
        icon: Icon(Icons.help_outline),
        label: Text(
          "Şifremi Unuttum",
          style: TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.left, //bi işe yaramadı
        ));
  }
}
