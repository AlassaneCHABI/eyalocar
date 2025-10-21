
import 'package:easy_debounce/easy_debounce.dart';
import 'package:eyav2/app_theme.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/widgets/homePage/Voitures/details_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eyav2/function/function.dart' as function;


class Vehicule_by_categorie extends StatefulWidget{

 int category_id;
 String category_name;

 Vehicule_by_categorie({ Key? key, required this.category_id,required this.category_name}) : super(key: key);

  @override
  State<Vehicule_by_categorie> createState() => _ListeVehicule_by_categorieState();
}

class _ListeVehicule_by_categorieState extends State<Vehicule_by_categorie> {
  final List<Voitures> voiture = [];
  bool isLoadier=true;
  bool loading=true;

  bool isSearchStarted = false;

  List<Voitures> searchedvoiture = [];
  TextEditingController? textController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    function.getVoitureByCategorie(widget.category_id).then((value){
      if(value!=null){
        setState(() {
          voiture.addAll(value);
          if(voiture.length==value.length){
            loading=false;
          }
        });
      }
    });
    setState(() {
      isLoadier=false;
    });

    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(widget.category_name,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: kPrimaryColor,

        /*actions: [
              BlocBuilder<CartBloc, CartState>(builder: (_, cartState) {
                List<Product> cartItem = cartState.cartItem.cast<Product>();
                return Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 8, 24, 0),
                  child: Badge(
                    badgeContent: Text(
                      '${cartItem.length}',
                      style: AppTheme.of(context).bodyText1.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                      ),
                    ),
                    showBadge: true,
                    shape: BadgeShape.circle,
                    badgeColor: AppTheme.of(context).primaryColor,
                    elevation: 4,
                    padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
                    position: BadgePosition.topEnd(),
                    animationType: BadgeAnimationType.scale,
                    toAnimate: true,
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart_outlined,
                        color: AppTheme.of(context).secondaryText,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutWidget(),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
            ],*/

      ),


      body: loading? Center(child: CircularProgressIndicator(color: kPrimaryColor,)): new Padding(

          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child:Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.of(context).secondaryBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.of(context).primaryBackground,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                          child: Icon(
                            Icons.search_rounded,
                            color: Color(0xFF95A1AC),
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                            child: TextFormField(
                              controller: textController,
                              obscureText: false,
                              onChanged: (_) => EasyDebounce.debounce(
                                'tFMemberController',
                                Duration(milliseconds: 0),
                                    () {
                                  isSearchStarted =
                                      textController!.text.isNotEmpty && textController!.text.trim().length > 0;
                                  print('isSearchStarted $isSearchStarted');
                                  if (isSearchStarted) {
                                    print('${textController!.text.trim()}');
                                    searchedvoiture = voiture
                                        .where((item) =>
                                        item.car_name.toLowerCase().contains(textController!.text.trim().toLowerCase()))
                                        .toList();
                                  }
                                  setState(() {});
                                },
                              ),
                              decoration: InputDecoration(
                                labelText: 'Rechercher les voitures ici...',
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0x00000000),
                                    width: 1,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4.0),
                                    topRight: Radius.circular(4.0),
                                  ),
                                ),
                              ),
                              style: AppTheme.of(context).bodyText1.override(
                                fontFamily: 'Poppins',
                                color: Color(0xFF95A1AC),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                  child:Container(
                    child:getHomePageBody(context,isSearchStarted?searchedvoiture:voiture),
                  ) )
            ],
          ) ),
     // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),

    );
  }

  getHomePageBody(BuildContext context, List<Voitures> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: _getItemUI,
      padding: EdgeInsets.all(0.0),
    );
  }


  Widget _getItemUI(BuildContext context, int index) {
    return  Container(

      child:Card(

        elevation: 10,
        margin: const EdgeInsets.all(10),
        child:Column(
          children: [
            ListTile(
              leading: new
              Image.network(
                "https://otrade-company.com/storage/app/public/Car_157/${isSearchStarted?searchedvoiture[index].car_interior_img:voiture[index].car_interior_img}.jpg",
                fit: BoxFit.cover,
                width: 100.0,
              ),

              title: new Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                  ),
                ),
                child:Text(
                  textAlign: TextAlign.center,
                  "${isSearchStarted?searchedvoiture[index].car_price:voiture[index].car_price } fcfa",
                  style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ) ,
              subtitle: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      isSearchStarted?searchedvoiture[index].car_name:voiture[index].car_name,
                      style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    new Text('${isSearchStarted?searchedvoiture[index].car_status:voiture[index].car_status}',
                        style: new TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.normal)),
                    /*new Text(" à ${isSearchStarted?searchedSpecialiste[index].distance.toStringAsFixed(2):specialiste[index].distance.toStringAsFixed(2)} km de vous",
                        style: new TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.normal)),*/
                  ]),

              onTap: () {
                isSearchStarted?
                Navigator.push( context, MaterialPageRoute(builder: (context) => DetailsPage(
                  car_name: searchedvoiture[index].car_name,
                  car_features: searchedvoiture[index].car_features,
                  car_status: searchedvoiture[index].car_status,
                  car_price: searchedvoiture[index].car_price,
                  category_name: searchedvoiture[index].category_name,
                  car_exterior_img: searchedvoiture[index].car_exterior_img,
                  car_interior_img: searchedvoiture[index].car_interior_img,
                  car_rear_img: searchedvoiture[index].car_rear_img,
                  car_front_img: searchedvoiture[index].car_front_img,
                  car_reg_no: searchedvoiture[index].car_reg_no,
                ))):
                Navigator.push( context, MaterialPageRoute(builder: (context) => DetailsPage(
                  car_name: voiture[index].car_name,
                  car_features: voiture[index].car_features,
                  car_status: voiture[index].car_status,
                  car_price: voiture[index].car_price,
                  category_name: voiture[index].category_name,
                  car_exterior_img: voiture[index].car_exterior_img,
                  car_interior_img: voiture[index].car_interior_img,
                  car_rear_img: voiture[index].car_rear_img,
                  car_front_img: voiture[index].car_front_img,
                  car_reg_no: voiture[index].car_reg_no,
                )));
              },
            ),

            SizedBox(height: 10,),
            /*InkWell(
                onTap: () async {

                  try{
                    final Uri uri= Uri(
                        scheme: 'tel',
                        path: isSearchStarted?searchedSpecialiste[index].telephone.toString():specialiste[index].telephone.toString()
                    );
                    await launchUrl(uri);

                  }catch(e){
                    print(e);
                  }
                },
                child:Container(
                  height: 40,
                  color: Colors.black12,
                  child:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Contacter le spécialiste au',textAlign: TextAlign.right,),
                      SizedBox(width: 10,),
                      Icon(Icons.phone),
                      Text(isSearchStarted?searchedSpecialiste[index].telephone:specialiste[index].telephone,textAlign: TextAlign.right,),
                    ],
                  ) ,


                )
            )
            */
          ],
        ) ,
      ),
    )  ;


  }

}

