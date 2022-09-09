import 'package:flutter/material.dart';
import 'package:sosyal_kampus_vscode/helper/constants.dart';
import 'package:sosyal_kampus_vscode/helper/helper_functions.dart';
import 'package:sosyal_kampus_vscode/mesajlasma/chat.dart';
import 'package:sosyal_kampus_vscode/mesajlasma/search.dart';
import 'package:sosyal_kampus_vscode/screens/ilk_sayfa.dart';
import 'package:sosyal_kampus_vscode/services/auth.dart';
import 'package:sosyal_kampus_vscode/services/database_mesajlasma.dart';

class ChatRoom extends StatefulWidget {
  ChatRoom(
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
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Stream chatRooms;

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    user: widget.user,
                    hesapGecisi: widget.hesapGecisi,
                    isim: widget.isim,
                    userName: snapshot.data.docs[index]
                        .data()['chatRoomId']
                        .toString()
                        .replaceAll("_", "")
                        .replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.docs[index].data()["chatRoomId"],
                  );
                })
            : Container(
                child: Center(child: Text("VERİ YOK")),
              );
      },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    //print( "charrooms.dart 51.satırrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr:  ${Constants.myName}");
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
        //print("we got the data + ${chatRooms.toString()} this is name  ${Constants.myName}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 32.0,
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: <Color>[Color(0xFFff5722), Color(0xFFc7b198)],
              ),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                children: [
                  Text(
                    "Sohbetler",
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                ],
              ),
            ),
            chatRoomsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.search,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Search(
                      mesajlasilanKullanici: widget.mesajlasilanKullanici,
                        user: widget.user,
                        hesapGecisi: widget.hesapGecisi,
                        isim: widget.isim)));
          },
          backgroundColor: Colors.deepOrange),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  ChatRoomsTile(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim,
      this.userName,
      @required this.chatRoomId})
      : super(key: key);
  var hesapGecisi;
  var isim;
  var user;
  final String userName;
  final String chatRoomId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Chat(
                      user: user,
                      hesapGecisi: hesapGecisi,
                      isim: isim,
                      chatRoomId: chatRoomId,
                    )));
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Row(
              children: [
                Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      color: Colors.deepOrange[400],
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(userName.substring(0, 1),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'OverpassRegular',
                          fontWeight: FontWeight.w300)),
                ),
                SizedBox(
                  width: 12,
                ),
                Text(userName,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300))
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          )
        ],
      ),
    );
  }
}
