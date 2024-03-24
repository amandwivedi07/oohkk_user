import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;

import 'package:get/get.dart';
import 'package:getitgouser/main.dart';

import 'package:getitgouser/modules/auth/controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapHomeWidget extends StatefulWidget {
  const MapHomeWidget({super.key});

  @override
  State<MapHomeWidget> createState() => MapHomeWidgetState();
}

final AuthController authController = Get.find();

class MapHomeWidgetState extends State<MapHomeWidget> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(authController.userCurrentLatitude ?? 37.42796133580664,
        authController.userCurrentLongitude ?? -122.085749655962),
    zoom: 14.4746,
  );
  final Location _location = Location();
  LatLng? _currentLocation;
  String? _currentAddress;
  Set<Marker> _markers = {};
  @override
  void initState() {
    super.initState();
    _location.onLocationChanged.listen((LocationData locationData) async {
      setState(() {
        _currentLocation =
            LatLng(locationData.latitude!, locationData.longitude!);
      });

      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );

      if (placemarks != null && placemarks.isNotEmpty) {
        setState(() {
          _currentAddress =
              "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].postalCode}";
        });
      }
    });
    _addUserMarker(LatLng(
        authController.userCurrentLatitude ?? 37.42796133580664,
        authController.userCurrentLongitude ?? -122.085749655962));
  }

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(authController.userCurrentLatitude ?? 37.42796133580664,
          authController.userCurrentLongitude ?? -122.085749655962),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          markers: _markers,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          onCameraMove: (CameraPosition position) async {
            // Handle camera movement here
            // You can access the current camera position via 'position'

            // Update _currentLocation with the new camera position
            _currentLocation = position.target;

            // Reverse geocode the new coordinates to get the address
            List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
              _currentLocation!.latitude,
              _currentLocation!.longitude,
            );
            _updateUserMarkerLocation(_currentLocation!);

            if (placemarks.isNotEmpty) {
              setState(() {
                _currentAddress =
                    "${placemarks[0].name}, ${placemarks[0].locality}, ${placemarks[0].postalCode}";
              });
            }
          },
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      scaffoldKey.currentState?.openDrawer();
                    },
                    child: const Icon(
                      Icons.menu,
                      size: 32,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 45,
                    width: Get.width - 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 2,
                              spreadRadius: 0,
                              color: Colors.grey)
                        ]),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(_currentAddress ?? 'Loading...',
                            style: GoogleFonts.poppins()), // TextFormField(
                        //   decoration: InputDecoration(
                        //     hintText: 'Current location',
                        //     hintStyle: GoogleFonts.poppins(),
                        // border: InputBorder.none,
                        //   ),
                        // ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  void _addUserMarker(LatLng location) {
    final markerId = MarkerId('userLocation');
    final marker = Marker(
      markerId: markerId,
      position: location,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      // You can customize the marker icon as needed
      infoWindow: InfoWindow(title: 'Your Location'),
    );

    setState(() {
      _markers.add(marker); // Use 'add' to add the marker to the set
    });
  }

  void _updateUserMarkerLocation(LatLng newLocation) {
    final MarkerId markerId = MarkerId('userLocation');

    final updatedMarker = Marker(
      markerId: markerId,
      position: newLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: const InfoWindow(title: 'Your Location'),
    );

    setState(() {
      _markers.removeWhere((marker) => marker.markerId == markerId);
      _markers.add(updatedMarker);
    });
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
