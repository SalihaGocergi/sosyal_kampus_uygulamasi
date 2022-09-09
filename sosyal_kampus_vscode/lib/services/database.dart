import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sosyal_kampus_vscode/models/post.dart';
import 'package:sosyal_kampus_vscode/models/takipler.dart';
import 'package:sosyal_kampus_vscode/models/user_isletmeci.dart';
import 'package:sosyal_kampus_vscode/models/user_ogrenciler.dart';
import 'package:sosyal_kampus_vscode/models/yorumlar.dart';

class DatabaseService {
  DatabaseService({this.uid, this.GonderiId});
  final String uid;
  final String GonderiId;
  final CollectionReference collectionOgrenciler = FirebaseFirestore.instance
      .collection('users')
      .doc("9llKrCnWfmYhxhE4Xq5P0tedBLC2")
      .collection("ogrenciler");
  final CollectionReference collectionKullanicilar =
      FirebaseFirestore.instance.collection('users');



// Anlık görüntüden liste yayınla profil
  List<Users> _profilListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Users.fromFirestore(doc);
    }).toList();
  }

  // BİREYSEL KULANICI BİLGİLERİNİ AL
  Stream<List<Users>> get bireyselKullaniciProfil {
    return collectionOgrenciler.snapshots().map(_profilListFromSnapshot);
  }

  Stream<List<Users>> get profil {
    return FirebaseFirestore.instance
        .collectionGroup('ogrenciler')
        .snapshots()
        .map(_profilListFromSnapshot);
  }

  // Anlık görüntüden liste yayınla post
  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Post.fromFirestore(doc);
    }).toList();
  }

  //FİREBASE İÇERİSİNDEKİ BÜTÜN POSTLARI GÖRÜNTÜLÜYOR
  Stream<List<Post>> get posts {
    return FirebaseFirestore.instance
        .collectionGroup('gonderiler')
        .snapshots()
        .map(_postListFromSnapshot);
  }

  Stream<List<Post>> get bireyselKullaniciGonderiler {
    return collectionOgrenciler
        .doc(uid)
        .collection("gonderiler")
        .snapshots()
        .map(_postListFromSnapshot);
  }

