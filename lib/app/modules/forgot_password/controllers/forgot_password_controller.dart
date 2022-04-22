import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void forgotPassword() async {
    if (emailController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailController.text);
        Get.snackbar(
            "Oops !", "Email reset password telah dikirimkan ke email anda.");
      } catch (e) {
        Get.snackbar("Oops !", "$e");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Oops !", "Masukkan email anda !");
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
