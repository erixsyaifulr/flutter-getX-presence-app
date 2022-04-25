import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  final nipController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  RxBool isLoading = false.obs;
  XFile? image;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  fStorage.FirebaseStorage storage = fStorage.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();

  Future<void> updateProfile(String uid) async {
    if (nameController.text.isNotEmpty &&
        nipController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {"name": nameController.text};
        if (image != null) {
          File file = File(image!.path);
          String ext = image!.name.split(".").last;
          await storage.ref('$uid/profile.$ext').putFile(file);
          String imageUrl =
              await storage.ref('$uid/profile.$ext').getDownloadURL();
          data.addAll({"profile_photo": imageUrl});
        }
        await firestore.collection('users').doc(uid).update(data);
        image = null;
        Get.snackbar("Success !", "Berhasil update profile");
      } catch (e) {
        Get.snackbar("Oops !", "Terjadi kesalahan");
      } finally {
        isLoading.value = false;
      }
      Get.back();
    }
  }

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      update();
    }
  }

  void deleteProfile(String uid) async {
    try {
      await firestore.collection('users').doc(uid).update({
        "profile_photo": FieldValue.delete(),
      });
      update();
      Get.snackbar("Success !", "Berhasil hapus profile");
    } catch (e) {
      Get.snackbar("Oops !", "Terjadi kesalahan");
    }
  }
}
