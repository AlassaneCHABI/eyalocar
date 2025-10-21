import 'package:eyav2/constants.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:eyav2/app_theme.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:eyav2/widgets/homePage/Response_requeste/Voiture_liste.dart';
import 'package:eyav2/widgets/homePage/Voitures/Voiture_liste.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/function/function.dart' as function;
import '../../DrawerMenuWidget.dart';
import '../../bottomnav.dart';

class CarsResponseListingWidget extends StatefulWidget {
  int request_id;

  CarsResponseListingWidget({Key? key,required this.request_id}) : super(key: key);

  @override
  _CarsListingWidgetState createState() => _CarsListingWidgetState();
}

class _CarsListingWidgetState extends State<CarsResponseListingWidget> {
  TextEditingController? textController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSearchStarted = false;

  List<Voitures> searchedVoitures = [];
  final List<Voitures> voiture = [];


  void initState() {
    // TODO: implement initState
    super.initState();
    function.getVoiturebyRequest_id(widget.request_id).then((value){
      if(value!=null){
        setState(() {
          voiture.addAll(value);
        });
      }
    });
    textController = TextEditingController();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Nos véhicules", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),
      // bottomNavigationBar: bottomNvigator(),

      body:voiture.length==0?Center(child: CircularProgressIndicator(),):  Column(
        mainAxisSize: MainAxisSize.max,
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
                                searchedVoitures = voiture
                                    .where((item) =>
                                    item.category_name.toLowerCase().contains(textController!.text.trim().toLowerCase()))
                                    .toList();
                              }
                              setState(() {});
                            },
                          ),
                          decoration: InputDecoration(
                            labelText: 'Rechercher par catégorie ici...',
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
          Expanded(
            child: VoitureListResponse(
              voiture: isSearchStarted ? searchedVoitures: voiture,
            ),
          ),
        ],
      ),
     // bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }
}
