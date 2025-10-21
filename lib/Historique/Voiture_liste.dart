
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/pages/home_page.dart';
import 'package:eyav2/widgets/homePage/Categorie/Categorie_tile_animation.dart';
import 'package:eyav2/widgets/homePage/Voitures/Categorie_tile_animation.dart';
import 'package:flutter/material.dart';

class VoitureList extends StatelessWidget {
  const VoitureList({super.key, required this.voiture});

  final List<Voitures> voiture;

  @override
  Widget build(BuildContext context) {
    /*return BlocBuilder<CartBloc, CartState>(builder: (_, cartState) {
      bool isGridView = cartState.isGridView;
      if (isGridView) {*/
        return LayoutBuilder(builder: (context, constraints) {
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
              return HomePage();/*VoitureTileAnimation(
                itemNo: index,
                voiture: voiture[index],
              );*/
            });
      });
    }
}

///////
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc_demo/with_bloc/bloc/cart_bloc.dart';
// import 'package:flutter_bloc_demo/with_bloc/bloc/state/cart_state.dart';
//
// import 'product_tile.dart';
//
// class ProductList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<CartBloc, CartState>(listener: (context, state) {
//       Scaffold.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//               state is ProductAdded ? 'Added to cart.' : 'Removed from cart.'),
//           duration: Duration(seconds: 1),
//         ),
//       );
//     }, builder: (_, cartState) {
//       List<int> cart = cartState.cartItem;
//       return LayoutBuilder(builder: (context, constraints) {
//         return GridView.builder(
//           itemCount: 100,
//           itemBuilder: (context, index) => ProductTile(
//             itemNo: index,
//             cart: cart,
//           ),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: constraints.maxWidth > 700 ? 4 : 1,
//             childAspectRatio: 5,
//           ),
//         );
//       });
//     });
//   }
// }
