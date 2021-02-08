import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final storage = FirebaseStorage.instance;

  static UploadTask uploadFile(String uploadPath, File fileToUpload) =>
      storage.ref('$uploadPath').putFile(fileToUpload);

  static Future<void> deleteByDownloadUrl(String downloadUrl) async =>
      await storage.refFromURL(downloadUrl).delete();

  static Future<void> deleteByUploadPath(String uploadPath) async =>
      await storage.ref(uploadPath).delete();
}
