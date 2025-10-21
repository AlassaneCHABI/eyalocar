import 'dart:math';

import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/widgets/homePage/Voitures/details_page.dart';
import 'package:eyav2/widgets/homePage/Voitures/Vehicule_by_categorie.dart';
import 'package:eyav2/widgets/homePage/brand_logo.dart';
import 'package:eyav2/widgets/homePage/car.dart';
import 'package:eyav2/widgets/homePage/Categorie/category.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';

import '../../../function/function.dart';

Widget Liste_Categorie(Size size, bool isDarkMode,BuildContext context) {
  //CollectionReference cars = FirebaseFirestore.instance.collection('cars');
  return Column(
    children: [
      buildCategory('Nos categories', size, isDarkMode,context),
      Padding(
        padding: EdgeInsets.only(
          top: size.height * 0.015,
          left: size.width * 0.03,
          right: size.width * 0.03,
        ),
        child: FutureBuilder<List<Category>>(
          future: getCategorie(),
          builder: (
              context, snapshot) {
            if (snapshot.hasError) {
              return const Text("Something went wrong");
            }
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data;
              return SizedBox(
                height: size.width * 0.5,
                width: snapshot.data!.length * size.width * 0.5 * 1.03,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: size.width * 0.03,
                      ),
                      child: Center(
                        child: SizedBox(
                          height: size.width * 0.40,
                          width: size.width * 0.3,
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
                               // left: size.width * 0.02,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      new MaterialPageRoute(builder: (ctxt) => new Vehicule_by_categorie(
                                        category_id: snapshot.data![i].id,
                                        category_name: snapshot.data![i].category_name,
                                      ))
                                  );

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
                                        child:
                                        buildBrandLogo(
                                          Image.network(
                                            'https://otrade-company.com/storage/app/public/Categorie_${snapshot.data![i].id}/${snapshot.data![i].category_photo}.png',
                                            height: size.width * 0.1,
                                            width: size.width * 0.15,
                                            fit: BoxFit.fill,
                                          ),
                                          size,
                                          isDarkMode,
                                        ),
                                       /* Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(pi),
                                          child: Image.network(
                                            'https://otrade-company.com/storage/app/public/Categorie_${snapshot.data![i].id}/${snapshot.data![i].category_photo}.png',
                                            //data[i]['car_exterior_img'],
                                            height: size.width * 0.5,
                                            width: size.width * 0.9,
                                            fit: BoxFit.contain,
                                          ),
                                        ),*/
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: size.height * 0.0,
                                      ),
                                      child:Center(
                                       child:   Text(
                                        snapshot.data![i].category_name,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color:
                                          isDarkMode ? Colors.white : const Color(0xff3b22a1),
                                          fontSize: size.width * 0.05,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                    ),
                              /*Text(
                                      snapshot.data![i].category_name,
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
                                          '${snapshot.data![i].car_price}',
                                          style: GoogleFonts.poppins(
                                            color: isDarkMode
                                                ? Colors.white
                                                : const Color(0xff3b22a1),
                                            fontSize: size.width * 0.06,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '/Par jour',
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
                                   */
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    ],
  );
}
