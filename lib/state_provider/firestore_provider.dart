import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dtf_web/model/main_category.dart';
import 'package:dtf_web/source/database_service.dart';
import 'package:flutter/material.dart';

class FireStoreProvider with ChangeNotifier {
  final FirestoreService firestoreService;

  FireStoreProvider({required this.firestoreService}){
    getListOfMainCategory((e) {});
  }

  final List<MainCategory> _mainCategoryList = [];
  final List<String> _subCategoryList = [];

  List<String> get subCategoryList => _subCategoryList;

  List<MainCategory> get mainCategoryList => _mainCategoryList;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _streamSubscription;

  ///-----------------
  Future<void> addCategory(void Function(Exception e) errorCallback,
      {required String string, required String id}) async {
    try {
      await firestoreService.addCategory(string, id);
    } on Exception catch (e) {
      errorCallback(e);
    }
  }

  Future<void> getListOfMainCategory(
      void Function(Exception e) errorCallback) async {
    _mainCategoryList.clear();
        firestoreService.getListOfMainCategoryStream().listen((querySnapshot) {
          //
          // for (final document in querySnapshot.docs){
          //   _mainCategoryList.add(MainCategory.fromFirestore(document));
          // }
          //

      _mainCategoryList.addAll(querySnapshot.docs
          .map((queryDocumentSnapshot) =>
              MainCategory.fromFirestore(queryDocumentSnapshot))
          .toList());
      notifyListeners();
    },onError: (obj,stack){
          errorCallback(obj);
        });

    // try {
    //   final querySnapshot = await firestoreService.getListOfMainCategory();
    //   _mainCategoryList.addAll(querySnapshot.docs
    //       .map((queryDocumentSnapshot) =>
    //           MainCategory.fromFirestore(queryDocumentSnapshot))
    //       .toList());
    // } on Exception catch (e) {
    //   errorCallback(e);
    // }

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
    _subCategoryList.clear();

    try {
      final List<String> subcategory =
          await firestoreService.getSubCategoryList(id);
      _subCategoryList.addAll(subcategory);
    } on Exception catch (e) {
      errorCallback(e);
    }
    notifyListeners();
  }

  Future<void> upLoadQuote(void Function(Exception e) errorCallback,
      {required String collection, required Map<String, dynamic> map}) async {
    try {
      await firestoreService.upLoadQuote(collection, map);
    } on Exception catch (e) {
      errorCallback(e);
    }
    notifyListeners();
  }

  Future<void> uploadAudioAndVideo(void Function(Exception e) errorCallback,
      {required String collection,
      required String subCollection,
      required Map<String, dynamic> map}) async {
    try {
      await firestoreService.uploadAudioAndVideo(
          collection, subCollection, map);
    } on Exception catch (e) {
      errorCallback(e);
    }
    notifyListeners();
  }
}
