import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_kampus_vscode/screens/anasayfa.dart';
import 'package:sosyal_kampus_vscode/services/auth.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';


class IsletmeciGiris extends StatefulWidget {
  IsletmeciGiris({Key key, @required this.hesapGecisi, @required this.isim})
      : super(key: key);
  var hesapGecisi;
  var isim;
  @override
  _IsletmeciGirisState createState() => _IsletmeciGirisState();
}

class _IsletmeciGirisState extends State<IsletmeciGiris> {
  final _registerFormKey =
      GlobalKey<FormState>(); //form kullanmak için tanımlama yaptık

  bool loading = false;
  String error = '';

  //text'lerden aldığımız değerler için değişken tanımı
  final _mekanAdiKontrol = TextEditingController();
  final _mekanAdresKontrol = TextEditingController();
  final _mekantelKontrol = TextEditingController();
  final _emailKontrol = TextEditingController();
  final _sifreKontrol = TextEditingController();
  final _sifreOnayKontrol = TextEditingController();

  final _auth = AuthService2();

  @override
  void dispose() {
    _mekanAdiKontrol.dispose();
    _mekanAdresKontrol.dispose();
    _mekantelKontrol.dispose();
    _emailKontrol.dispose();
    _sifreKontrol.dispose();
    _sifreOnayKontrol.dispose();
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
                //ekran boyutlarına göre içerik hareket etmesini sağlar
                child: Form(
                  key: _registerFormKey,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      elevation: 4,
                      //color: Colors.blue.shade300,
                      child: Container(
                        height: 570,
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ), //butonların konumlarını değiştirdi
                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                              child: TextFormField(
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
                                          color: Colors.deepOrange, width: 2)),
                                  //üstünde değilken olan renk
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepOrange.shade900,
                                          width:
                                              2)), //üstüne geldiğinde olan renk
                                ),
                                controller: _emailKontrol,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Lütfen email giriniz";
                                  } else if (!EmailValidator.validate(value)) {
                                    return "Lütfen geçerli bir email giriniz";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                              child: TextFormField(
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
                                          color: Colors.deepOrange, width: 2)),
                                  //üstünde değilken olan renk
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.deepOrange.shade900,
                                          width:
                                              2)), //üstüne geldiğinde olan renk
                                ),
                                obscureText: true,
                                controller: _sifreKontrol,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Lütfen şifre giriniz";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.drive_file_rename_outline,
                                    color: Colors.deepOrange,
                                  ),
                                  hintText: "Mekan adını giriniz",
                                  labelText: "Mekan Adı",
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
                                controller: _mekanAdiKontrol,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Lütfen mekan adını giriniz";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.drive_file_rename_outline,
                                    color: Colors.deepOrange,
                                  ),
                                  hintText: "Mekan adresini giriniz",
                                  labelText: "Mekan Adres",
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
                                controller: _mekanAdresKontrol,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Lütfen mekan adresini giriniz";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Colors.deepOrange,
                                  ),
                                  hintText: "Mekan telefon numarası giriniz",
                                  labelText: "Telefon Numarası",
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
                                controller: _mekantelKontrol,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "Lütfen mekan telefon numaranızı giriniz";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
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
                                      _emailKontrol.text,
                                      _sifreKontrol.text,
                                      _mekanAdiKontrol.text,
                                      _mekanAdresKontrol.text,
                                      _mekantelKontrol.text,
                                    );
                                    if (user != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Anasayfa(
                                              user: user,
                                              hesapGecisi: widget.hesapGecisi,
                                              isim: widget.isim),
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
}
