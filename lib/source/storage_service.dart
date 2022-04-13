import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
class StorageService{
  final _storageRef = FirebaseStorage.instance.ref();

  Future<String> upLoadToFireStorage(PlatformFile file,{required String destination})async{
    print('$destination/${file.name}');

    TaskSnapshot taskSnapShot = await _storageRef.child('$destination/${file.name}').putData(file.bytes!);

    switch(taskSnapShot.state){
      case TaskState.success:
        return await _storageRef.child('$destination/${file.name}').getDownloadURL();
      case TaskState.error:
        throw firebase_core.FirebaseException(plugin: 'firebase_core',message: 'Error went Generating link');
      default:
        throw firebase_core.FirebaseException(plugin: 'firebase_core',message: 'Error went Generating link');
    }
   // return _storageRef.child('temp/${file.name}').putData(file.bytes!);
  }
}