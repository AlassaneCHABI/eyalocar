
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/widgets/homePage/Categorie/Categorie_tile_animation.dart';
import 'package:eyav2/widgets/homePage/Response_requeste/Categorie_tile_animation.dart';
import 'package:eyav2/widgets/homePage/Voitures/Categorie_tile_animation.dart';
import 'package:flutter/material.dart';

class VoitureListResponse extends StatelessWidget {
  const VoitureListResponse({super.key, required this.voiture});

  final List<Voitures> voiture;

  @override
  Widget build(BuildContext context) {
        return LayoutBuilder(builder: (context, constraints) {
        return ListView.builder(
            itemCount: voiture.length,
            itemBuilder: (BuildContext context, int index) {
              return VoitureTileResponseAnimation(
                itemNo: index,
                voiture: voiture[index],
              );
            });
      });
    }
}
