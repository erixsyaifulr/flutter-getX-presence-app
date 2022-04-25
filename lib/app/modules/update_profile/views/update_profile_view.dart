import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/update_profile_controller.dart';

class UpdateProfileView extends GetView<UpdateProfileController> {
  final Map<String, dynamic> user = Get.arguments;
  @override
  Widget build(BuildContext context) {
    controller.nipController.text = user['nip'];
    controller.nameController.text = user['name'];
    controller.emailController.text = user['email'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            readOnly: true,
            controller: controller.nipController,
            decoration: InputDecoration(
              labelText: 'NIP',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            readOnly: true,
            controller: controller.emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            autocorrect: false,
            controller: controller.nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Profile Picture",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GetBuilder<UpdateProfileController>(builder: (c) {
                if (c.image != null) {
                  return Container(
                    width: 150,
                    height: 150,
                    child: Image.file(
                      File(c.image!.path),
                      fit: BoxFit.cover,
                    ),
                  );
                } else {
                  if (user["profile_photo"] != null) {
                    return Column(
                      children: [
                        ClipOval(
                          child: Image.network(
                            user["profile_photo"],
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ),
                        ),
                        TextButton(
                            onPressed: () =>
                                controller.deleteProfile(user["uid"]),
                            child: Text('Delete Profile Picture')),
                      ],
                    );
                  } else {
                    return Text("No Image Choosen");
                  }
                }
              }),
              TextButton(
                  onPressed: () {
                    controller.pickImage();
                  },
                  child: Text("Choose Image")),
            ],
          ),
          SizedBox(height: 20),
          Obx(() => ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.isLoading.isTrue
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : SizedBox(),
                    Text(controller.isLoading.isTrue ? 'Loading...' : 'Save'),
                  ],
                ),
                onPressed: () {
                  if (controller.isLoading.isFalse)
                    controller.updateProfile(user['uid']);
                },
              )),
        ],
      ),
    );
  }
}
