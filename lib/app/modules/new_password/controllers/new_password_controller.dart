import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class NewPasswordController extends GetxController {
  final passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  void save() async {
    if (passwordController.text.isNotEmpty) {
      if (passwordController.text == "password") {
        Get.snackbar("Oops !", "Gunakan password baru !");
      } else {
        try {
          String email = auth.currentUser!.email!;
          await auth.currentUser!.updatePassword(passwordController.text);
          await auth.signOut();
          await auth.signInWithEmailAndPassword(
              email: email, password: passwordController.text);
          Get.offAllNamed(Routes.HOME);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("Oops !", "Password terlalu lemah !");
          }
        } catch (e) {
          Get.snackbar("Oops !", "Terjadi gangguan server !");
        }
      }
    } else {
      Get.snackbar("Oops !", "Lengkapi semua data !");
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
