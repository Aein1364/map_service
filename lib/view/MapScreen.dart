// ignore_for_file: file_names, must_be_immutable

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/Variables.dart';
import '../components/TextStyle.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import '../components/widgets.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController mapController = MapController(
    initMapWithUserPosition: true,
  );

  RxString distance = 'در حال محاسبه مسافت ...'.obs;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        //button for next step
        floatingActionButton: MyFloatingActionButton(
          mapController: mapController,
          geoPoints: geoPoints,
          selectedIndex: selectedIndex,
          distance: distance,
        ),
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
                    iconWidget: Obx(() => markerIcons[selectedIndex.value]),
                  ),
                ),
              ),
            ),
            //back button
            MyBackButton(
                selectedIndex: selectedIndex,
                mapController: mapController,
                geoPoints: geoPoints,
                distance: distance),

            Obx(
              // distance and address container
              () => Positioned(
                bottom: Get.height * 0.1,
                left: Get.width * 0.05,
                right: Get.width * 0.05,
                child: selectedIndex.value == routingState.length - 1
                    ? Column(
                        children: [
                          distanceAddressContainer(
                              title: distance.value,
                              icon: Icons.social_distance_rounded),
                          const SizedBox(
                            height: 10,
                          ),
                          distanceAddressContainer(
                              title: origin.value, icon: Icons.square_outlined),
                          const SizedBox(
                            height: 10,
                          ),
                          distanceAddressContainer(
                              title: destination.value,
                              icon: Icons.square_outlined),
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

  Widget distanceAddressContainer(
      {required String title, required IconData icon}) {
    return Container(
      width: Get.width,
      height: Get.height * .075,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: .75),
          borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.green,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style:
                  MyTextStyle.button.copyWith(color: Colors.grey, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
