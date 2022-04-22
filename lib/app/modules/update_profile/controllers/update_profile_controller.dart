import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileController extends GetxController {
  final nipController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateProfile(String uid) async {
    if (nameController.text.isNotEmpty &&
        nipController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await firestore.collection('users').doc(uid).update({
          'name': nameController.text,
          'nip': nipController.text,
          'email': emailController.text,
        });
        Get.snackbar("Success !", "Berhasil update profile");
      } catch (e) {
        Get.snackbar("Oops !", "Terjadi kesalahan");
      } finally {
        isLoading.value = false;
      }
      Get.back();
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
