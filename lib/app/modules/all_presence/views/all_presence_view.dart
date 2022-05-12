import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../routes/app_pages.dart';
import '../controllers/all_presence_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AllPresenceView extends GetView<AllPresenceController> {
  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget appBar() {
      return AppBar(
        title: Text('All Presence'),
        centerTitle: true,
      );
    }

    Widget presenceHistory() {
      return GetBuilder<AllPresenceController>(builder: (c) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () {
                  Get.dialog(Dialog(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      height: 400,
                      child: SfDateRangePicker(
                        selectionMode: DateRangePickerSelectionMode.range,
                        showActionButtons: true,
                        onCancel: () => Get.back(),
                        onSubmit: (object) {
                          if (object != null &&
                              (object as PickerDateRange).endDate != null) {
                            c.pickDate(object.startDate!, object.endDate!);
                            Get.back();
                          } else {
                            Get.back();
                          }
                        },
                      ),
                    ),
                  ));
                },
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "Filter",
                      enabled: false,
                      prefixIcon: Icon(Icons.filter_list),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: controller.streamAllPresence(),
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
                    padding: EdgeInsets.symmetric(horizontal: 20),
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
                              Get.toNamed(Routes.DETAIL_PRESENCE,
                                  arguments: data);
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Check In"),
                                      Text(
                                          "${DateFormat.yMMMEd().format(DateTime.parse(data["date"]))}"),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                      "${data["check-in"]?["date"] == null ? "-" : DateFormat.Hms().format(
                                          DateTime.parse(
                                              data["check-in"]!["date"]),
                                        )}"),
                                  SizedBox(height: 10),
                                  Text("Check Out"),
                                  SizedBox(height: 5),
                                  Text(
                                      "${data["check-out"]?["date"] == null ? "-" : DateFormat.Hms().format(
                                          DateTime.parse(
                                              data["check-out"]!["date"]),
                                        )}"),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      });
    }

    return Scaffold(
      appBar: appBar(),
      body: presenceHistory(),
    );
  }
}
