import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sosyal_kampus_vscode/shared/appBar_widget.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';
import 'package:sosyal_kampus_vscode/shared/kullanici_bilgileri.dart';

class IsletmeciKisiselBilgiler extends StatefulWidget {
  IsletmeciKisiselBilgiler({Key key, @required this.user}) : super(key: key);
  final user;
  _IsletmeciKisiselBilgilerState createState() =>
      _IsletmeciKisiselBilgilerState();
}

class _IsletmeciKisiselBilgilerState extends State<IsletmeciKisiselBilgiler> {
  bool loading = false;
  String error = '';
  File resimFile;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(45.0),
              child: AppBarWidget(
                title: "Kişisel Bilgiler",
              ),
            ),
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Image.asset(
                            ('assets/arkaplan.jpeg'),
                            fit: BoxFit.cover,
                          ),
                  ),
                  SingleChildScrollView(
                    child: FutureBuilder<dynamic>(
                      future: isletmeciKullaniciBilgi(widget.user.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: 35,
                              ),
                              Center(
                                child: ClipOval(
                                  child: Container(
                                    height: 150, //fit: BoxFit.cover
                                    width: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(38),
                                    ),
                                    child: (resimFile != null)
                                        ? Image.file(
                                            File(resimFile.path),
                                            fit: BoxFit.cover,
                                          )
                                        : ("${snapshot.data['userImage']}" !=
                                                "")
                                            ? Image.network(
                                                "${snapshot.data['userImage']}",
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                ('assets/profil.png'),
                                                fit: BoxFit.cover,
                                              ),
                                  ),
                                ),
                              ),
                              Divider(
                                height: 50,
                                thickness: 2, //genişlik
                                color: Colors.deepOrange,
                                indent: 90, //soldan boşluk
                                endIndent: 90, //sağdan boşluk
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "İşletme Bilgiler",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "İşletme Adı:",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "     ${snapshot.data['name']}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "İşletme Tel:",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "     ${snapshot.data['tel']}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "İşletme Adres:",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "     ${snapshot.data['address']}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                    ),
                                    Divider(
                                      height: 50,
                                      thickness: 2, //genişlik
                                      color: Colors.deepOrange,
                                      indent: 10, //soldan boşluk
                                      endIndent: 10, //sağdan boşluk
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Loading();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
