import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_kampus_vscode/isletmeciEkranlar/isletmeci_gonderiler.dart';
import 'package:sosyal_kampus_vscode/screens/anasayfa_drawer.dart';
import 'package:sosyal_kampus_vscode/screens/arama.dart';
import 'package:sosyal_kampus_vscode/screens/gonderi_yeni.dart';
import 'package:sosyal_kampus_vscode/screens/login.dart';
import 'package:sosyal_kampus_vscode/screens/mesajla%C5%9Fma.dart';
import 'package:sosyal_kampus_vscode/shared/appBar_widget.dart';

class IsletmeciAnasayfa extends StatefulWidget {
  IsletmeciAnasayfa(
      {Key key,
      @required this.user,
      @required this.hesapGecisi,
      @required this.isim})
      : super(key: key);
  var hesapGecisi;
  var isim;
  var user;

  @override
  _IsletmeciAnasayfaState createState() => _IsletmeciAnasayfaState();
}

class _IsletmeciAnasayfaState extends State<IsletmeciAnasayfa>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final bool isAuthenticated = user != null;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBarWidget(
          title: "${widget.isim} Anasayfa",
        ),
      ),
      drawer: AnasayfaDrawer(
        user: widget.user,
        hesapGecisi: widget.hesapGecisi,
        isim: widget.isim,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          IsletmeciGonderiler(
                    user: widget.user,
                    hesapGecisi: widget.hesapGecisi,
                    isim: widget.isim),
          Arama(
              user: widget.user,
              hesapGecisi: widget.hesapGecisi,
              isim: widget.isim),
          Mesajlasma(user: widget.user,
              hesapGecisi: widget.hesapGecisi,
              isim: widget.isim)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (currentIndex) {
          setState(() {
            _currentIndex = currentIndex;
          });

          _tabController.animateTo(_currentIndex);
        },
        items: [
          BottomNavigationBarItem(
            title: Text("Anasayfa"),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text("Arama"),
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            title: Text("Mesaj"),
            icon: Icon(Icons.message_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          if (isAuthenticated) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => YeniGonderi(
                    user: user,
                    hesapGecisi: widget.hesapGecisi,
                    isim: widget.isim),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LogIn(
                  isim: widget.isim,
                  hesapGecisi: widget.hesapGecisi,
                ),
              ),
            );
          }
        },
        tooltip: isAuthenticated ? 'Yeni Post' : 'Login',
        child: isAuthenticated
            ? Icon(
                Icons.note_add,
              )
            : Icon(
                Icons.settings_backup_restore,
              ),
      ),
    );
  }
}
