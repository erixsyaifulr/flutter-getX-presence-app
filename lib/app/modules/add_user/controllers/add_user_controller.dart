import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUserController extends GetxController {
  final nipController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final jobController = TextEditingController();
  final passwordController = TextEditingController();
  final adminPasswordController = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addUser() async {
    if (nameController.text.isNotEmpty &&
        nipController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        jobController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      Get.defaultDialog(
        title: "Validasi admin",
        content: Column(
          children: [
            Text("Masukkan password anda untuk validasi admin !"),
            SizedBox(height: 10),
            TextField(
              autocorrect: false,
              controller: adminPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
              onPressed: () => Get.back(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Cancel"),
                ],
              )),
          Obx(
            () => ElevatedButton(
              onPressed: () {
                if (isLoading.isFalse)
                  registerProcess(
                      emailController.text, passwordController.text);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isLoading.isTrue
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : SizedBox(),
                  SizedBox(width: 10),
                  Text(isLoading.isTrue ? 'Loading...' : "Next"),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      Get.snackbar("Oops !", "Semua data harus diisi !");
    }
  }

  Future<void> registerProcess(String emailAddress, password) async {
    if (adminPasswordController.text.isNotEmpty) {
      isLoading.value = true;
      try {
        //get email admin before create user
        String emailAdmin = auth.currentUser!.email!;
        await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: adminPasswordController.text);

        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
        saveUserToFireStore(userCredential, emailAdmin);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar("Oops !", "Password terlalu lemah !");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Oops !", "Email sudah pernah terdaftar !");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Oops !", "Password salah !");
        }
      } catch (e) {
        Get.snackbar("Server Error !", "$e");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Oops !", "Password admin tidak boleh kosong !");
    }
  }

  saveUserToFireStore(UserCredential userCredential, String emailAdmin) async {
    if (userCredential.user != null) {
      String uid = userCredential.user!.uid;
      await firestore.collection('users').doc(uid).set({
        'nip': nipController.text,
        'name': nameController.text,
        'email': emailController.text,
        'job': jobController.text,
        'uid': uid,
        'role': "user",
        'created_at': DateTime.now().toIso8601String(),
      });
      await userCredential.user!.sendEmailVerification();
      //because of the bug in firebase, we need to sign out last user added
      await auth.signOut();

      //reloggin the admin
      await auth.signInWithEmailAndPassword(
          email: emailAdmin, password: adminPasswordController.text);
      isLoading.value = false;
      Get.back();
      Get.back();
      Get.snackbar("Success !", "User berhasil ditambahkan !");
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
