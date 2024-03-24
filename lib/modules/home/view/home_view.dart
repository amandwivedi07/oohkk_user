import 'package:flutter/material.dart';

import 'package:getitgouser/main.dart';
import 'package:getitgouser/modules/home/widgets/google_maps_home.dart';
import 'package:getitgouser/modules/home/widgets/home_bottom_sheet.dart';
import 'package:getitgouser/modules/home/widgets/my_drawer.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: const MyHomeBottomSheet(),
      key: scaffoldKey,
      drawer: const MyDrawer(),
      body: const SafeArea(
        child: Stack(
          children: [
            MapHomeWidget(),
          ],
        ),
      ),
    );
  }
}
