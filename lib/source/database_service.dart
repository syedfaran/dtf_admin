import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //DataBaseService._();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> foo() async {
    final result = await _db
        .collection('quotesCategories')
        .doc('quotes')
        .collection('Alone')
        .get();
    final resultTwo = await _db.collection('categories').get();
    final resultThree = await _db
        .collection('categories')
        .doc('lHqlNzYEkgiLUIsy5RLB')
        .collection('subCategories')
        .get();

    resultTwo.docs.map((e) => print(e.data()['mainCategory'])).toList();

    // result.docs.map((e) => print(e.data()['author'])).toList();
  }

  Future<void> addCategory(String string) async {
    final CollectionReference category = _db.collection('categories');
    await category.add({'mainCategory': string});
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

  Future<void> upLoadQuote(String collection,Map<String,dynamic> map)async{
    final CollectionReference quoteCategories = _db.collection('quotesCategories');
    var gg =await quoteCategories.doc('quotes').collection('Alone').add(map);
  }
}
