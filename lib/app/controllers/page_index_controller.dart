import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> changePage(int index) async {
    switch (index) {
      case 1:
        await getCurrentPosition();
        break;
      case 2:
        pageIndex.value = index;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = index;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> getCurrentPosition() async {
    Map<String, dynamic> response = await determinePosition();
    if (!response["error"]) {
      Position position = response["position"];
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      String address =
          "${placemarks[0].name} , ${placemarks[0].subLocality}, ${placemarks[0].locality}";
      await updateLocation(position, address);

      double distance = Geolocator.distanceBetween(
          -7.493041, 110.227166, position.latitude, position.longitude);

      await savePresence(position, address, distance);
      // Get.snackbar(response["message"], address);
    } else {
      Get.snackbar("Error", response["message"]);
    }
  }

  Future<void> savePresence(
      Position position, String address, double distance) async {
    String uid = await auth.currentUser!.uid;
    CollectionReference<Map<String, dynamic>> presenceCollection =
        await firestore.collection("users").doc(uid).collection("presences");
    QuerySnapshot<Map<String, dynamic>> data = await presenceCollection.get();
    String today = DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");
    String status = "In Area";
    if (distance > 200) status = "Out of Area";

    //presence collection isEmpty
    if (data.docs.isEmpty) {
      await Get.defaultDialog(
        title: "Validasi Presensi",
        middleText: "Apakah anda ingin presensi Masuk ?",
        actions: [
          OutlinedButton(child: Text("Tidak"), onPressed: () => Get.back()),
          ElevatedButton(
              child: Text("Ya"),
              onPressed: () async {
                await presenceCollection.doc(today).set({
                  "date": DateTime.now().toIso8601String(),
                  "check-in": {
                    "date": DateTime.now().toIso8601String(),
                    "latitude": position.latitude,
                    "longitude": position.longitude,
                    "address": address,
                    "status": status,
                    "distance": distance,
                  }
                });
                Get.back();
                Get.snackbar("Success", address);
              }),
        ],
      );
    } else {
      //presence collection is not empty
      DocumentSnapshot<Map<String, dynamic>> todayPresenceData =
          await presenceCollection.doc(today).get();
      //presence data today is not empty
      if (todayPresenceData.exists) {
        Map<String, dynamic>? dataMapToday = todayPresenceData.data();
        //has checkin and checkout
        if (dataMapToday?["check-out"] != null) {
          Get.snackbar("Succes", "You have already checked out");
        } else {
          // checkout only
          await Get.defaultDialog(
            title: "Validate Presence",
            middleText: "Do you have to presence Out ?",
            actions: [
              OutlinedButton(child: Text("Tidak"), onPressed: () => Get.back()),
              ElevatedButton(
                  child: Text("Ya"),
                  onPressed: () async {
                    await presenceCollection.doc(today).update({
                      "check-out": {
                        "date": DateTime.now().toIso8601String(),
                        "latitude": position.latitude,
                        "longitude": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      }
                    });
                    Get.back();
                    Get.snackbar("Success", address);
                  }),
            ],
          );
        }
      } else {
        //presence data today is empty
        await Get.defaultDialog(
          title: "Validate Presence",
          middleText: "Do you have to presence in ?",
          actions: [
            OutlinedButton(child: Text("Tidak"), onPressed: () => Get.back()),
            ElevatedButton(
                child: Text("Ya"),
                onPressed: () async {
                  await presenceCollection.doc(today).set({
                    "date": DateTime.now().toIso8601String(),
                    "check-in": {
                      "date": DateTime.now().toIso8601String(),
                      "latitude": position.latitude,
                      "longitude": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    }
                  });
                  Get.back();
                  Get.snackbar("Success", address);
                }),
          ],
        );
      }
    }
  }

  Future<void> updateLocation(Position position, String address) async {
    String uid = auth.currentUser!.uid;
    firestore.collection("users").doc(uid).update({
      "position": {
        "latitude": position.latitude,
        "longitude": position.longitude,
      },
      "address": address
    });
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return {
        "message":
            "Location service is not available, turn on your GPS and try again",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return {
          "message": "Location permission is denied, change your GPS setting",
          "error": true,
        };
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return {
        "message": "Permission is denied permanent, change your GPS setting",
        "error": true,
      };
    }

    Position position = await Geolocator.getCurrentPosition();

    return {
      "position": position,
      "message": "Success",
      "error": false,
    };
  }
}
