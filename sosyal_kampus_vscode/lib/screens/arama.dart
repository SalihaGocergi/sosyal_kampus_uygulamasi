import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_kampus_vscode/isletmeciEkranlar/isletmeci_arama.dart';
import 'package:sosyal_kampus_vscode/ogrenciEkranlar/ogrenci_arama.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';

class Arama extends StatefulWidget {
  Arama(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  var hesapGecisi;
  var isim;
  var user;
  @override
  _AramaState createState() => _AramaState();
}

class _AramaState extends State<Arama> {
  bool loading = false;

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
                      ('assets/ekran1.jpg'),
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
                                    Icons.person_search_outlined,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    "Öğrenci Ara",
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OgrenciArama(
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
                                  Icons.person_search_outlined,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "İşletmeci Ara",
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => IsletmeciArama(
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
