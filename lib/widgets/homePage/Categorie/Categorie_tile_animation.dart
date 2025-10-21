
import 'package:animations/animations.dart';
import 'package:eyav2/app_theme.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/widgets/homePage/Voitures/Vehicule_by_categorie.dart';
import 'package:flutter/material.dart';

class CategorieTileAnimation extends StatelessWidget {
  final int itemNo;
  final Category category;

  const CategorieTileAnimation({this.itemNo = 0, required this.category});

  @override
  Widget build(BuildContext context) {
    ContainerTransitionType _transitionType = ContainerTransitionType.fade;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OpenContainer<bool>(
        transitionType: _transitionType,
        openBuilder: (BuildContext _, VoidCallback openContainer) {
          return Vehicule_by_categorie(
            category_id: category.id,
              category_name:category.category_name
          );
        },
        closedShape: const RoundedRectangleBorder(),
        closedElevation: 0.0,
        closedBuilder: (BuildContext _, VoidCallback openContainer) {
          return Container(
            //width: MediaQuery.of(context).size.width * 0.45,
            decoration: BoxDecoration(
              color: AppTheme.of(context).secondaryBackground,
              boxShadow: [
                BoxShadow(
                  blurRadius: 50,
                  color: Color(0x3600000F),
                  offset: Offset(0, 2),
                )
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child:
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          child: Image.network(
                            "https://otrade-company.com/storage/app/public/Categorie_${category.id}/${category.category_photo}.png",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),),


                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                          child: Text(
                            category.category_name,
                            style: TextStyle(fontSize: 10)//AppTheme.of(context).bodyText1,

                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                          child:Row(
                            children: [
                              Text("Prix :",
                                style: TextStyle(fontSize: 13,color: Colors.black),
                              ),
                              Text(category.category_tarif_apd,
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          )


                        ),
                      ],
                    ),
                  ),
                /*  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
                          child:Row(
                            children: [
                              Text("Tél :",
                                style: TextStyle(fontSize: 13),
                              ),

                              Text(urgence.telephone,
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          )
                        ),
                      ],
                    ),
                  ),*/
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
