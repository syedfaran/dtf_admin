import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addCategory(String string, String id) async {
    final CollectionReference category = _db.collection('categories');
    await category.add({'mainCategory': string, 'mainCategoryId': id});
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getListOfMainCategory() async {
    final mainCategory = await _db.collection('categories').get();
    return mainCategory;
  }

  Future<void> addSubCategory(String string, String id) async {
    final CollectionReference subCategory = _db.collection('categories');
    await subCategory
        .doc(id)
        .collection('subCategories')
        .add({'subCategory': string});
  }

  Future<List<String>> getSubCategoryList(String id) async {
    final CollectionReference subCategory = _db.collection('categories');
    final querySnapshot =
        await subCategory.doc(id.trim()).collection('subCategories').get();
    querySnapshot.docs.map((e) => e.data()['subCategory']).toList();
    return querySnapshot.docs.map<String>((e) => e['subCategory']).toList();
  }

  Future<void> upLoadQuote(String collection, Map<String, dynamic> map) async {
    final CollectionReference quoteCategories =
        _db.collection('quotesCategories');
    await quoteCategories.doc('quotes').collection('Alone').add(map);
  }

  Future<void> uploadAudioAndVideo(
      String collection, String subCollection, Map<String, dynamic> map) async {
    //todo audio/video
     final CollectionReference audioSlashVideo = _db.collection(collection);
     await audioSlashVideo.doc('1').collection(subCollection).add(map);
  }
}
