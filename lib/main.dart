import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:map_service/view/MapScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      locale: Locale('fa', 'IR'),
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}
