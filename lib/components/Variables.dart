// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

import '../gen/assets.gen.dart';

List<String> routingState = [
  'انتخاب مبدا',
  'انتخاب مقصد',
  'درخواست راننده',
];

List<Widget> markerIcons = [
  Assets.icons.origin.svg(height: 100, width: 40),
  Assets.icons.destination.svg(height: 100, width: 40),
  Container()
];
RxInt selectedIndex = 0.obs;
List<GeoPoint> geoPoints = [];
RxString origin = 'آدرس مبدا'.obs;
RxString destination = 'آدرس مقصد'.obs;
