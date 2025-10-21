import 'package:eyav2/constants.dart';
import 'package:eyav2/profil/updateprofil_ui.dart';
import 'package:eyav2/widgets/homePage/Conducteur_request/All_request_conducteur.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/DrawerMenuWidget.dart';
import '../widgets/bottomnav.dart';
import '../widgets/homePage/Voitures/All_cars.dart';


class Politique_out extends StatefulWidget {

  const Politique_out({Key? key});

  @override
  State<Politique_out> createState() => _PolitiqueState();
}

class _PolitiqueState extends State<Politique_out> {
  var _isLoading = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text('Politique de confidentialité'),
          centerTitle: true,

        ),
        //drawer: DrawerMenuWidget(),
        //bottomNavigationBar: bottomNvigator(),


        body: Container(
          child: Stack(
            children: [

              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                     Text("Politique d'Utilisation de l'Application EYALOCAR",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),

                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child:Text(" "
                          "\nBienvenue sur EYALOCAR ! Pour garantir une expérience agréable "
                          "et transparente, veuillez prendre connaissance de notre politique "
                          "d'utilisation et renseigner votre contrat.\n\n"
                          "1. Choix de la Pièce d'Identité :\n\n"
                          "Les utilisateurs doivent choisir une pièce d'identité valide parmi les options suivantes "
                          ": CIP, Passeport ou Carte CEDEAO\n\n"
                          "Date d'expiration:\n\n"
                          "2. Annulation de Réservation :\n\n"
                          "En cas d'annulation de réservation, l'agence retiendra "
                          "20% du montant total payé. Assurez-vous de consulter "
                          "les conditions d'annulation avant de confirmer votre "
                          "réservation.\n\n"
                          "3. Notification d'Excédent de Période de Réservation :\n\n"
                          "Tout utilisateur prévoyant de dépasser la période de"
                          " réservation initiale doit notifier l'entreprise EYALOCAR"
                          " au moins 24 heures à l'avance.\n\n"
                          "4. Précision des Dates de Départ et d'Arrivée :"
                          "Les utilisateurs sont tenus de préciser la date de "
                          "départ et la date d'arrivée lors de la réservation. "
                          "Assurez-vous que ces informations sont correctes pour"
                          " éviter tout désagrément.\n\n"
                          "Date départ : \n"
                          "Heure de départ :\n"
                          "Date d'arrivée :\n"
                          " Heure d'arrivée :\n\n"
                          " 5. Paiement en Ligne par Momo :\n\n"
                          "Les utilisateurs acceptent de payer en ligne, notamment par Mobile Money (Momo),"
                          " pour bénéficier pleinement des avantages de l'application. "
                          "Cette méthode de paiement garantit une expérience fluide et sécurisée.\n\n"
                          "6. Réservation Journalière avec Chauffeur :\n\n"
                          "EYALOCAR propose des réservations journalières avec chauffeur. "
                          "Les utilisateurs peuvent profiter de ce service en spécifiant"
                          " leurs besoins lors de la réservation.\n\n"
                          "7. Responsabilité de l'Utilisateur :\n\n"
                          "Les utilisateurs sont responsables de l'exactitude des informations fournies lors de la réservation."
                          "En cas de dommages causés au véhicule pendant la période de location,"
                          " les utilisateurs sont tenues de nous fournir des informations"
                          " ou détails sur les circonstances du fait.\n\n"
                          "8. Utilisation Conforme aux"
                          " Lois et Régulations :\n\n"
                          "Les utilisateurs s'engagent à utiliser les services d'EYALOCAR conformément"
                          " aux lois et régulations en vigueur.\n\n"
                          "9. Confidentialité et Sécurité :\n\n"
                          "EYALOCAR s'engage à protéger la confidentialité des informations "
                          "des utilisateurs. Les données personnelles seront traitées conformément "
                          "à notre politique de confidentialité.\n\n"
                          "En utilisant l'application EYALOCAR, vous acceptez pleinement "
                          "et consciencieusement les conditions énoncées dans cette politique d'utilisation."
                          " Pour toute question ou préoccupation, n'hésitez pas à "
                          "contacter notre service client.\n\n"
                          "Merci de faire partie de la communauté EYALOCAR, où la mobilité"
                          " devient une expérience fluide et sécurisée !",style: TextStyle(fontSize: 15),textAlign: TextAlign.justify,)

                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }




  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: kPrimaryColor),
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
