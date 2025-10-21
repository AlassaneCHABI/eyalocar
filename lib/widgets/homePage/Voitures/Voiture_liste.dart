
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/modeles/request_cars.dart';
import 'package:eyav2/widgets/homePage/Categorie/Categorie_tile_animation.dart';
import 'package:eyav2/widgets/homePage/Voitures/Categorie_tile_animation.dart';
import 'package:flutter/material.dart';

class VoitureList extends StatelessWidget {
  const VoitureList({super.key, required this.voiture});

  final List<Request_cars> voiture;

  @override
  Widget build(BuildContext context) {
    /*return BlocBuilder<CartBloc, CartState>(builder: (_, cartState) {
      bool isGridView = cartState.isGridView;
      if (isGridView) {*/
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: LayoutBuilder(builder: (context, constraints) {
            /*return GridView.builder(
              itemCount: voiture.length,
              itemBuilder: (context, index) => VoitureTileAnimation(
                itemNo: index,
                voiture: voiture[index],
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1,
              ),
            );
          });*/
              /*0} else {*/
          return ListView.builder(
              itemCount: voiture.length,
              itemBuilder: (BuildContext context, int index) {
                return VoitureTileAnimation(
                  itemNo: index,
                  voiture: voiture[index],
                );
              });

                }),
        );
    }
}


