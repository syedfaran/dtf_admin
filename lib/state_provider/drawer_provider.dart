import 'package:flutter/material.dart';

class DrawerProvider with ChangeNotifier {
  EnumBody _enumBody = EnumBody.audioAndVideo;

  set enumBody(EnumBody value) {
    _enumBody = value;
    notifyListeners();
  }

  EnumBody get enumBody => _enumBody;
}

enum EnumBody { categoriesAndSubCategories, uploadQuote, audioAndVideo }
