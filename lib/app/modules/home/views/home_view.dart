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
        title: Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => Get.toNamed(Routes.PROFILE),
          ),
        ],
      );
    }

    Widget profilePhoto() {
      return Row(
        children: [
          ClipOval(
            child: Container(
              width: 75,
              height: 75,
              color: Colors.grey[200],
              // child: Image.network(src),
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
              Text("Jl Beringin III"),
            ],
          )
        ],
      );
    }

    Widget profileInformation() {
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
              "Developer",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "161051050",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Erix Syaiful Rohman",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      );
    }

    Widget presenceInformation() {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text("Masuk"),
                SizedBox(height: 5),
                Text("-"),
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
                Text("-"),
              ],
            ),
          ],
        ),
      );
    }

    Widget presenceHistoryLabel() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Last 5 Days"),
          TextButton(
            onPressed: () {},
            child: Text("See More"),
          ),
        ],
      );
    }

    Widget presenceHistory() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Masuk"),
                    Text("${DateFormat.yMMMEd().format(DateTime.now())}"),
                  ],
                ),
                SizedBox(height: 5),
                Text("${DateFormat.Hms().format(DateTime.now())}"),
                SizedBox(height: 10),
                Text("Keluar"),
                SizedBox(height: 5),
                Text("${DateFormat.Hms().format(DateTime.now())}"),
              ],
            ),
          );
        },
      );
    }

    Widget body() {
      return ListView(
        padding: EdgeInsets.all(20),
        children: [
          profilePhoto(),
          SizedBox(height: 20),
          profileInformation(),
          SizedBox(height: 20),
          presenceInformation(),
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
