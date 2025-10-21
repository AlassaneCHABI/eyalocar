import 'package:eyav2/new/drawer.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Mention extends StatefulWidget {
  const Mention({super.key});

  @override
  State<Mention> createState() => _MentionState();
}

class _MentionState extends State<Mention> {
  late WebViewController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://eyalocar.com/mentions-legales'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mentions légales et CGU", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),

      body:WebViewWidget(controller: _controller),  /*SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child:Text("Politique d'utilisation de l'Application EYALOCAR :",style: TextStyle(fontFamily: 'Ubuntu', fontSize: 22,fontWeight: FontWeight.bold),),

              ),

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
                      " 5. Paiement en Ligne par Kkiapay :\n\n"
                      "Les utilisateurs acceptent de payer en ligne via Kkiapay,"
                      " offrant plusieurs possibilités de paiement telles que Mobile Money,"
                      " Moov Money, Celtis Cash, carte bancaire et débit. Cette méthode de "
                      "paiement garantit une expérience fluide et sécurisée.\n\n"
                      "6.  Réservation de Voitures Neuves de Moins de 8 Ans :\n\n"
                      "EYALOCAR se spécialise dans la réservation de voitures neuves"
                      " de moins de 8 ans d'âge, garantissant ainsi une flotte de "
                      "véhicules modernes et fiables.\n\n"""
                      "7. Bonus de Fidélité :\n\n"
                      "Les utilisateurs pourront cumuler des bonus de fidélité "
                      "qu'ils pourront utiliser pour la réservation, couvrant une"
                      " partie ou la totalité de leur quotation.\n\n"
                      "8. Responsabilité de l'Utilisateur :\n\n"
                      "Les utilisateurs sont responsables de l'exactitude"
                      " des informations fournies lors de la réservation. "
                      "En cas de dommages causés au véhicule pendant la période "
                      "de location, les utilisateurs sont tenus de nous fournir "
                      "des informations ou détails sur les circonstances du fait.\n\n"
                      "9. Utilisation Conforme aux"
                      " Lois et Régulations :\n\n"
                      "Les utilisateurs s'engagent à utiliser les services"
                      " d'EYALOCAR conformément aux lois et régulations en vigueur.\n\n"
                      "10. Confidentialité et Sécurité :\n\n"
                      "EYALOCAR s'engage à protéger la confidentialité des informations"
                      " des utilisateurs. Les données personnelles seront traitées conformément"
                      " à notre politique de confidentialité.\n\n"
                      "En utilisant l'application EYALOCAR, vous acceptez pleinement "
                      "et consciencieusement les conditions énoncées dans cette politique "
                      "d'utilisation. Pour toute question ou préoccupation, n'hésitez pas "
                      "à contacter notre service client.\n\n"
                      "Merci de faire partie de la communauté EYALOCAR, où la mobilité "
                      "devient une expérience fluide et sécurisée !",style: TextStyle(fontSize: 18),textAlign: TextAlign.justify,)

              ),
              SizedBox(height: 20),
            ],
          ),
        )*/
    );
  }
}
