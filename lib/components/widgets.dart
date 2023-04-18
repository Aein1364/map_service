import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:map_service/components/TextStyle.dart';
import 'Variables.dart';

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

class MyFloatingActionButton extends StatelessWidget {
  const MyFloatingActionButton({
    super.key,
    required this.mapController,
    required this.geoPoints,
    required this.selectedIndex,
    required this.distance,
  });

  final MapController mapController;
  final List<GeoPoint> geoPoints;
  final RxInt selectedIndex;
  final RxString distance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.9,
      height: Get.height * 0.07,
      child: Obx(
        () => FloatingActionButton(
          onPressed: () async {
            selectedIndex.value++;
            if (selectedIndex.value > routingState.length - 1) {
              selectedIndex.value = routingState.length - 1;
            }
            if (selectedIndex.value < routingState.length - 1) {
              mapController.init();
            }
            await mapController
                .getCurrentPositionAdvancedPositionPicker()
                .then((value) => geoPoints.add(value));
            if (selectedIndex.value == routingState.length - 1) {
              await mapController.zoomOut();
              mapController.cancelAdvancedPositionPicker();

              await mapController.addMarker(geoPoints.last,
                  markerIcon: MarkerIcon(
                    iconWidget: markerIcons[1],
                  ));
              await mapController.addMarker(geoPoints.first,
                  markerIcon: MarkerIcon(
                    iconWidget: markerIcons[0],
                  ));
            }
            distance2point(geoPoints.first, geoPoints.last).then((value) {
              if (value < 1000) {
                distance.value =
                    'فاصله مبدا تا مقصد ${value.toInt().toString()} متر';
              } else {
                distance.value =
                    'فاصله مبدا تا مقصد ${(value / 1000).toStringAsFixed(1)} کیلومتر';
              }
            });
            getAddress();
          },
          backgroundColor: const Color.fromARGB(255, 2, 207, 36),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
            routingState[selectedIndex.value],
            style: MyTextStyle.button,
          ),
        ),
      ),
    );
  }

  getAddress() async {
    try {
      await placemarkFromCoordinates(
              geoPoints.first.latitude, geoPoints.first.longitude,
              localeIdentifier: 'fa')
          .then((List<Placemark> pList) {
        origin.value =
            'آدرس مبدا :  ${pList.first.locality} ${pList.first.thoroughfare} ${pList[2].name}';
      });
      await placemarkFromCoordinates(
              geoPoints.last.latitude, geoPoints.last.longitude,
              localeIdentifier: 'fa')
          .then((List<Placemark> pList) {
        destination.value =
            'آدرس مقصد : ${pList.first.locality} ${pList.first.thoroughfare} ${pList[2].name}';
      });
    } catch (e) {
      origin.value = 'آدرس یافت نشد';
      destination.value = 'آدرس یافت نشد';
    }
  }
}
