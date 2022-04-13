import 'package:dtf_web/source/storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
class StorageProvider with ChangeNotifier {
  final StorageService storageService;

  StorageProvider({required this.storageService});

  PlatformFile? _pickedAudioOrVideo;
  PlatformFile? _pickedImage;
  PlatformFile? get pickedAudioOrVideo => _pickedAudioOrVideo;
  PlatformFile? get pickedImage => _pickedImage;

  static List<String> get storageAudioPath => [
    'Hot10_Audio',
    'MyCollection_Audio',
    'TopFavourite_Audio',
    'Trending_Audio'
  ];

  static List<String> get storageVideoPath => [
    'Hot10_Video',
    'MyCollection_Video',
    'TopFavourite_Video',
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

  Future<void> selectImage(void Function(Failure e) errorCallback,TextEditingController string) async {
    _pickedImage = await _selectFile();
    if (_pickedImage == null) {
      errorCallback(const Failure('No Image Selected'));
      return;
   //   throw const ImageException('No Image Selected');
    }
    string.text = _pickedImage!.name;
    notifyListeners();
  }

  Future<void> selectAudioOrVideo(void Function(Failure e) errorCallback,TextEditingController string) async {
    _pickedImage = await _selectFile();
    if (_pickedImage == null) {
      errorCallback(const Failure('No audio or Video Selected'));
      return;
      //   throw const ImageException('No Image Selected');
    }
    string.text = _pickedImage!.name;
    notifyListeners();
  }
  Future<void> uploadImage()async{
    try{
      await storageService.upLoadImage(_pickedImage!);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
      // ...
    }
  }
}

class Failure implements Exception {
  final String message;
  const Failure(this.message);
}


