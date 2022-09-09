import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  getUserInfo(String email) async {
    return await FirebaseFirestore.instance
      .collection('users')
      .doc("9llKrCnWfmYhxhE4Xq5P0tedBLC2")
      .collection("ogrenciler")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserInfoIsletmeci(String email) async {
    return await FirebaseFirestore.instance
      .collection('users')
      .doc("9llKrCnWfmYhxhE4Xq5P0tedBLC2")
      .collection("isletmeciler")
        .where("email", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
      .collection('users')
      .doc("9llKrCnWfmYhxhE4Xq5P0tedBLC2")
      .collection("ogrenciler")
        .where('ad', isEqualTo: searchField)
        .get();
  }

  searchByNameIsletmeci(String searchField) {
    return FirebaseFirestore.instance
      .collection('users')
      .doc("9llKrCnWfmYhxhE4Xq5P0tedBLC2")
      .collection("isletmeciler")
        .where('name', isEqualTo: searchField)
        .get();
  }

  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  getChats(String chatRoomId) async{
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }


  Future<void> addMessage(String chatRoomId, chatMessageData){

    FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
          print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

}
