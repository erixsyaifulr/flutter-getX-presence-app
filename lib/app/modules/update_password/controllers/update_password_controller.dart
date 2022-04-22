import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> updatePassword() async {
    if (currentPasswordController.text.isNotEmpty &&
        newPasswordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty) {
      if (newPasswordController.text == confirmPasswordController.text) {
        isLoading.value = true;
        try {
          String email = auth.currentUser!.email!;
          //check current password
          await auth.signInWithEmailAndPassword(
              email: email, password: currentPasswordController.text);
          //update password
          await auth.currentUser!.updatePassword(newPasswordController.text);
          //logout then login with new password
          await auth.signOut();
          await auth.signInWithEmailAndPassword(
              email: email, password: newPasswordController.text);
          Get.back();
          Get.snackbar('Success !', 'Password berhasil diubah');
        } on FirebaseAuthException catch (e) {
          if (e.code == "wrong-password") {
            Get.snackbar('Error', 'Password sekarang salah',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white);
          } else {
            Get.snackbar('Error', 'Error ${e.code}',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white);
          }
        } catch (e) {
          Get.snackbar('Error', 'Terjadi kesalahan, silahkan coba lagi',
              backgroundColor: Colors.red);
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar('Error', 'Password tidak sama');
      }
    } else {
      Get.snackbar("Oops !", "Semua field harus diisi");
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