//DENEME AMAÇLI YAZILDI BÜTÜN KULLANICILARIN VERİLERİNİ ÇEKMEK AMAÇLI
  Stream<List<Post>> get kullaniciGonderileri {
    return collectionKullanicilar
        .doc(uid)
        .collection("gonderiler")
        .snapshots()
        .map(_postListFromSnapshot);
  }

  List<Yorumlar> _yorumlarListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Yorumlar.fromFirestore(doc);
    }).toList();
  }

  Stream<List<Yorumlar>> get bireyselKullaniciYorumlar {
    return collectionOgrenciler
        .doc(uid)
        .collection("gonderiler")
        .doc(GonderiId)
        .collection("yorumlar")
        .snapshots()
        .map(_yorumlarListFromSnapshot);
  }

  List<Takipler> _takiplerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Takipler.fromFirestore(doc);
    }).toList();
  }

  Stream<List<Takipler>> get bireyselKullaniciTakipler {
    return collectionOgrenciler
        .doc(uid)
        .collection("takipler")
        .snapshots()
        .map(_takiplerListFromSnapshot);
  }

  //KİŞİ BİLGİLERİ EKLEME
  Future registerUser(
      String uid,
      String email,
      String name,
      String surname,
      String universite_ad,
      String fakulte_ad,
      String bolum_ad,
      String sinif) async {
    try {
      return await collectionOgrenciler.doc(uid).set({
        "email": email,
        "ad": name,
        "soyad": surname,
        "universite_ad": universite_ad,
        "fakulte_ad": fakulte_ad,
        "bolum_ad": bolum_ad,
        "sinif": sinif,
        "kullaniciResim": "",
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future gonderiEkle(String uid, String aciklama, String resimUrl) async {
    try {
      await collectionOgrenciler.doc(uid).collection('gonderiler').doc().set({
        "aciklama": aciklama,
        "resimUrl": resimUrl.toString(),
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
      return uid;
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future takipEkle(String uid, String takipEdilenId) async {
    try {
      await collectionOgrenciler.doc(uid).collection('takipler').doc().set({
        "takipEdilenId:": takipEdilenId,
      });
      takipciEkle(takipEdilenId, uid);
      return uid;
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future takipciEkle(String uid, String takipEdilenId) async {
    try {
      await collectionOgrenciler.doc(uid).collection('takipciler').doc().set({
        "takipEdilenId:": takipEdilenId,
      });
      return uid;
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future takiptenCikar(
    String takipEdilenId,
  ) async {
    try {
      await takipciCikar(takipEdilenId);
      return await collectionOgrenciler
          .doc(uid)
          .collection('takipler')
          .doc(takipEdilenId)
          .delete();
    } catch (e) {
      print('Hata oluştu!! : $e');
      return null;
    }
  }

  Future takipciCikar(
    String takipciId,
  ) async {
    try {
      return await collectionOgrenciler
          .doc(takipciId)
          .collection('takipciler')
          .doc(uid)
          .delete();
    } catch (e) {
      print('Hata oluştu!! : $e');
      return null;
    }
  }

  Future yorumEkle(String yorumYapanId, String kullaniciId, String gonderiId,
      String yorum) async {
    try {
      await collectionOgrenciler
          .doc(kullaniciId)
          .collection('gonderiler')
          .doc(gonderiId)
          .collection('yorumlar')
          .doc()
          .set({
        'yorum': yorum,
        "yorumYapanId:": yorumYapanId,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future getProfile(String uid) async {
    try {
      DocumentSnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .doc('9llKrCnWfmYhxhE4Xq5P0tedBLC2')
          .collection('ogrenciler')
          .doc(uid)
          .get();

      if (result.exists) {
        return Users.fromFirestore(result);
      }
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future editPostCount(String uid, int postAded) async {
    try {
      return await collectionOgrenciler.doc(uid).set({
        "postAded": postAded,
      });
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future editProfile(
      String uid,
      String email,
      String ad,
      String soyad,
      String kullaniciResim,
      String universiteAd,
      String fakulteAd,
      String bolumAd,
      String sinif) async {
    try {
      return await collectionOgrenciler.doc(uid).set({
        "email": email,
        "ad": ad,
        "soyad": soyad,
        "kullaniciResim": kullaniciResim,
        "universite_ad": universiteAd,
        "fakulte_ad": fakulteAd,
        "bolum_ad": bolumAd,
        "sinif": sinif,
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future deletePost(
    String id,
  ) async {
    try {
      return await collectionOgrenciler
          .doc(uid)
          .collection('gonderiler')
          .doc(id)
          .delete();
    } catch (e) {
      print('Hata oluştu!! : $e');
      return null;
    }
  }

  Future editPost(String id, String aciklama, String resimUrl) async {
    try {
      await collectionOgrenciler.doc(uid).collection('gonderiler').doc(id).set({
        "aciklama": aciklama,
        "resimUrl": resimUrl,
        "updatedAt": FieldValue.serverTimestamp(),
      });
      return uid;
    } catch (e) {
      print('Hata oluştu!! : $e');
      return null;
    }
  }
}

class DatabaseService2 {
  final String uid;
  final String GonderiId;
  DatabaseService2({this.uid, this.GonderiId});

  final CollectionReference collectionIsletmeciler = FirebaseFirestore.instance
      .collection('users')
      .doc("9llKrCnWfmYhxhE4Xq5P0tedBLC2")
      .collection("isletmeciler");

  // Anlık görüntüden liste yayınla

  List<Post> _postListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Post.fromFirestore(doc);
    }).toList();
  }

  // tüm gönderileri al
  Stream<List<Post>> get posts {
    return FirebaseFirestore.instance
        .collectionGroup('gonderiler')
        .snapshots()
        .map(_postListFromSnapshot);
  }

  // bireysel kullanıcı gönderilerini al
  Stream<List<Post>> get individualPosts {
    return collectionIsletmeciler
        .doc(uid)
        .collection('gonderiler')
        .snapshots()
        .map(_postListFromSnapshot);
  }

  Stream<List<Post>> get bireyselKullaniciGonderiler {
    return collectionIsletmeciler
        .doc(uid)
        .collection("gonderiler")
        .snapshots()
        .map(_postListFromSnapshot);
  }

  List<Yorumlar> _yorumlarListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Yorumlar.fromFirestore(doc);
    }).toList();
  }

  Stream<List<Yorumlar>> get bireyselKullaniciYorumlar {
    return collectionIsletmeciler
        .doc(uid)
        .collection("gonderiler")
        .doc(GonderiId)
        .collection("yorumlar")
        .snapshots()
        .map(_yorumlarListFromSnapshot);
  }

  // Anlık görüntüden liste yayınla profil
  List<UsersIsletmeci> _profilListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UsersIsletmeci.fromFirestore(doc);
    }).toList();
  }

  Stream<List<UsersIsletmeci>> get bireyselKullaniciProfil {
    return collectionIsletmeciler.snapshots().map(_profilListFromSnapshot);
  }

  Stream<List<UsersIsletmeci>> get profil {
    return FirebaseFirestore.instance
        .collectionGroup('isletmeciler')
        .snapshots()
        .map(_profilListFromSnapshot);
  }

  List<Takipler> _takiplerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Takipler.fromFirestore(doc);
    }).toList();
  }

  Stream<List<Takipler>> get bireyselKullaniciTakipler {
    return collectionIsletmeciler
        .doc(uid)
        .collection("takipler")
        .snapshots()
        .map(_takiplerListFromSnapshot);
  }

  Future registerUser(
      String uid, String email, String name, String address, String tel) async {
    try {
      return await collectionIsletmeciler.doc(uid).set({
        "email": email,
        "name": name,
        "address": address,
        "tel": tel,
        "userImage": "",
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future gonderiEkle(String uid, String aciklama, String resimUrl) async {
    try {
      await collectionIsletmeciler.doc(uid).collection('gonderiler').doc().set({
        "aciklama": aciklama,
        "resimUrl": resimUrl.toString(),
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
      return uid;
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future getProfile(String uid) async {
    try {
      DocumentSnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .doc('9llKrCnWfmYhxhE4Xq5P0tedBLC2')
          .collection('isletmeciler')
          .doc(uid)
          .get();

      if (result.exists) {
        return UsersIsletmeci.fromFirestore(result);
      }
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future deletePost(
    String id,
  ) async {
    try {
      return await collectionIsletmeciler
          .doc(uid)
          .collection('gonderiler')
          .doc(id)
          .delete();
    } catch (e) {
      print('Hata oluştu!! : $e');
      return null;
    }
  }

  Future editPost(String id, String aciklama, String resimUrl) async {
    try {
      await collectionIsletmeciler
          .doc(uid)
          .collection('gonderiler')
          .doc(id)
          .set({
        "aciklama": aciklama,
        "resimUrl": resimUrl,
        "updatedAt": FieldValue.serverTimestamp(),
      });
      return uid;
    } catch (e) {
      print('Hata oluştu!! : $e');
      return null;
    }
  }

  Future createPost(String uid, String title, String content) async {
    try {
      await collectionIsletmeciler.doc(uid).collection('posts').doc().set({
        "title": title,
        "content": content,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
      return uid;
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future yorumEkle(String yorumYapanId, String kullaniciId, String gonderiId,
      String yorum) async {
    try {
      await collectionIsletmeciler
          .doc(kullaniciId)
          .collection('gonderiler')
          .doc(gonderiId)
          .collection('yorumlar')
          .doc()
          .set({
        'yorum': yorum,
        "yorumYapanId:": yorumYapanId,
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future editProfile(
      String uid, String email, String ad, String userImage, String adres, String tel) async {
    try {
      return await collectionIsletmeciler.doc(uid).set({
        "email": email,
        "name": ad,
        "userImage": userImage,
        "address": adres,
        "tel": tel,
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future takipEkle(String uid, String takipEdilenId) async {
    try {
      await collectionIsletmeciler.doc(uid).collection('takipler').doc().set({
        "takipEdilenId:": takipEdilenId,
      });
      takipciEkle(takipEdilenId, uid);
      return uid;
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }

  Future takipciEkle(String uid, String takipEdilenId) async {
    try {
      await collectionIsletmeciler.doc(uid).collection('takipciler').doc().set({
        "takipEdilenId:": takipEdilenId,
      });
      return uid;
    } catch (e) {
      print('Hata oluştu!! : $e');
    }
  }
}
