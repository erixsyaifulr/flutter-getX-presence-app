import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/leave_controller.dart';

class LeaveView extends GetView<LeaveController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LeaveView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'LeaveView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
