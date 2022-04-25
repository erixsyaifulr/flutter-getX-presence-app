import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:presence_app/app/routes/app_pages.dart';

import '../../../controllers/page_index_controller.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: controller.streamUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            Map<String, dynamic> user = snapshot.data!.data()!;
            return snapshot.hasData
                ? ListView(
                    padding: EdgeInsets.all(15),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Container(
                              width: 100,
                              height: 100,
                              child: Image.network(
                                user["profile_photo"] ??
                                    "https://ui-avatars.com/api/?background=random&name=${user['name']}",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${user['name'].toString().toUpperCase()}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${user['email']}",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Update Profile'),
                        onTap: () =>
                            Get.toNamed(Routes.UPDATE_PROFILE, arguments: user),
                      ),
                      ListTile(
                        leading: Icon(Icons.vpn_key),
                        title: Text('Update Password'),
                        onTap: () => Get.toNamed(Routes.UPDATE_PASSWORD),
                      ),
                      if (user['role'] == "admin")
                        ListTile(
                          leading: Icon(Icons.person_add),
                          title: Text('Add Uder'),
                          onTap: () => Get.toNamed(Routes.ADD_USER),
                        ),
                      ListTile(
                        leading: Icon(Icons.logout),
                        title: Text('Logout'),
                        onTap: () => controller.logout(),
                      ),
                    ],
                  )
                : Center(
                    child: Text("Data user tidak ditemukan"),
                  );
          },
        ),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixedCircle,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Presence'),
            TabItem(icon: Icons.person, title: 'Profile'),
          ],
          initialActiveIndex: pageC.pageIndex.value,
          onTap: (int i) => pageC.changePage(i),
        ));
  }
}
