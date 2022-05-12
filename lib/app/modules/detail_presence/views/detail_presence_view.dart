import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/detail_presence_controller.dart';

class DetailPresenceView extends GetView<DetailPresenceController> {
  final Map<String, dynamic> data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar() {
      return AppBar(
        title: Text('Detail Presence'),
        centerTitle: true,
      );
    }

    Widget body() {
      return ListView(
        padding: EdgeInsets.all(20),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey[200],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "${DateFormat.yMMMMEEEEd().format(DateTime.parse(data['date']))}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Masuk",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Jam"),
                    Text(data['check-in'] == null
                        ? "-"
                        : "${DateFormat.jms().format(DateTime.parse(data['check-in']['date']))}"),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Posisi"),
                    Text(data['check-in'] == null
                        ? "-"
                        : "${data['check-in']['longitude']}, ${data['check-in']['latitude']}"),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Alamat"),
                    SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        data['check-in'] == null
                            ? "-"
                            : "${data['check-in']['address']}",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Jarak"),
                    Text(data['check-in'] == null
                        ? "-"
                        : "${data['check-in']['distance'].toString().split(".").first} meter"),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Status"),
                    Text(data['check-in'] == null
                        ? "-"
                        : "${data['check-in']['status']}"),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Keluar",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Jam"),
                    Text(data['check-out'] == null
                        ? "-"
                        : "${DateFormat.jms().format(DateTime.parse(data['check-out']['date']))}"),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Posisi"),
                    Text(data['check-out'] == null
                        ? "-"
                        : "${data['check-out']['longitude']}, ${data['check-out']['latitude']}"),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Alamat"),
                    SizedBox(width: 50),
                    Expanded(
                      child: Text(
                        data['check-out'] == null
                            ? "-"
                            : "${data['check-out']['address']}",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Jarak"),
                    Text(data['check-out'] == null
                        ? "-"
                        : "${data['check-out']['distance'].toString().split(".").first} meter"),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Status"),
                    Text(data['check-out'] == null
                        ? "-"
                        : "${data['check-out']['status']}"),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: appBar(),
      body: body(),
    );
  }
}
