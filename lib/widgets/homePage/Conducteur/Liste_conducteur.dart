
import 'package:easy_debounce/easy_debounce.dart';
import 'package:eyav2/app_theme.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/modeles/Conducteur.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eyav2/function/function.dart' as function;
import '../../DrawerMenuWidget.dart';
import '../../bottomnav.dart';

class ListeConducteur extends StatefulWidget{


  ListeConducteur({ Key? key}) : super(key: key);

  @override
  State<ListeConducteur> createState() => _Liste_ConducteurState();
}

class _Liste_ConducteurState extends State<ListeConducteur> {

  final List<Conducteur> conducteursB = [];
  final List<Conducteur> conducteursC = [];
  final List<Conducteur> conducteursD = [];
  final List<Conducteur> conducteurs = [];
  bool loading=true;
  bool B = true;
  bool C = false;
  bool D = false;

  bool isSearchStarted = false;

  List<Conducteur> searchedconducteur = [];
  TextEditingController? textController;


  void openWhatsAppWithMessage(String message, String phoneNumber) async {
    String url = 'https://wa.me/$phoneNumber?text=${Uri.encodeFull(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    function.getConducteur().then((value){
      if(value!=null){
        setState(() {
          conducteurs.addAll(value);
          for(int i=0;i<value.length;i++){
            if(value[i].driver_type=="Permis B"){
              conducteursB.add(value[i]);
            }else if(value[i].driver_type=="Permis C"){
              conducteursC.add(value[i]);
            }else
              {
                conducteursD.add(value[i]);
              }
          }
          if(conducteurs.length==value.length){
            loading=false;
          }
        });
      }
    });

    textController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Liste des conducteurs",
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

      drawer: DrawerMenuWidget(),
      bottomNavigationBar: bottomNvigator(),


      body: loading? Center(child: CircularProgressIndicator(color: kPrimaryColor,)): new Padding(

          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child:Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                child: Card(
                  elevation: 1.0,
                  margin: new EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(color: Colors.white),
                    child:Row(
                      children: [
                        SizedBox(width: 30,),
                        B? ElevatedButton(
                              onPressed:() async {
                                setState(() {
                                  B=true;
                                  C=false;
                                  D=false;
                                });
                              },
                              child: const Text('Permis B',style: TextStyle(fontSize: 12),),
                              style:ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                              ) ,
                            ) :ElevatedButton(
                          onPressed:() async {
                            setState(() {
                              B=true;
                              C=false;
                              D=false;
                            });
                          },
                          child: const Text('Permis B',style: TextStyle(fontSize: 12),),
                          style:ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(vertFonceColor),
                          ) ,
                        ),

                        SizedBox(width: 30,),

                        (B==true || D==true)?ElevatedButton(
                          onPressed:() async {
                            setState(() {
                              C=true;
                              B=false;
                              D=false;
                            });
                          },
                          child: Container(child: Text('Permis C',style: TextStyle(fontSize: 12),),) ,
                          style:ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(vertFonceColor),
                          ) ,
                        ):
                        ElevatedButton(
                          onPressed:() async {
                            setState(() {
                              C=true;
                              B=false;
                              D=false;
                            });
                          },
                          child: Container(child: Text('Permis C',style: TextStyle(fontSize: 12),),) ,
                          style:ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                          ) ,
                        ),

                        SizedBox(width: 50,),

                        (B==true || C==true)? ElevatedButton(
                          onPressed:() async {
                            setState(() {
                              B=false;
                              C=false;
                              D=true;
                            });
                          },
                          child: Container(child: Text('Permis D',style: TextStyle(fontSize: 12),),) ,
                          style:ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(vertFonceColor),
                          ) ,
                        ):
                        ElevatedButton(
                          onPressed:() async {
                            setState(() {
                              B=false;
                              C=false;
                              D=true;
                            });
                          },
                          child: Container(child: Text('Permis D',style: TextStyle(fontSize: 12),),) ,
                          style:ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                          ) ,
                        ),

                      ],

                    )
                  ),
                ),
              ),

              SizedBox(height: 20,),

              Expanded(
                  child:Container(
                    child:getHomePageBody(context,B? conducteursB:C?conducteursC:conducteursD),
                  ) )
            ],
          ) ),
    //  bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),

    );
  }

  getHomePageBody(BuildContext context, List<Conducteur> list) {
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
                "https://otrade-company.com/storage/app/public/Driver_${isSearchStarted?searchedconducteur[index].id:conducteurs[index].id}/${isSearchStarted?searchedconducteur[index].driver_photo:conducteurs[index].driver_photo}.jpg",
                fit: BoxFit.cover,
                width: 100.0,
              ),

              title: Container(
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
                  isSearchStarted?searchedconducteur[index].driver_type:conducteurs[index].driver_type,
                  style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold,color: Colors.white),
                ),
              ),
              subtitle: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text("Année de permis : ",style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                        Text(
                          isSearchStarted?searchedconducteur[index].driver_year.toString():conducteurs[index].driver_year.toString(),
                        ),
                      ],
                    )

                  ]),

            ),

            SizedBox(height: 10,),
            InkWell(
                onTap: () {
                  openWhatsAppWithMessage('Bonjour Otrade company!', '22952242474');
                },
                child:Container(
                  height: 40,
                  color: Colors.black12,
                  child:
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Contacter Otrade company',textAlign: TextAlign.right,),
                      SizedBox(width: 10,),
                      Icon(Icons.phone),
                      Text("52242474",textAlign: TextAlign.right,),
                    ],
                  ) ,


                )
            )
          ],
        ) ,
      ),
    )  ;


  }

}

