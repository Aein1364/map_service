// ignore_for_file: file_names, must_be_immutable

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/MyComponent.dart';
import '../components/TextStyle.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  RxInt selectedIndex = 0.obs;

  List<GeoPoint> geoPoints = [];

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
            distance: distance),
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
                child: selectedIndex.value == buttonTitles.length - 1
                    ? Column(
                        children: [
                          Container(
                            width: Get.width,
                            height: Get.height * .075,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.black, width: .75),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.social_distance_rounded,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    distance.value,
                                    style: MyTextStyle.bottun
                                        .copyWith(color: Colors.grey),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: Get.width,
                            height: Get.height * .075,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.black, width: .75),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.square_outlined,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'آدرس مقصد',
                                    style: MyTextStyle.bottun
                                        .copyWith(color: Colors.grey),
                                  )
                                ],
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
            if (selectedIndex.value > buttonTitles.length - 1) {
              selectedIndex.value = buttonTitles.length - 1;
            }
            if (selectedIndex.value < buttonTitles.length - 1) {
              mapController.init();
            }
            await mapController
                .getCurrentPositionAdvancedPositionPicker()
                .then((value) => geoPoints.add(value));
            if (selectedIndex.value == buttonTitles.length - 1) {
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
