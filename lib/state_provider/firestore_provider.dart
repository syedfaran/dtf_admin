import 'package:dtf_web/model/main_category.dart';
import 'package:dtf_web/source/database_service.dart';
import 'package:flutter/material.dart';

class FireStoreProvider with ChangeNotifier {
  final FirestoreService firestoreService;

  FireStoreProvider({required this.firestoreService});

  final List<MainCategory> _mainCategoryList = [];
  final List<String> _subCategoryList = [];

  List<String> get subCategoryList => _subCategoryList;

  List<MainCategory> get mainCategoryList => _mainCategoryList;

  Future<void> addCategory(void Function(Exception e) errorCallback,
      {required String string}) async {
    try {
      await firestoreService.addCategory(string);
    } on Exception catch (e) {
      errorCallback(e);
    }
  }

  Future<void> getListOfMainCategory(
      void Function(Exception e) errorCallback) async {
    try {
      final querySnapshot = await firestoreService.getListOfMainCategory();
      _mainCategoryList.addAll(querySnapshot.docs
          .map((queryDocumentSnapshot) =>
              MainCategory.fromFirestore(queryDocumentSnapshot))
          .toList());
    } on Exception catch (e) {
      errorCallback(e);
    }
    notifyListeners();
  }

  Future<void> addSubCategory(void Function(Exception e) errorCallback,
      {required String string, required String id}) async {
    try {
      await firestoreService.addSubCategory(string, id);
    } on Exception catch (e) {
      errorCallback(e);
    }
  }

  Future<void> getSubCategoryList(void Function(Exception e) errorCallback,
      {required String id}) async {
    try {
     final List<String> subcategory= await firestoreService.getSubCategoryList(id);
     _subCategoryList.addAll(subcategory);
    } on Exception catch (e) {
      errorCallback(e);
    }
    notifyListeners();
  }
}
