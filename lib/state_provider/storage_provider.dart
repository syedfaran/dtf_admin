import 'dart:convert';

import 'package:dtf_web/model/quote.dart';
import 'package:dtf_web/source/storage_service.dart';
import 'package:dtf_web/state_provider/firestore_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:provider/provider.dart';

class StorageProvider with ChangeNotifier {
  final StorageService storageService;

  StorageProvider({required this.storageService});

  PlatformFile? _pickedAudio;
  PlatformFile? _pickedImage;
  PlatformFile? _pickedJson;
  String? _imageUrl;
  String? _audioUrl;

  PlatformFile? get pickedAudio => _pickedAudio;

  PlatformFile? get pickedImage => _pickedImage;

  PlatformFile? get pickedJson => _pickedJson;

  String? get audioUrl => _audioUrl;
  String? get imageUrl => _imageUrl;

  set audioUrl(String? value) {
    _audioUrl = value;
  }



  static List<String> get storageAudioPath => [
        'Hot10_Audio',
        'MyCollection_Audio',
        'Top Favourite_Audio',
        'Trending_Audio'
      ];

  static List<String> get storageVideoPath => [
        'Hot10_Video',
        'MyCollection_Video',
        'Top Favourite_Video',
        'Trending_Video'
      ];

  Future<PlatformFile?> _selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return null;
    PlatformFile file = result.files.first;
    //  print(file.name);
    //  print(file.bytes);
    //  print(file.size/1024);
    //  print(file.extension);
    // print(file.path);

    return file;
  }

  Future<void> selectImage(void Function(Failure e) errorCallback,
      TextEditingController string) async {
    _pickedImage = await _selectFile();
    if (_pickedImage == null) {
      string.text = '';
      errorCallback(const Failure('No Image Selected'));
      return;
      //   throw const ImageException('No Image Selected');
    }
    string.text = _pickedImage!.name;
    notifyListeners();
  }

  Future<void> unSelectImage({required TextEditingController string}) async {
    _pickedImage = null;
    string.text = '';
    notifyListeners();
  }

  Future<void> upLoadImage(void Function(Failure e) errorCallback,
      {required int index, required bool isAudioSelected}) async {
    final String destination =
        isAudioSelected ? storageAudioPath[index] : storageVideoPath[index];

    try {
      _imageUrl = await storageService.upLoadToFireStorage(_pickedImage!,
          destination: destination);
    } on firebase_core.FirebaseException catch (e) {
      Failure(e.message!);
      // ...
    }
  }

  Future<void> selectAudio(void Function(Failure e) errorCallback,
      TextEditingController string) async {
    _pickedAudio = await _selectFile();
    if (_pickedAudio == null) {
      string.text = '';
      errorCallback(const Failure('No audio or Video Selected'));
      return;
      //   throw const ImageException('No Image Selected');
    }
    string.text = _pickedAudio!.name;
    notifyListeners();
  }

  Future<void> unSelectAudio({required TextEditingController string}) async {
    _pickedAudio = null;
    string.text = '';
    notifyListeners();
  }

  Future<void> upLoadAudio(void Function(Failure e) errorCallback,
      {required int index, required bool isAudioSelected}) async {
    final String destination =
        isAudioSelected ? storageAudioPath[index] : storageVideoPath[index];
    try {
      //todo upload with destination
      _audioUrl = await storageService.upLoadToFireStorage(_pickedAudio!,
          destination: destination);
    } on firebase_core.FirebaseException catch (e) {
      Failure(e.message!);
      // ...
    }
  }

  Future<void> selectJson(void Function(Failure e) errorCallback,
      TextEditingController string) async {
    _pickedJson = await _selectFile();
    if (_pickedJson == null) {
      string.text = '';
      errorCallback(const Failure('No Image Selected'));
      return;
      //   throw const ImageException('No Image Selected');
    }
    string.text = _pickedJson!.name;
    notifyListeners();
  }

  Future<void> writeJsonToFireStore(void Function(Failure e) errorCallback,
      {required BuildContext context, required String collection,required TextEditingController string }) async {

    if(_pickedJson==null){
      errorCallback(const Failure('No file selected'));
      return;
    }else{
      final List list = jsonDecode(utf8.decode(_pickedJson!.bytes!)) as List;
      list.map((e) async{
        await context.read<FireStoreProvider>().upLoadQuote((e) {
          errorCallback(const Failure('json error'));},
            collection: collection, map: QuoteModel.fromJson(e).toMap());
      }).toList();
      ///reset
      _pickedJson=null;
      string.text = '';
    }
    notifyListeners();
  }

}

class Failure implements Exception {
  final String message;

  const Failure(this.message);
}
