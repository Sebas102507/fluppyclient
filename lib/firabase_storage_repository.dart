import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluppyclient/firebase_storage_api.dart';
class FirebaseStorageRepository {

  final _firebaseStorageAPI=FirebaseStorageAPI();

  Future<StorageUploadTask> uploadFile(String path, File image, bool isVideo)  {
   return  _firebaseStorageAPI.uploadFile(path, image,isVideo);
  }
}