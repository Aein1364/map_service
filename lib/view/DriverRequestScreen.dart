import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

class DriverRequestScreen extends StatelessWidget {
  const DriverRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: SizedBox(
              width: Get.width * 0.9,
              height: Get.height * 0.1,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Color.fromARGB(255, 0, 255, 119),
                foregroundColor: Colors.white,
                child: Text(
                  'درخواست راننده',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.amber,
            )));
  }
}
