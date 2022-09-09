import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'login.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final formKey = GlobalKey<FormState>();
  var hesapGecisi;
  var isim;
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: <Color>[Color(0xFFff5722), Color(0xFFc7b198)]),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    elevation: 20,
                    //color: Colors.blue.shade300,
                    child: Container(
                      height: 500,
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          Container(
                            height: 170,
                            width: 170,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: AssetImage('assets/logo10.PNG'),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ), //butonların konumlarını değiştirdi
                          Text(
                            'GİRİŞ YAPMAK İSTEDİĞİNİZ',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          Text(
                            'ALANI SEÇİNİZ!',
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          RaisedButton.icon(
                            icon: Icon(Icons.account_circle),
                            label: Text("ÖĞRENCİ GİRİŞİ"),
                            color: Colors.deepOrange,
                            disabledColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding:
                                const EdgeInsets.fromLTRB(105, 20, 105, 20),
                            elevation: 10.0, //gölgelendirme
                            onPressed: () {
                              setState(() {
                                hesapGecisi = 0;
                                isim = "Öğrenci";
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LogIn(
                                        hesapGecisi: hesapGecisi, isim: isim)),
                              );
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton.icon(
                            icon: Icon(Icons.account_circle),
                            label: Text("İŞLETME HESABI GİRİŞİ"),
                            color: Colors.deepOrange,
                            disabledColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: const EdgeInsets.fromLTRB(80, 20, 80, 20),
                            elevation: 10.0, //gölgelendirme
                            onPressed: () {
                              setState(() {
                                hesapGecisi = 1;
                                isim = "İşletmeci";
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LogIn(
                                        hesapGecisi: hesapGecisi, isim: isim)),
                              );
                            },
                          ),
                        ],
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
}
