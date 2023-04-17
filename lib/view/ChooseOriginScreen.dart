// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/MyComponent.dart';
import '../components/TextStyle.dart';

class ChooseOriginScreen extends StatelessWidget {
  ChooseOriginScreen({super.key});
  RxInt selectedIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          //button for next step
          floatingActionButton: SizedBox(
            width: Get.width * 0.9,
            height: Get.height * 0.07,
            child: FloatingActionButton(
              onPressed: () {
                selectedIndex.value++;
                if (selectedIndex.value > mapStateList.length - 1) {
                  selectedIndex.value = mapStateList.length - 1;
                }
              },
              backgroundColor: const Color.fromARGB(255, 2, 207, 36),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                bottunTitle[selectedIndex.value],
                style: MyTextStyle.bottun,
              ),
            ),
          ),
          body: Stack(
            children: [
              //map screen
              mapStateList[selectedIndex.value],
              //back button
              MyBackButton(selectedIndex: selectedIndex)
            ],
          ),
        ),
      ),
    );
  }
}
