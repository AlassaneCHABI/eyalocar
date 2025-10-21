import 'package:eyav2/modeles/Historique_paiement.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eyav2/function/function.dart' as function;
import '../constants.dart';
import '../widgets/DrawerMenuWidget.dart';
import '../widgets/bottomnav.dart';


class Liste_paiement extends StatefulWidget{
  String token;
  Liste_paiement({ Key? key, required this.token}) : super(key: key);

  @override
  State<Liste_paiement> createState() => _Liste_paiementState();
}

class _Liste_paiementState extends State<Liste_paiement> {
  final List<Historique_paiement> paiement = [];
  bool isLoadier=true;
  bool loading=true;

  bool isSearchStarted = false;

  TextEditingController? textController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    function.getHistorique_paiement(widget.token).then((value){
      if(value!=null){
        setState(() {
          paiement.addAll(value);
          if(paiement.length==value.length){
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes paiements", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),

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
      drawer: CustomDrawer(),

      body: loading? Center(child:/*Text("Aucun paiement trouvé")*/ CircularProgressIndicator(color: greenThemeColor,)): new Padding(

          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child:Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             /* Padding(
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
                                    searchedSpecialiste = specialiste
                                        .where((item) =>
                                        item.nom.toLowerCase().contains(textController!.text.trim().toLowerCase()))
                                        .toList();
                                  }
                                  setState(() {});
                                },
                              ),
                              decoration: InputDecoration(
                                labelText: 'Rechercher les specialistes ici...',
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
              */
              SizedBox(height: 20,),
              Expanded(
                  child:Container(
                    child:getHomePageBody(context,paiement),
                  ) )
            ],
          ) ),
      //bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),

    );
  }

  getHomePageBody(BuildContext context, List<Historique_paiement> list) {
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
              leading: new Icon(Icons.monetization_on_outlined),
              title: new Container(
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: greenThemeColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0),
                  ),
                ),
                child:Text(
                  textAlign: TextAlign.center,
                  "${paiement[index].payment_method}",
                  style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ) ,
              subtitle: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Text(
                     "Réservation N° : ${paiement[index].payment_booking}",
                      style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5,),
                    Text(
                     "Statut du paiement : ${paiement[index].payment_status}",
                      style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5,),
                    Text(
                     "Réf : ${paiement[index].payment_reference}",
                      style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5,),
                    new Text('Montant payer : ${paiement[index].payment_amount} FCFA',
                        style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),

                    SizedBox(height: 5,),
                    Text(
                      "Date : ${paiement[index].created_at}",
                      style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                    ),

                  ]),

              onTap: () {
                //Navigator.push( context, MaterialPageRoute(builder: (context) => Detail_Specialiste(sepcialiste:isSearchStarted?searchedSpecialiste[index]:specialiste[index])));

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
            )*/
          ],
        ) ,
      ),
    )  ;


  }

}

