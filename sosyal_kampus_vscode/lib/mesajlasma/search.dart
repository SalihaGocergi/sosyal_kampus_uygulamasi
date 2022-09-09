import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sosyal_kampus_vscode/helper/constants.dart';
import 'package:sosyal_kampus_vscode/mesajlasma/chat.dart';
import 'package:sosyal_kampus_vscode/services/database_mesajlasma.dart';

class Search extends StatefulWidget {
  Search(
      {Key key,
      @required this.mesajlasilanKullanici,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  var hesapGecisi;
  var isim;
  var user;
  var mesajlasilanKullanici;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;

  initiateSearch() async {
    if (searchEditingController.text.isNotEmpty) {
      if (widget.mesajlasilanKullanici == 0) {
        setState(() {
          isLoading = true;
        });
        await databaseMethods
            .searchByName(searchEditingController.text)
            .then((snapshot) {
          searchResultSnapshot = snapshot;
          print(
              "search.dart 29.satır searchEditingControllerrrrrr:  ${searchEditingController.text}");
          setState(() {
            isLoading = false;
            haveUserSearched = true;
          });
        });
      }
      if (widget.mesajlasilanKullanici == 1) {
        setState(() {
          isLoading = true;
        });
        await databaseMethods
            .searchByNameIsletmeci(searchEditingController.text)
            .then((snapshot) {
          searchResultSnapshot = snapshot;
          print(
              "search.dart 29.satır searchEditingControllerrrrrr:  ${searchEditingController.text}");
          setState(() {
            isLoading = false;
            haveUserSearched = true;
          });
        });
      }
    }
  }

  Widget userList() {
    return haveUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResultSnapshot.docs.length,
            itemBuilder: (context, index) {
              if (widget.mesajlasilanKullanici == 0) {
                return userTile(
                  searchResultSnapshot.docs[index].data()["ad"],
                  searchResultSnapshot.docs[index].data()["email"],
                );
              }
              if (widget.mesajlasilanKullanici == 1) {
                return userTile(
                  searchResultSnapshot.docs[index].data()["name"],
                  searchResultSnapshot.docs[index].data()["email"],
                );
              } else {
                return Container();
              }
            })
        : Container();
  }

  /// 1.create a chatroom, send user to the chatroom, other userdetails
  sendMessage(String userName) {
    List<String> users = [Constants.myName, userName];

    String chatRoomId = getChatRoomId(Constants.myName, userName);
    print("search.dart 58.satır usernameeeeeeeeeeeeeeeeeeeee: $userName");

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Chat(
                  user: widget.user,
                  hesapGecisi: widget.hesapGecisi,
                  isim: widget.isim,
                  chatRoomId: chatRoomId,
                )));
  }

  Widget userTile(String userName, String userEmail) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
          color: Colors.grey[350], borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$userName',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                '$userEmail',
                style: TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.deepOrange[400],
                  borderRadius: BorderRadius.circular(24)),
              child: Text(
                "Mesaj",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 70.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                        color: Colors.deepOrange[400],
                        borderRadius: BorderRadius.circular(10)),
                    //color: Colors.deepOrange[400],
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchEditingController,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            decoration: InputDecoration(
                                hintText: "kullanıcı ara ...",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            initiateSearch();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        const Color(0x3FFFFFFF),
                                        const Color(0xFFFFFFFF)
                                      ],
                                      begin: FractionalOffset.topLeft,
                                      end: FractionalOffset.bottomRight),
                                  borderRadius: BorderRadius.circular(40)),
                              padding: EdgeInsets.all(12),
                              child: Image.asset(
                                "assets/search_white.png",
                                height: 25,
                                width: 25,
                              )),
                        )
                      ],
                    ),
                  ),
                  userList()
                ],
              ),
            ),
    );
  }
}
