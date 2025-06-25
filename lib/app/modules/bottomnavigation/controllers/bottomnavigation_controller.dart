import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pos/app/data/home_provider.dart';
import 'package:pos/app/data/models/user.dart';

class BottomnavigationController extends GetxController {
  var currentIndex = 0.obs;
  var latitude = 'Getting Latitude..'.obs;
  var longitude = 'Getting Longitude..'.obs;
  var address = ''.obs;
  var user = Rxn<User>();
  late StreamSubscription<Position> streamSubscription;

  var tabIndex = 0.obs;

  void changeTabindex(int index) {
    tabIndex.value = index;
    update();
  }

  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getLocation();
    loadUser();
  }

  @override
  void onClose() {
    streamSubscription.cancel();
    super.onClose();
  }

  Future<void> loadUser() async {
    try {
      HomeProvider().getUser().then((user) {
        this.user.value = user;
      });
    } catch (e) {
      if (kDebugMode) {
        print("❌ Gagal ambil user: $e");
      }
    }
  }

  Future<void> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    streamSubscription = Geolocator.getPositionStream().listen((
      Position position,
    ) {
      latitude.value = 'Latitude : ${position.latitude}';
      longitude.value = 'Longitude : ${position.longitude}';
      getAddressFromLatLang(position);
    });
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    Placemark place = placemarks[0];
    address.value = '${place.subLocality}';
  }
}
