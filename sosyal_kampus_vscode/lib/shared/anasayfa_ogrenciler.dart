import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_kampus_vscode/models/post.dart';
import 'package:sosyal_kampus_vscode/models/user.dart';
import 'package:sosyal_kampus_vscode/screens/gonderi_ayrinti.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';
import 'package:sosyal_kampus_vscode/shared/loading.dart';

class OgrenciAnasayfaGonderiler extends StatefulWidget {
  OgrenciAnasayfaGonderiler(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  var hesapGecisi;
  var isim;
  var user;

  @override
  _OgrenciAnasayfaGonderilerState createState() =>
      _OgrenciAnasayfaGonderilerState();
}

class _OgrenciAnasayfaGonderilerState extends State<OgrenciAnasayfaGonderiler> {
  @override
  Widget build(BuildContext context) {
    var users;
    //var posts;
    //posts = Provider.of<List<Post>>(context) ?? [];
    users = Provider.of<List<Users>>(context) ?? [];
    return Container(
      child: Center(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, index) {
            //image = posts[index].resimUrl;
            //print("UsersSSSSS: ${users[index].uid}");
            return ListTile(
              title: StreamBuilder<List<Post>>(
                  stream: DatabaseService(uid: users[index].uid)
                      .bireyselKullaniciGonderiler,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Post> postss = snapshot.data;
                      //print("Uzunlukkkkk: ${postss.length}");
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: postss.length,
                          itemBuilder: (context, indexx) {
                            //print("post adet: $indexx");
                            return ListTile(
                              title: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(16),
                                  elevation: 4,
                                  child: Container(
                                    height: 410,
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
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/profil.png'),
                                                      fit: BoxFit.cover)),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  160,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    child: Text(
                                                      "${users[index].ad} " +
                                                          "${users[index].soyad}",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 7,
                                                  ),
                                                  FutureBuilder(
                                                    future: getDateText(
                                                        postss, indexx),
                                                    builder:
                                                        (BuildContext context,
                                                            AsyncSnapshot
                                                                snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Text(
                                                          //'${posts[index].createdAt.toDate()}',
                                                          snapshot.data,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        );
                                                      } else {
                                                        return CircularProgressIndicator();
                                                      }
                                                    },
                                                  ),
                                                  /*
                                            Text(
                                              //'${posts[index].createdAt.toDate()}',
                                              DateFormat('dd/MM/yyyy').format(
                                                  DateTime.parse(
                                                      '${posts[index].createdAt.toDate()}')),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey),
                                            )*/
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            "${postss[indexx].aciklama}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Container(
                                          height: 200,
                                          width: (MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    '${postss[indexx].resimUrl}'),
                                                //image.toString()
                                                //fit: BoxFit.scaleDown,
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              IconButton(
                                                icon: Icon(
                                                  Icons.message_outlined,
                                                  color: Colors.black,
                                                  size: 25,
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ShowPosts(
                                                              post: postss[
                                                                  indexx],
                                                              user:
                                                                  users[index]),
                                                    ),
                                                  );
                                                },
                                                iconSize: 24,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
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
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    } else {
                      return Loading();
                    }
                  }),

              //subtitle: Text(posts[index].resimUrl),
              onTap: () {},
            );
          },
        ),
      ),
    );
  }
}

Future<String> getDateText(posts, index) async {
  var date;
  date = await DateFormat('dd/MM/yyyy')
      .format(DateTime.parse('${posts[index].createdAt.toDate()}'));
  print('Date: $date');

  return date;
}

/*
Container(
      child: Center(
        child: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            //image = posts[index].resimUrl;
            return ListTile(
              title: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(16),
                    elevation: 4,
                    child: Container(
                      height: 410,
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
                                        image: AssetImage('assets/profil.png'),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width - 160,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        "Kullanıcı",
                                        //"${Users.ad}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 7,
                                    ),
                                    FutureBuilder(
                                      future: getDateText(posts, index),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                            //'${posts[index].createdAt.toDate()}',
                                            snapshot.data,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          );
                                        } else {
                                          return CircularProgressIndicator();
                                        }
                                      },
                                    ),

                                    /*
                                          Text(
                                            //'${posts[index].createdAt.toDate()}',
                                            DateFormat('dd/MM/yyyy').format(
                                                DateTime.parse(
                                                    '${posts[index].createdAt.toDate()}')),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          )*/
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "${posts[index].aciklama}",
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
                              image: DecorationImage(
                                  image:
                                      NetworkImage('${posts[index].resimUrl}'),
                                  //image.toString()
                                  //fit: BoxFit.scaleDown,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.message_outlined,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ShowPosts(post: posts[index]),
                                      ),
                                    );
                                  },
                                  iconSize: 24,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              //subtitle: Text(posts[index].resimUrl),
              onTap: () {},
            );
          },
        ),
      ),
    );
 */
