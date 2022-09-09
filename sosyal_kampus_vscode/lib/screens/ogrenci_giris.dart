import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_kampus_vscode/screens/ogrenci_giris_ek.dart';
import 'package:sosyal_kampus_vscode/services/auth.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';


class OgrenciGirisi extends StatefulWidget {
  OgrenciGirisi(
      {Key key,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  var hesapGecisi;
  var isim;
  @override
  _OgrenciGirisiState createState() => _OgrenciGirisiState();
}

enum SingingCharacter { kadin, erkek }

class _OgrenciGirisiState extends State<OgrenciGirisi> {
  DateTime secilenTarih = DateTime.now();
  String cinsiyet = "";
  SingingCharacter _karakter = SingingCharacter.kadin;

  final _registerFormKey =
      GlobalKey<FormState>(); //form kullanmak için tanımlama yaptık

  bool loading = false;
  String error = '';

  //text'lerden aldığımız değerler için değişken tanımı
  final _isimKontrol = TextEditingController();
  final _soyadKontrol = TextEditingController();
  final _emailKontrol = TextEditingController();
  final _sifreKontrol = TextEditingController();
  final _sifreOnayKontrol = TextEditingController();

  final _auth = AuthService();

  @override
  void dispose() {
    _isimKontrol.dispose();
    _soyadKontrol.dispose();
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

                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
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

                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: Colors.deepOrange,
                                ),
                                hintText: "Adınızı giriniz",
                                labelText: "Ad",
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
                              controller: _isimKontrol,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Lütfen isim giriniz";
                                }
                                return null;
                              },
                              //onChanged: (String urunId) {
                              //urunIdAl(urunId);
                              //},
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
                                hintText: "Soyadınızı giriniz",
                                labelText: "Soyad",
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
                              controller: _soyadKontrol,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Lütfen soyadınızı giriniz";
                                }
                                return null;
                              },
                              //onChanged: (String urunId) {
                              //urunIdAl(urunId);
                              //},
                            ),

                            /*
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 5, 2),
                      child: Row(
                        children: [
                          FlatButton(child: Text("Tarihi seç"),onPressed: () async{
                            secilenTarih =  await tarihSec(context);

                            if(secilenTarih != null){
                              setState(() {
                                //Durumu güncelleyelim ki seçilen tarihler gözüksün
                              });
                            }
                          } ,),
                          Text("Tarih : $secilenTarih"),
                        ],
                      ),
                    ),


                    Row(

                        children: [
                          ListTile(
                            title: const Text('Kadın'),
                            leading: Radio(
                              value: SingingCharacter.kadin,
                              groupValue: _karakter,
                              onChanged: (SingingCharacter value) {
                                setState(() {
                                  _karakter = value;
                                });
                              },
                            ),
                          ),
                          ListTile(
                            title: const Text('Erkek'),
                            leading: Radio(
                              value: SingingCharacter.erkek,
                              groupValue: _karakter,
                              onChanged: (SingingCharacter value) {
                                setState(() {
                                  _karakter = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
*/
                            SizedBox(
                              height: 30,
                            ),
                            RaisedButton.icon(
                              label: Text("BİLGİLERİ TAMAMLA"),
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OgrenciGirisiEk(
                                          hesapGecisi: widget.hesapGecisi,
                                          isim: widget.isim,
                                          email: _emailKontrol.text,
                                          sifre: _sifreKontrol.text,
                                          ad: _isimKontrol.text,
                                          soyad: _soyadKontrol.text),
                                    ),
                                  );
                                  /*
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Home(hesapGecisi: widget.hesapGecisi, isim: widget.isim),
                                          ),
                                        );
                                         */
                                } else {
                                  setState(() {
                                    error = 'Bilgilerinizi kontrol ediniz!';
                                    loading = false;
                                  });
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
