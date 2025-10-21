import 'package:eyav2/constants.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:eyav2/new/update_profile.dart';
import 'package:eyav2/profil/updateprofil_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/DrawerMenuWidget.dart';
import '../widgets/bottomnav.dart';


class ProfilUI extends StatefulWidget {
  const ProfilUI({Key? key});

  @override
  State<ProfilUI> createState() => _ProfilUIState();
}

class _ProfilUIState extends State<ProfilUI> {
  var _isLoading = false;
  late String username;
  late String lastname;
  late String firstname;
  late String city;
  late String address;
  late String type_identifier;
  late String identifier;
  late String email;
  late String token;
  late int bonus;
  late String bonus_expiration;


  @override
  void initState() {
    super.initState();
    _getLocalUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),
      // bottomNavigationBar: bottomNvigator(),


      body: _isLoading
          ? Center(
        child: SizedBox(
          height: 40.0,
          width: 40.0,
          child: CircularProgressIndicator(
            color: greenThemeColor,
            strokeWidth: 5,
          ),
        ),
      )
          : Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset('assets/logo_bleu.jpg',
                            width: 200, height: 50,),
                        ) ,
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            " ${lastname +" "+ firstname ?? ''}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                         SizedBox(
                          height: 10,
                        ),
                        _buildSectionTitle('Informations personnelles'),
                        _buildPersonalInfo(),
                        SizedBox(height: 20),
                        _buildSectionTitle('Adresse'),
                        _buildOtherInfo(),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (ctxt) =>  UpdateProfile()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greenThemeColor,
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Modifier le profil',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        /*Center(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const Updateprofil()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greenThemeColor,
                            ),
                            child: Text(
                              'Modifier',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),*/
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getLocalUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      username=prefs.getString("username")!;
      lastname=prefs.getString("lastname")!;
      firstname=prefs.getString("firstname")!;
      city=prefs.getString("city")!;
      address=prefs.getString("address")!;
      type_identifier=prefs.getString("type_identifier")!;
      identifier=prefs.getString("identifier")!;
      email=prefs.getString("email")!;
      token=prefs.getString("token")!;
      bonus_expiration=prefs.getString("bonus_expiration")!;
      bonus=prefs.getInt("bonus")!;

    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: greenThemeColor,
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Column(
      children: [
        _buildInfoRow(Icons.person, 'Nom d\'utilisateur', username),
        _buildInfoRow(Icons.account_balance_wallet_rounded, 'Bonus', bonus.toString()),
        //_buildInfoRow(Icons.account_balance_wallet_rounded, 'Bonus expiration',bonus_expiration),
        // Add more personal information rows here
      ],
    );
  }

  Widget _buildOtherInfo() {
    return Column(
      children: [
        _buildInfoRow(Icons.email, 'Email', email),
        _buildInfoRow(Icons.location_on, 'Adresse', address),
        _buildInfoRow(Icons.location_on, 'Ville', city),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: greenThemeColor),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(value, style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }


}
