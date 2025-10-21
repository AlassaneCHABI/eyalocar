import 'dart:math';

import 'package:eyav2/widgets/homePage/Voitures/details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';

Padding buildCar(int i, Size size, bool isDarkMode, data) {
  return Padding(
    padding: EdgeInsets.only(
      right: size.width * 0.03,
    ),
    child: Center(
      child: SizedBox(
        height: size.width * 0.55,
        width: size.width * 0.5,
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: const BorderRadius.all(
              Radius.circular(
                20,
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.02,
            ),
            child: InkWell(
              onTap: () {
                Get.to(DetailsPage(
                  car_name: data.docs[i]['car_name'],
                  car_features: data.docs[i]['car_features'],
                  car_status: data.docs[i]['car_status'],
                  car_price: data.docs[i]['car_price'],
                  category_name: data.docs[i]['category_name'],
                  car_exterior_img: data.docs[i]['car_exterior_img'],
                  car_interior_img: data.docs[i]['car_interior_img'],
                  car_rear_img: data.docs[i]['car_rear_img'],
                  car_front_img: data.docs[i]['car_front_img'],
                  car_reg_no: data.docs[i]['car_reg_no'],
                ));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.01,
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: /*data.docs[i]['isRotated']
                          ? Image.network(
                              data.docs[i]['carImage'],
                              height: size.width * 0.25,
                              width: size.width * 0.5,
                              fit: BoxFit.contain,
                            )
                          : */Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(pi),
                              child: Image.network(
                                data[i]['car_exterior_img'],
                                height: size.width * 0.25,
                                width: size.width * 0.5,
                                fit: BoxFit.contain,
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height * 0.01,
                    ),
                    child: Text(
                      data.docs[i]['category_name'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color:
                            isDarkMode ? Colors.white : const Color(0xff3b22a1),
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    data.docs[i]['car_name'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color:
                          isDarkMode ? Colors.white : const Color(0xff3b22a1),
                      fontSize: size.width * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${data.docs[i]['car_price']}\$',
                        style: GoogleFonts.poppins(
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xff3b22a1),
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/per day',
                        style: GoogleFonts.poppins(
                          color: isDarkMode
                              ? Colors.white.withOpacity(0.8)
                              : Colors.black.withOpacity(0.8),
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                          right: size.width * 0.025,
                        ),
                        child: SizedBox(
                          height: size.width * 0.1,
                          width: size.width * 0.1,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xff3b22a1),
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                            ),
                            child: const Icon(
                              UniconsLine.credit_card,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
