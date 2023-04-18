// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';
import 'package:map_service/gen/assets.gen.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({
    super.key,
    required this.selectedIndex,
    required this.mapController,
    required this.geoPoints,
    required this.distance,
  });

  final RxInt selectedIndex;
  final MapController mapController;
  final List<GeoPoint> geoPoints;
  final RxString distance;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      child: GestureDetector(
        onTap: () async {
          mapController.init();
          distance.value = 'در حال محاسبه مسافت ...';
          if (geoPoints.isNotEmpty) {
            log(geoPoints.last.latitude.toString());
            mapController.removeMarker(geoPoints.last);
            geoPoints.removeLast();
          }

          --selectedIndex.value;
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
            Icons.arrow_forward_ios_rounded,
            color: Colors.black,
            size: 20,
          ),
        ),
      ),
    );
  }
}

List<String> buttonTitles = [
  'انتخاب مبدا',
  'انتخاب مقصد',
  'درخواست راننده',
];

List<Widget> markerIcons = [
  Assets.icons.origin.svg(height: 150, width: 60),
  Assets.icons.destination.svg(height: 150, width: 60),
  const SizedBox(
    width: 1,
    height: 1,
  )
];
