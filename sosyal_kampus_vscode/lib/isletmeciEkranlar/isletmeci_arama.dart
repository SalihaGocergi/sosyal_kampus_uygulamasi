import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sosyal_kampus_vscode/isletmeciEkranlar/isletmeci_profil.dart';
import 'package:sosyal_kampus_vscode/main.dart';

class IsletmeciArama extends StatefulWidget {
  IsletmeciArama(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  var hesapGecisi;
  var isim;
  var user;

  @override
  _IsletmeciAramaState createState() => _IsletmeciAramaState();
}

class _IsletmeciAramaState extends State<IsletmeciArama> {
  TextEditingController textEditingController = TextEditingController();
  String searchString;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          title: Text("İşletmeci Arama"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[Color(0xFFff5722), Color(0xFFc7b198)],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          searchString = val.toLowerCase();
                        });
                      },
                      controller: textEditingController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () => textEditingController.clear(),
                          ),
                          hintText: 'Arama yap!',
                          hintStyle: TextStyle(
                              fontFamily: 'Antra', color: Colors.blueGrey)),
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: (searchString == null || searchString.trim() == '')
                        ? FirebaseFirestore.instance
                            .collection('users')
                            .doc('9llKrCnWfmYhxhE4Xq5P0tedBLC2')
                            .collection('isletmeciler')
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection('users')
                            .doc('9llKrCnWfmYhxhE4Xq5P0tedBLC2')
                            .collection('isletmeciler')
                            .where('arananIndex', arrayContains: searchString)
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Bir hata oluştu ${snapshot.error}');
                      }
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return SizedBox(
                            child: Center(
                              child: Icon(Icons.loop_rounded),
                            ),
                          );
                        case ConnectionState.none:
                          return Text('Oops veri yok!');

                        case ConnectionState.done:
                          return Text('İşimiz bitti!');

                        default:
                          return new ListView(
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot document) {
                            return new ListTile(
                              leading: (document.data()['userImage'] == "")
                                  ? CircleAvatar(
                                      child: Image.asset(
                                        ('assets/profil.png'),
                                        fit: BoxFit.contain,
                                      ),
                                      backgroundColor: Colors.grey[350],
                                    )
                                  : CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          document.data()['userImage']),
                                    ),
                              title: Text(
                                "${document.data()['name']}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                              subtitle: Text(
                                "Tel: ${document.data()['tel']}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 14.0),
                              ),
                              onTap: () {
                                /*
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => IsletmeciProfil(
                                          user: document.id,
                                          hesapGecisi: widget.hesapGecisi,
                                          isim: widget.isim)),
                                );
                                */
                              },
                            );
                          }).toList());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
