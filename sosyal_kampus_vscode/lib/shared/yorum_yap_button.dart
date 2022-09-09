import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_kampus_vscode/models/post.dart';
import 'package:sosyal_kampus_vscode/models/user_ogrenciler.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';
import 'package:sosyal_kampus_vscode/shared/yorum_yap_widget.dart';

class MyFloatingActionButton extends StatefulWidget {
  MyFloatingActionButton({
    Key key,
    @required this.post,
    @required this.user,
    @required this.hesapGecisi,
    @required this.isim,
  }) : super(key: key);
  final Post post;
  final user;
  var hesapGecisi;
  var isim;

  @override
  _MyFloatingActionButtonState createState() => _MyFloatingActionButtonState();
}

class _MyFloatingActionButtonState extends State<MyFloatingActionButton> {
  bool loading = false;
  String error = '';
  bool showFab = true;
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    
    
    final _dbIsletmeci = DatabaseService2();
    final user = Provider.of<User>(context); //giriş yapan kullanıcı id
    return showFab
    ? FloatingActionButton.extended(
      key: scaffoldKey,
      backgroundColor: Colors.deepOrange,
      label: const Text('Yorum Yap'),
      icon: const Icon(Icons.add_comment),
      onPressed: () {
        var bottomSheetController =showBottomSheet(
          context: context,
          builder: (context) => Container(
            height: 125,
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10, color: Colors.grey[300], spreadRadius: 5)
            ]),
            child: BottomSheetWidget(post: widget.post, user: widget.user,hesapGecisi: widget.hesapGecisi,
        isim: widget.isim,),
          
          ),
        );
        showFoatingActionButton(false);
        bottomSheetController.closed.then((value) {
                showFoatingActionButton(true);
              });
              },
            )
            : Container();
          }
        
          void showFoatingActionButton(bool value) {
          setState(() {
            showFab = value;
          });
  }

  
}

