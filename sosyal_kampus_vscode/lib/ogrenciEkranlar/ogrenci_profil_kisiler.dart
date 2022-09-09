import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sosyal_kampus_vscode/models/takipler.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';
import 'package:sosyal_kampus_vscode/shared/kullanici_bilgileri.dart';

class OgrenciProfilKisiler extends StatefulWidget {
  OgrenciProfilKisiler(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  final user;
  var hesapGecisi;
  var isim;
  @override
  _OgrenciProfilKisilerState createState() => _OgrenciProfilKisilerState();
}

class _OgrenciProfilKisilerState extends State<OgrenciProfilKisiler> {
  bool loading = false;
  String error = '';
  File resimFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: StreamBuilder<List<Takipler>>(
                stream:
                    DatabaseService(uid: widget.user.uid).bireyselKullaniciTakipler,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Takipler> takip = snapshot.data;
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: takip.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder<dynamic>(
                              future:
                                  ogrenciKullaniciBilgi(takip[index].takipEdilenId),
                              builder: (context, snapshot2) {
                                if (snapshot2.hasData) {
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(12.0, 5.0, 12.0, 0),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border:
                                                  Border.all(color: Colors.black12)),
                                          child: ListTile(
                                            leading: ClipOval(
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: (resimFile != null)
                                                    ? Image.file(
                                                        File(resimFile.path),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : ("${snapshot2.data['kullaniciResim']}" !=
                                                            "")
                                                        ? Image.network(
                                                            "${snapshot2.data['kullaniciResim']}",
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image.asset(
                                                            ('assets/profil.png'),
                                                            fit: BoxFit.cover,
                                                          ),
                                              ),
                                            ),
                                            title: Text(
                                              "${snapshot2.data['ad']} " +
                                                  "${snapshot2.data['soyad']}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Text(
                                                "${snapshot2.data['universite_ad']} "+ "Üniversitesi",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black54),
                                              ),
                                              trailing: PopupMenuButton(
                                                  //POSTUN YANINDA SAĞ TARAFTA DÜZENLE SİL MENÜSÜ
                                                  onSelected: (result) async {
                                                    final type = result['type'];
                                                    final takip = result['value'];
                                                    switch (type) {
                                                      case 'delete':
                                                        DatabaseService(
                                                                uid:widget.user.uid)
                                                            .takiptenCikar(takip.id);
                                                        break;
                                                    }
                                                  },
                                                  itemBuilder:
                                                      (BuildContext context) =>
                                                          <PopupMenuEntry>[
                                                    PopupMenuItem(value: {
                                                      'type': 'delete',
                                                      'value': takip[index]
                                                    }, child: Text('Takipten Çıkar')),
                                                  ],
                                                ),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                } else {
                                  return Loading();
                                }
                              });
                        });
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
