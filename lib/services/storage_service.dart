import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final storage = FirebaseStorage.instance;

  Future<String> saveProfilePhoto(File file, String email) async{
    String imageUrl;
    Reference ref = storage.ref().child("profile_photos").child(email);
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;

    imageUrl = await taskSnapshot.ref.getDownloadURL();

    return imageUrl;
  }
  
}