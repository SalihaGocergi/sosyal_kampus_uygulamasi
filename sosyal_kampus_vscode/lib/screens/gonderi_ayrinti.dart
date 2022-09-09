import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:sosyal_kampus_vscode/models/post.dart';
import 'package:sosyal_kampus_vscode/models/user.dart';
import 'package:sosyal_kampus_vscode/models/yorumlar.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';

class ShowPosts extends StatefulWidget {
  ShowPosts({
    Key key,
    @required this.post,
    @required this.user,
  }) : super(key: key);
  final Post post;
  final Users user;

  @override
  _ShowPostsState createState() => _ShowPostsState();
}

class _ShowPostsState extends State<ShowPosts> {
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    //print("Giriş yapan kullanıcı id: ${user.uid}");
    print("Post id: ${widget.post.id}");
    print("Gelen user id: ${widget.user.uid}");

    return loading
        ? Loading()
        : Scaffold(
            //floatingActionButton: MyFloatingActionButton(post: widget.post, user: widget.user),
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(45.0),
              child: AppBar(),
            ),
            //floatingActionButton: MyFloatingActionButton(),
            body: ListTile(
              title: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      elevation: 4,
                      child: Container(
                        height: 390,
                        width: 500,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image:
                                              AssetImage('assets/profil.png'),
                                          fit: BoxFit.cover)),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 160,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        //"Kullanıcı"
                                        widget.user.ad +
                                            " " +
                                            widget.user.soyad,

                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        //'${posts[index].createdAt.toDate()}',
                                        DateFormat('dd/MM/yyyy').format(
                                            DateTime.parse(
                                                '${widget.post.createdAt.toDate()}')),
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                /*
                                Icon(
                                  Icons.more_vert,
                                  color: Colors.grey,
                                  size: 22,
                                ),
                                */
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "${widget.post.aciklama}",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 200,
                              width: (MediaQuery.of(context).size.width - 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                //color: Colors.deepOrangeAccent,
                                image: DecorationImage(
                                    image: NetworkImage(
                                      '${widget.post.resimUrl}',
                                    ),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Divider(
                              color: Colors.black54,
                              thickness: 1.0,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Icon(
                                    AntDesign.star,
                                    //içi dolu  AntDesign.staro => içi boş anlamında
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                  Icon(
                                    AntDesign.star,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                  Icon(
                                    AntDesign.star,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                  Icon(
                                    AntDesign.star,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                  Icon(
                                    AntDesign.staro,
                                    color: Colors.red,
                                    size: 25,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Yorumlar",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 1.0,
                            ),
                            //BU ALANA LİSTVİEWBUİLDER KULLANACAĞIM
                            SingleChildScrollView(
                              child: Container(
                                height:
                                    270, //msj yazılan kısımla aralığı ayarlıyor
                                child: Column(
                                  children: [
                                    StreamBuilder<List<Yorumlar>>(
                                      stream: DatabaseService(
                                              uid: widget.user.uid,
                                              GonderiId: widget.post.id)
                                          .bireyselKullaniciYorumlar,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          List<Yorumlar> yorum = snapshot.data;
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: yorum.length,
                                              itemBuilder: (context, index) {
                                                print(
                                                    "Yorum uzunlukk: ${yorum.length}");
                                                return Container(
                                                  height: 80,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color:
                                                              Colors.black12)),
                                                  child: ListTile(
                                                    leading: Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          //color: Colors.yellow,
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/profil.png'),
                                                              fit: BoxFit
                                                                  .cover)),
                                                    ),
                                                    title: Text(
                                                      "Yorum yapan ad",
                                                      //"${kullanici[index2].ad} " + "${kullanici[index2].soyad}",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    subtitle: Text(
                                                      "${yorum[index].yorum}",
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                    dense: true,
                                                    trailing: Icon(
                                                      Icons.more_vert,
                                                      color: Colors.grey,
                                                      size: 22,
                                                    ),
                                                  ),
                                                );
                                              });
                                        } else {
                                          return Loading();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
