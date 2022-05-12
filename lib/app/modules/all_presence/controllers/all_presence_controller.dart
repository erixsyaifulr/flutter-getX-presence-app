import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllPresenceController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  DateTime? startDate;
  DateTime endDate = DateTime.now();

  Future<QuerySnapshot<Map<String, dynamic>>> streamAllPresence() async {
    String uid = auth.currentUser!.uid;

    if (startDate == null) {
      return await firestore
          .collection("users")
          .doc(uid)
          .collection("presences")
          .where("date", isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy("date")
          .get();
    }

    return await firestore
        .collection("users")
        .doc(uid)
        .collection("presences")
        .where("date",
            isGreaterThanOrEqualTo: startDate!.toIso8601String(),
            isLessThanOrEqualTo:
                endDate.add(Duration(days: 1)).toIso8601String())
        .orderBy("date")
        .get();
  }

  void pickDate(DateTime start, DateTime end) {
    startDate = start;
    endDate = end;
    update();
  }
}
