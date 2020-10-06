import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageAPI{
  final StorageReference _storageReference=FirebaseStorage.instance.ref();
  StorageUploadTask task;

  Future<StorageUploadTask>uploadFile(String path, File image, bool isVideo) async{
    if(isVideo){
      task= _storageReference.child(path).putFile(image,StorageMetadata(contentType: 'video/mp4'));
    }else{
      print("*********************************Entre a la imagen");
      task= _storageReference.child(path).putFile(image);
    }
    return task;
  }
}