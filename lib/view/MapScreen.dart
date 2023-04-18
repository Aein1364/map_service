// ignore_for_file: file_names, must_be_immutable
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/MyComponent.dart';
import '../components/TextStyle.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapScreen extends StatelessWidget {
  MapScreen({super.key});
  RxInt selectedIndex = 0.obs;
  List<GeoPoint> geoPoints = [];
  MapController mapController = MapController(
    initMapWithUserPosition: true,
    // initPosition: GeoPoint(latitude: 35.3080232175, longitude: 59.4986211973),
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        //button for next step
        floatingActionButton: MyFloatingActionButton(
            mapController: mapController,
            geoPoints: geoPoints,
            selectedIndex: selectedIndex),
        body: Stack(
          children: [
            //map screen
            SizedBox.expand(
              child: OSMFlutter(
                controller: mapController,
                trackMyPosition: false,
                initZoom: 15,
                isPicker: true,
                mapIsLoading:
                    const SpinKitCircle(color: Color.fromARGB(255, 0, 60, 108)),
                minZoomLevel: 8,
                maxZoomLevel: 18,
                stepZoom: 1,
                markerOption: MarkerOption(
                  advancedPickerMarker: MarkerIcon(
                    iconWidget: Obx(() => markerIcones[selectedIndex.value]),
                  ),
                ),
              ),
            ),
            //back button
            MyBackButton(
                selectedIndex: selectedIndex,
                mapController: mapController,
                geoPoints: geoPoints),

            Obx(
              () => Positioned(
                bottom: Get.height * 0.1,
                left: Get.width * 0.05,
                right: Get.width * 0.05,
                child: selectedIndex.value == buttonTitles.length - 1
                    ? Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'فاصله مبدا تا مقصد',
                                prefixIcon: const Icon(
                                  Icons.social_distance_rounded,
                                  color: Colors.green,
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'آدرس مقصد',
                              prefixIcon: const Icon(
                                Icons.square_outlined,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
            )
          ],
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
  });

  final MapController mapController;
  final List<GeoPoint> geoPoints;
  final RxInt selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.9,
      height: Get.height * 0.07,
      child: Obx(
        () => FloatingActionButton(
          onPressed: () async {
            GeoPoint chooseGeoPoint =
                await mapController.getCurrentPositionAdvancedPositionPicker();
            geoPoints.add(chooseGeoPoint);
            log(geoPoints.last.latitude.toString());
            mapController.init();
            selectedIndex.value++;
            if (selectedIndex.value > buttonTitles.length - 1) {
              selectedIndex.value = buttonTitles.length - 1;
            }
            log(selectedIndex.value.toString());
          },
          backgroundColor: const Color.fromARGB(255, 2, 207, 36),
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Text(
            buttonTitles[selectedIndex.value],
            style: MyTextStyle.bottun,
          ),
        ),
      ),
    );
  }
}
