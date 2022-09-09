import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_kampus_vscode/isletmeciEkranlar/isletmeci_arama.dart';
import 'package:sosyal_kampus_vscode/mesajlasma/chatrooms.dart';
import 'package:sosyal_kampus_vscode/ogrenciEkranlar/ogrenci_arama.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';

class Mesajlasma extends StatefulWidget {
  Mesajlasma(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  var hesapGecisi;
  var isim;
  var user;
  @override
  _MesajlasmaState createState() => _MesajlasmaState();
}

class _MesajlasmaState extends State<Mesajlasma> {
  bool loading = false;
  var mesajlasilanKullanici;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset(
                      ('assets/mesajlaşma.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Container(
                      height: 570,
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 170,
                            ),
                            Container(
                              child: RaisedButton.icon(
                                  icon: Icon(
                                    Icons.message_rounded,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Öğrenci ile Mesajlaşma",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Colors.deepOrange,
                                  disabledColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding:
                                      const EdgeInsets.fromLTRB(80, 20, 80, 20),
                                  elevation: 10.0,
                                  onPressed: () {
                                    mesajlasilanKullanici = 0;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatRoom(
                                           mesajlasilanKullanici: mesajlasilanKullanici,
                                            user: widget.user,
                                            hesapGecisi: widget.hesapGecisi,
                                            isim: widget.isim),
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            RaisedButton.icon(
                                icon: Icon(
                                  Icons.message_rounded,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "İşletmeci ile Mesajlaşma",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Colors.deepOrange,
                                disabledColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding:
                                    const EdgeInsets.fromLTRB(80, 20, 80, 20),
                                elevation: 10.0,
                                onPressed: () {
                                  mesajlasilanKullanici = 1;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatRoom(
                                        mesajlasilanKullanici: mesajlasilanKullanici,
                                          user: widget.user,
                                          hesapGecisi: widget.hesapGecisi,
                                          isim: widget.isim),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
