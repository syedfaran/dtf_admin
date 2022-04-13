import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService{
  final _storageRef = FirebaseStorage.instance.ref();

  Future<void> upLoadImage(PlatformFile file)async{
    _storageRef.child('temp/${file.name}').putData(file.bytes!);

  }
}