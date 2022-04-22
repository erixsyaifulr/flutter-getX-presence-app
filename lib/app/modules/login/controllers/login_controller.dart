import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> login() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        final userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified) {
            if (passwordController.text == "password") {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            Get.defaultDialog(
                title: "Email belum diverifikasi",
                middleText: "Verifikasi email terlebih dahulu");
          }
        }
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'user-not-found') {
          Get.snackbar("Oops !", "Email tidak terdaftar.");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Oops !", "Password yang anda masukkan salah.");
        }
      } catch (e) {
        Get.snackbar("Oops !", "$e");
      } finally {
        isLoading.value = false;
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
