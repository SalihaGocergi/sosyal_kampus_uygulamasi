import 'package:firebase_auth/firebase_auth.dart';
import 'package:sosyal_kampus_vscode/models/user_ogrenciler.dart';
import 'package:sosyal_kampus_vscode/models/user_isletmeci.dart';
import 'package:sosyal_kampus_vscode/services/database.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _db = DatabaseService();

  Users _userFromUser(User user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  Stream<Users> get user {
    return _auth.authStateChanges().map(_userFromUser);
  }

  //KİMLİK DOĞRULAMA İŞLEMİ
  Future logInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        //kimlik doğrulama işlevi
        email: email.trim(),
        password: password,
      ))
          .user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //VERİTABANINA KULLANICI EKLEME
  Future registerWithEmailAndPassword(
    String email,
    String password,
    String ad,
    String soyad,
    String universite_ad,
    String fakulte_ad,
    String bolum_ad,
    String sinif,
  ) async {
    try {
      User user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        //email ve şifre, auth kayıdı
        email: email.trim(),
        password: password,
      ))
          .user;
      await _db.registerUser(user.uid, email, ad, soyad, universite_ad,
          fakulte_ad, bolum_ad, sinif); //veritabanına kayıt
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //ÇIKIŞ
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class AuthService2 {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService2 _db = DatabaseService2();

  UsersIsletmeci _userFromUser(User user) {
    return user != null ? UsersIsletmeci(uid: user.uid) : null;
  }

  Stream<UsersIsletmeci> get user {
    return _auth.authStateChanges().map(_userFromUser);
  }

  //KİMLİK DOĞRULAMA İŞLEMİ
  Future logInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(
        //kimlik doğrulama işlevi
        email: email.trim(),
        password: password,
      ))
          .user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //VERİTABANINA KULLANICI EKLEME
  Future registerWithEmailAndPassword(
    String email,
    String password,
    String name,
    String address,
    String tel,
  ) async {
    try {
      User user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        //email ve şifre, auth kayıdı
        email: email.trim(),
        password: password,
      ))
          .user;
      await _db.registerUser(
          user.uid, email, name, address, tel); //veritabanına kayıt
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //ÇIKIŞ
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
