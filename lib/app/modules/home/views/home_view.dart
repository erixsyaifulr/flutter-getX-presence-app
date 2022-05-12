import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence_app/app/controllers/page_index_controller.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar() {
      return AppBar(
        title: Text('Home'),
        centerTitle: true,
      );
    }

    Widget profilePhoto(Map<String, dynamic> data) {
      return Row(
        children: [
          ClipOval(
            child: Container(
              width: 75,
              height: 75,
              color: Colors.grey[200],
              child: Image.network(
                data["profile_photo"] ??
                    "https://ui-avatars.com/api/?background=random&name=${data['name']}",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 5),
              Container(
                width: 250,
                child: Text(data['address'] ?? "Lokasi belum terdeteksi"),
              ),
            ],
          )
        ],
      );
    }

    Widget profileInformation(Map<String, dynamic> data) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${data['job']}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "${data['nip']}",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "${data['name']}",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    Widget presenceInformation(Map<String, dynamic> data) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamTodayPresence(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            Map<String, dynamic>? dataToday = snapshot.data?.data();
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text("Masuk"),
                    SizedBox(height: 5),
                    Text(dataToday?["check-in"] == null
                        ? "-"
                        : "${DateFormat.jms().format(DateTime.parse(dataToday!['check-in']['date']))}"),
                  ],
                ),
                Container(
                  height: 30,
                  width: 2,
                  color: Colors.grey,
                ),
                Column(
                  children: [
                    Text("Keluar"),
                    SizedBox(height: 5),
                    Text(dataToday?["check-out"] == null
                        ? "-"
                        : "${DateFormat.jms().format(DateTime.parse(dataToday!['check-out']['date']))}"),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }

    Widget presenceHistoryLabel() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Last 5 Days"),
          TextButton(
            onPressed: () {
              Get.toNamed(Routes.ALL_PRESENCE);
            },
            child: Text("See More"),
          ),
        ],
      );
    }

    Widget presenceHistory() {
      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: controller.streamLastPresence(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text("Presence history not found"),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    snapshot.data!.docs.reversed.toList()[index].data();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Material(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () {
                        Get.toNamed(Routes.DETAIL_PRESENCE, arguments: data);
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Check In"),
                                Text(
                                    "${DateFormat.yMMMEd().format(DateTime.parse(data["date"]))}"),
                              ],
                            ),
                            SizedBox(height: 5),
                            Text(
                                "${data["check-in"]?["date"] == null ? "-" : DateFormat.Hms().format(
                                    DateTime.parse(data["check-in"]!["date"]),
                                  )}"),
                            SizedBox(height: 10),
                            Text("Check Out"),
                            SizedBox(height: 5),
                            Text(
                                "${data["check-out"]?["date"] == null ? "-" : DateFormat.Hms().format(
                                    DateTime.parse(data["check-out"]!["date"]),
                                  )}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          });
    }

    Widget body() {
      return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamRole(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              Map<String, dynamic> user = snapshot.data!.data()!;
              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  profilePhoto(user),
                  SizedBox(height: 20),
                  profileInformation(user),
                  SizedBox(height: 20),
                  presenceInformation(user),
                  SizedBox(height: 20),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 2,
                  ),
                  SizedBox(height: 20),
                  presenceHistoryLabel(),
                  SizedBox(height: 20),
                  presenceHistory(),
                ],
              );
            } else {
              return Center(
                child: Text("No Data"),
              );
            }
          });
    }

    Widget bottomNavigationBar() {
      return ConvexAppBar(
        style: TabStyle.fixedCircle,
        items: [
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.fingerprint, title: 'Presence'),
          TabItem(icon: Icons.person, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: body(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }
}
