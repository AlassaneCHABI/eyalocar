import 'dart:async';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';
import 'package:eyav2/pages/maps.dart';

class DetailsPage extends StatefulWidget {
  final String car_name;
  final String car_features;
  final String car_status;
  final int car_price;
  final String category_name;
  final String car_exterior_img;
  final String car_interior_img;
  final String car_rear_img;
  final String car_front_img;
  final String car_reg_no;

  const DetailsPage({
    Key? key,
    required this.car_name,
    required this.car_features,
    required this.car_status,
    required this.car_price,
    required this.category_name,
    required this.car_exterior_img,
    required this.car_interior_img,
    required this.car_rear_img,
    required this.car_front_img,
    required this.car_reg_no,
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = LatLng(50.470685, 19.070234);
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //check the size of device
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness ==
        Brightness.dark; //check if device is in dark or light mode

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0), //appbar size
        child: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          shadowColor: Colors.transparent,
          backgroundColor: isDarkMode
              ? const Color(0xff06090d)
              : const Color(0xfff8f8f8), //appbar bg color

          leading: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.05,
            ),
            child: SizedBox(
              height: size.width * 0.1,
              width: size.width * 0.1,
              child: InkWell(
                onTap: () {
                  Get.back(); //go back to home page
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? const Color(0xff070606)
                        : Colors.white, //icon bg color
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Icon(
                    UniconsLine.multiply,
                    color: isDarkMode ? Colors.white : const Color(0xff3b22a1),
                    size: size.height * 0.025,
                  ),
                ),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leadingWidth: size.width * 0.15,
          title: Image.asset(
            isDarkMode
                ? 'assets/logo_horizontal-remove.png'
                : 'assets/logo_horizontal-remove.png',
            height: size.height * 0.06,
            width: size.width * 0.35,
          ),
          centerTitle: true,
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Center(
        child: Container(
          height: size.height,
          width: size.height,
          decoration: BoxDecoration(
            color: isDarkMode
                ? const Color(0xff06090d)
                : const Color(0xfff8f8f8), //background color
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
              ),
              child: Stack(
                children: [
                  ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      /*widget.isRotated
                          ? Image.network(
                              widget.carImage,
                              height: size.width * 0.5,
                              width: size.width * 0.8,
                              fit: BoxFit.contain,
                            )
                          : */Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(pi),
                              child: Image.network(
                                'https://otrade-company.com/storage/app/public/Car_157/${widget.car_exterior_img}.jpg',
                                height: size.width * 0.5,
                                width: size.width * 0.8,
                                fit: BoxFit.contain,
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category_name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xff3b22a1),
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.star,
                            color: Colors.yellow[800],
                            size: size.width * 0.06,
                          ),
                          Text(
                            widget.car_name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.yellow[800],
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            widget.car_name,
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xff3b22a1),
                              fontSize: size.width * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${widget.car_price}\fcfa',
                            style: GoogleFonts.poppins(
                              color: isDarkMode
                                  ? Colors.white
                                  : const Color(0xff3b22a1),
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '/Par jour',
                            style: GoogleFonts.poppins(
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.black.withOpacity(0.8),
                              fontSize: size.width * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: size.height * 0.02,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildStat(
                              UniconsLine.dashboard,
                              ' KM',
                              '155',
                              size,
                              isDarkMode,
                            ),
                            buildStat(
                              UniconsLine.users_alt,
                              'Homme',
                              '( 2 )',
                              size,
                              isDarkMode,
                            ),
                            buildStat(
                              UniconsLine.briefcase,
                              'Valise',
                              '( 2 )',
                              size,
                              isDarkMode,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.03,
                        ),
                        child: Text(
                          'Localisation du vehicule',
                          style: GoogleFonts.poppins(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xff3b22a1),
                            fontSize: size.width * 0.055,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: size.height * 0.15,
                          width: size.width * 0.9,
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.white,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.05,
                                    vertical: size.height * 0.015,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        UniconsLine.map_marker,
                                        color: const Color(0xff3b22a1),
                                        size: size.height * 0.05,
                                      ),
                                      Text(
                                        "Calavi",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: isDarkMode
                                              ? Colors.white
                                              : const Color(0xff3b22a1),
                                          fontSize: size.width * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Zogbadjè',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: isDarkMode
                                              ? Colors.white.withOpacity(0.7)
                                              : Colors.black.withOpacity(0.7),
                                          fontSize: size.width * 0.032,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * 0.17,
                                  width: size.width * 0.29,
                                  child: GoogleMap(
                                    mapType: MapType.hybrid,
                                    onMapCreated: _onMapCreated,
                                    initialCameraPosition: const CameraPosition(
                                      target: _center,
                                      zoom: 13.0,
                                    ),
                                    onTap: (latLng) => Get.to(Maps()),
                                    zoomControlsEnabled: false,
                                    scrollGesturesEnabled: true,
                                    zoomGesturesEnabled: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  buildSelectButton(size, isDarkMode),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding buildStat(
      IconData icon, String title, String desc, Size size, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.015,
      ),
      child: SizedBox(
        height: size.width * 0.35,
        width: size.width * 0.25,
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                10,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              top: size.width * 0.03,
              left: size.width * 0.03,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: const Color(0xff3b22a1),
                  size: size.width * 0.08,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.width * 0.02,
                  ),
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  desc,
                  style: GoogleFonts.poppins(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.7)
                        : Colors.black.withOpacity(0.7),
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Align buildSelectButton(Size size, bool isDarkMode) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: EdgeInsets.only(
        bottom: size.height * 0.01,
      ),
      child: SizedBox(
        height: size.height * 0.07,
        width: size.width,
        child: InkWell(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color(0xff3b22a1),
            ),
            child: Align(
              child: Text(
                'Select',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: size.height * 0.025,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
