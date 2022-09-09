import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sosyal_kampus_vscode/models/post.dart';
import 'package:sosyal_kampus_vscode/models/takipler.dart';
import 'package:sosyal_kampus_vscode/models/user_ogrenciler.dart';
import 'package:sosyal_kampus_vscode/models/user_isletmeci.dart';
import 'package:sosyal_kampus_vscode/models/yorumlar.dart';
import 'package:sosyal_kampus_vscode/screens/ilk_sayfa.dart';
import 'package:sosyal_kampus_vscode/services/auth.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("Error");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        return CircularProgressIndicator();
      },
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

class _MyAppState extends State<MyApp> {
  bool isAuthenticated = false; //kullanıcının giriş yapıp yapmadığını tutuyor
  //String testProviderText = 'Merhaba Provider!';

  MaterialColor colorCustom = MaterialColor(0xFFff4500, color);

  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      //print('onAuthStateChanged fonksiyonu çağrıldı');

      setState(() {
        isAuthenticated = user != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Provider<String>(create: (context) => testProviderText),
        StreamProvider<User>(
          //meydana gelen değişiklikleri burada elde edebiliyoruz
          create: (context) => FirebaseAuth.instance.authStateChanges(),
        ),
        StreamProvider<Users>.value(value: AuthService().user),
        StreamProvider<UsersIsletmeci>.value(value: AuthService2().user),
        StreamProvider<List<Post>>(
          create: (context) => DatabaseService().posts,
        ),
        StreamProvider<List<Post>>(
          create: (context) => DatabaseService2().posts,
        ),
        StreamProvider<List<Users>>(
          create: (context) => DatabaseService().profil,
        ),
        StreamProvider<List<Post>>(
          create: (context) => DatabaseService().bireyselKullaniciGonderiler,
        ),
        StreamProvider<List<Yorumlar>>(
          create: (context) => DatabaseService().bireyselKullaniciYorumlar,
        ),
        StreamProvider<List<Users>>(
          create: (context) => DatabaseService().bireyselKullaniciProfil,
        ),
        StreamProvider<List<Takipler>>(
          create: (context) => DatabaseService().bireyselKullaniciTakipler,
        ),
        StreamProvider<List<Post>>(
          create: (context) => DatabaseService2().bireyselKullaniciGonderiler,
        ),
        StreamProvider<List<Yorumlar>>(
          create: (context) => DatabaseService2().bireyselKullaniciYorumlar,
        ),
        StreamProvider<List<UsersIsletmeci>>(
          create: (context) => DatabaseService2().bireyselKullaniciProfil,
        ),
        StreamProvider<List<Takipler>>(
          create: (context) => DatabaseService2().bireyselKullaniciTakipler,
        ),
        StreamProvider<List<Post>>(
          create: (context) => DatabaseService().kullaniciGonderileri,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Sosyal Kampüs",
        theme:
            ThemeData(primarySwatch: colorCustom, bottomAppBarColor: colorCustom
                //canvasColor: Color(0XFF8b1a1a),

                ),
        home: FirstPage(),
      ),
    );
  }
}
