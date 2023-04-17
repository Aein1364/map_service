import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({
    super.key,
    required this.selectedIndex,
  });

  final RxInt selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      child: GestureDetector(
        onTap: () {
          selectedIndex.value--;
          if (selectedIndex.value < 0) {
            selectedIndex.value = 0;
          }
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(2, 3),
                  blurRadius: 18,
                )
              ]),
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }
}

List<Widget> mapStateList = [
  Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.blue,
  ),
  Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.red,
  ),
  Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.amber,
  ),
];

List<String> bottunTitle = [
  'انتخاب مبدا',
  'انتخاب مقصد',
  'درخواست راننده',
];
