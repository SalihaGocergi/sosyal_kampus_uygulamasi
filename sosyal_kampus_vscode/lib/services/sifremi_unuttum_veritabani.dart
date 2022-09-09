import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInHelper {
  static SignInHelper _signInHelper = SignInHelper._private();

  SignInHelper._private();

  static SignInHelper instance() {
    return _signInHelper; // singelethon design pattern
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  sifremiUnuttum(String email) {
    auth.sendPasswordResetEmail(email: email).then((kullaniciPass) {
      /* text input içinden alınan emaili ile şifre sıfırlama bağlantısı gönderilir */
      debugPrint(
          "şifre güncelleme maili gönderildi lütfen e-mail  adresinizi kontol edin !");
      auth.signOut();
    }).catchError((e) => debugPrint(
        "Şifre güncellenirken hata çıktı ya da böyle bir e-posta adresi sistemimize kayıtlı değil" +
            "HATA: " +
            e));
  }
}
