
import 'package:eyav2/constants.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:eyav2/app_theme.dart';
import 'package:eyav2/modeles/Reservation.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:eyav2/reservation/HisrotiqueList.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/function/function.dart' as function;
import '../widgets/DrawerMenuWidget.dart';
import '../widgets/bottomnav.dart';

class HistoriqueListingWidget extends StatefulWidget {
 String token;
  HistoriqueListingWidget({Key? key,required this.token}) : super(key: key);

  @override
  _HistoriqueListingWidgetState createState() => _HistoriqueListingWidgetState();
}

class _HistoriqueListingWidgetState extends State<HistoriqueListingWidget> {
  TextEditingController? textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSearchStarted = false;
  int search=0;
  List<Reservation> searchedReservation = [];
  final List<Reservation> reservasation = [];


  void getReservation()async{
   await function.getHistorique(widget.token).then((value){
      if(value!=null){
        setState(() {
          reservasation.addAll(value);
        });
      }
    });
    if(reservasation.length!=0){
      setState(() {
        search =1;
      });
    }else{
      search =2;
    }
  }

  void initState()  {
    // TODO: implement initState
    super.initState();
    getReservation();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Mes réservations", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),
      // bottomNavigationBar: BottomNavBar(),


      body:search==0
        ? Center(
            child:CircularProgressIndicator(),
        ):search==2
          ? Center(
              child:Text("Aucune reservation trouvée"),
            )
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 30,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  // width: MediaQuery.of(context).size.width * 0.90,
                  // height: 50,
                  // decoration: BoxDecoration(
                  //   color: AppTheme.of(context).secondaryBackground,
                  //   borderRadius: BorderRadius.circular(8),
                  //   border: Border.all(
                  //     color: AppTheme.of(context).primaryBackground,
                  //     width: 2,
                  //   ),
                  // ),
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
                          searchedReservation= reservasation
                              .where((item) =>
                              item.category_name.toLowerCase().contains(textController!.text.trim().toLowerCase()))
                              .toList();
                        }
                        setState(() {});
                      },
                    ),
                    decoration: InputDecoration(
                      hintText: "Rechercher ici...",
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(80)),
                      ),
                      suffixIcon: GestureDetector( child: Icon(Icons.search)),
                    ),
                  ),
                ),
                /*Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      BlocBuilder<CartBloc, CartState>(builder: (_, cartState) {
                        bool isGridView = cartState.isGridView;
                        return IconButton(
                            onPressed: () {
                              BlocProvider.of<CartBloc>(context).add(ChangeGallaryView(!isGridView));
                            },
                            icon: !isGridView ? Icon(Icons.grid_on) : Icon(Icons.list));
                      }),
                    ],
                  ),
                ),*/
                SizedBox(height: 30,),
                Expanded(
                  child: HistoriqueList(
                    reservation: isSearchStarted ? searchedReservation: reservasation,
                  ),
                ),
              ],
            ),
            // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
