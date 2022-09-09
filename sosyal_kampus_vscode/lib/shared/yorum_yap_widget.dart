import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_kampus_vscode/isletmeciEkranlar/gonderi_ayrinti_isletmeci.dart';
import 'package:sosyal_kampus_vscode/models/post.dart';
import 'package:sosyal_kampus_vscode/models/user_ogrenciler.dart';
import 'package:sosyal_kampus_vscode/ogrenciEkranlar/gonderi_ayrinti_ogrenci.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';

class BottomSheetWidget extends StatefulWidget {
  BottomSheetWidget({
    Key key,
    @required this.post,
    @required this.user,
    @required this.hesapGecisi,
    @required this.isim,
  }) : super(key: key);
  final Post post;
  final user;
  var hesapGecisi;
  var isim;
  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
      height: 160,
      child: DecoratedWidget(
        post: widget.post,
        user: widget.user,
        hesapGecisi: widget.hesapGecisi,
        isim: widget.isim,
      ),
    );
  }
}

class DecoratedWidget extends StatefulWidget {
  DecoratedWidget({
    Key key,
    @required this.post,
    @required this.user,
    @required this.hesapGecisi,
    @required this.isim,
  }) : super(key: key);
  final Post post;
  final user;
  var hesapGecisi;
  var isim;
  _DecoratedWidgetState createState() => _DecoratedWidgetState();
}

class _DecoratedWidgetState extends State<DecoratedWidget> {
  final _registerFormKey = GlobalKey<FormState>();
  final _aciklamaKontrol = TextEditingController();

  bool checkingFlight = false;
  bool success = false;

  String error = '';
  bool loading = false;

  @override
  void dispose() {
    _aciklamaKontrol.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _dbOgrenci = DatabaseService();
    final _dbIsletmeci = DatabaseService2();
    final user = Provider.of<User>(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
          child: Form(
            key: _registerFormKey,
            child: TextFormField(
              decoration:
                  InputDecoration.collapsed(hintText: 'Açıklama giriniz'),
              controller: _aciklamaKontrol,
              cursorWidth: 3.0,
              validator: (value) {
                if (value.isEmpty) {
                  return "Lütfen açıklama giriniz";
                }
                return null;
              },
            ),
          ),
        ),
        !checkingFlight
            ? MaterialButton(
                color: Colors.grey[800],
                onPressed: () async {
                  setState(() {
                    checkingFlight = true;
                  });
                  await Future.delayed(Duration(seconds: 1));
                  setState(() {
                    success = true;
                  });
                  if (_registerFormKey.currentState.validate()) {
                    setState(() {
                      loading = true;
                    });
                    try {
                      if (widget.hesapGecisi == 0) {
                        dynamic result = await _dbOgrenci.yorumEkle(
                            user.uid,
                            widget.user.uid,
                            widget.post.id,
                            _aciklamaKontrol.text);
                        if (result != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GonderiAyrintiOgrenci(
                                post: widget.post,
                                user: widget.user,
                                hesapGecisi: widget.hesapGecisi,
                                isim: widget.isim,
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            error = 'Bilgilerini kontrol ediniz!';
                            loading = false;
                          });
                        }
                      }
                      if (widget.hesapGecisi == 1) {
                        dynamic result = await _dbIsletmeci.yorumEkle(
                            user.uid,
                            widget.user.uid,
                            widget.post.id,
                            _aciklamaKontrol.text);
                        if (result != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GonderiAyrintiIsletmeci(
                                post: widget.post,
                                user: widget.user,
                                hesapGecisi: widget.hesapGecisi,
                                isim: widget.isim,
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            error = 'Bilgilerini kontrol ediniz!';
                            loading = false;
                          });
                        }
                      }
                    } catch (e) {
                      print('Hata Oluştu!!: $e');
                    }
                  }

                  await Future.delayed(Duration(milliseconds: 500));
                  Navigator.pop(context);
                },
                child: Text(
                  'Gönder',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : !success
                ? CircularProgressIndicator()
                : Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
      ],
    );
  }
}
