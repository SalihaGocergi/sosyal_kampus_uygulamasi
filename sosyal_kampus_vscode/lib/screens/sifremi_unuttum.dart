import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_kampus_vscode/screens/login.dart';
import 'package:sosyal_kampus_vscode/services/auth.dart';
import 'package:sosyal_kampus_vscode/services/sifremi_unuttum_veritabani.dart';
import 'package:sosyal_kampus_vscode/shared/appBar_widget.dart';

class SifremiUnuttum extends StatefulWidget {
  SifremiUnuttum({Key key, @required this.hesapGecisi, @required this.isim})
      : super(key: key);
  var hesapGecisi;
  var isim;

  @override
  _SifremiUnuttumState createState() => _SifremiUnuttumState();
}

class _SifremiUnuttumState extends State<SifremiUnuttum> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailKontrol = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  var controller = TextEditingController();

  final _auth = AuthService();
  bool loading = false;
  String error = '';

  @override
  void dispose() {
    _emailKontrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
            child: SingleChildScrollView(
              child: Form(
                key: _loginFormKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 40, 16, 40),
                  child: Material(
                    borderRadius: BorderRadius.circular(16),
                    elevation: 4,
                    //color: Colors.blue.shade300,
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                                      "Şifremi Unuttum!",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                          SizedBox(
                            height: 50,
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
                                  borderSide:
                                      BorderSide(color: Colors.deepOrange, width: 2)),
                              //üstünde değilken olan renk
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.deepOrange.shade900,
                                      width: 2)), //üstüne geldiğinde olan renk
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
                            height: 20,
                          ),

                          RaisedButton.icon(
                            icon: Icon(Icons.account_circle),
                            label: Text("İsteği gönder"),
                            color: Colors.deepOrange,
                            disabledColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.fromLTRB(105, 20, 105, 20),
                            elevation: 10.0,
                            //gölgelendirme
                            onPressed: () async {
                              await SignInHelper.instance()
                                  .sifremiUnuttum(_emailKontrol.text);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LogIn(
                                      hesapGecisi: widget.hesapGecisi,
                                      isim: widget.isim),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
