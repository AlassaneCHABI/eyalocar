import 'package:eyav2/new/drawer.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});
  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  int _currentIndex = 5;
  late WebViewController _controller;
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
      ..loadRequest(Uri.parse('https://eyalocar.com/politique-confidentialite'));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Politique de confidentialité', style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        drawer: CustomDrawer(),

        body:WebViewWidget(controller: _controller), /*SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child:Text("Politique de Confidentialité de l'Application EYALOCAR :",style: TextStyle(fontFamily: 'Ubuntu', fontSize: 22,fontWeight: FontWeight.bold),),

              ),

              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child:Text(" "
                      "\nBienvenue sur EYALOCAR ! Notre engagement envers"
                      "votre vie privée est essentiel pour  "
                      "garantir une expérience utilisateur sécurisée et transparente."
                      " Veuillez lire attentivement notre politique de confidentialité pour"
                      "comprendre comment nous collectons, utilisons et protégeons vos données."
                      "\n\n"
                      "1. Collecte d'Informations :\n\n"
                      "Nous collectons les informations nécessaires à la réservation de véhicules, "
                      " telles que votre nom, numéro de téléphone, adresse e-mail,"
                      " type de pièce d'identité choisie, et les détails de votre réservation."
                      "\n\n"
                      "2. Utilisation des Informations :\n\n"
                      "Les informations que nous collectons sont utilisées pour traiter  "
                      "vos réservations, personnaliser votre expérience, améliorer nos services, "
                      " et vous informer des mises à jour et promotions."
                      "\n\n"
                      "3. Sécurité des Données :\n\n"
                      "EYALOCAR met en place des mesures de sécurité robustes pour protéger"
                      " vos informations contre tout accès non autorisé, modification,"
                      " divulgation ou destruction.\n\n"
                      "4.  Partage d'Informations :\n\n"
                      "Nous ne partageons pas vos données personnelles avec "
                      "des tiers, sauf pour les prestataires de services nécessaires"
                      " à la prestation de nos services, et ce, conformément "
                      "à la législation en vigueur. \n\n"
                      " 5. Conservation des Données :\n\n"
                      "Vos données sont conservées aussi longtemps que nécessaire "
                      "pour fournir nos services et respecter les obligations légales.\n\n"
                      "6.  Choix de l'Utilisateur :\n\n"
                      "Vous avez le choix de fournir des informations, mais"
                      " cela peut affecter la disponibilité ou la qualité de "
                      "nos services.\n\n"
                      "7. Communication  :\n\n"
                      "Nous pouvons vous contacter par e-mail, téléphone"
                      " ou notifications push pour des informations liées"
                      " à votre réservation, des promotions ou des mises à"
                      " jour importantes.\n\n"
                      "8. Droits et Contrôle \n\n"
                      " Vous avez le droit d'accéder, de rectifier, de supprimer"
                      " ou de limiter l'utilisation de vos données personnelles. "
                      "Contactez-nous pour exercer ces droits. \n\n"
                      "9. Modifications de la Politique de Confidentialité :\n\n"
                      "Nous nous réservons le droit de mettre à jour notre politique"
                      " de confidentialité. Toute modification sera publiée sur notre"
                      " site Web et vous sera notifiée via l'application.\n\n"
                      "En utilisant l'application EYALOCAR, vous consentez à la collecte"
                      " et à l'utilisation de vos informations conformément à cette politique "
                      "de confidentialité. Si vous avez des questions, contactez notre service"
                      " client.\n\n"
                      "Merci de faire partie de la communauté EYALOCAR, où votre confidentialité est notre priorité !",style: TextStyle(fontSize: 18),textAlign: TextAlign.justify,)

              ),
              SizedBox(height: 20),
            ],
          ),
        )*/
    );
  }
}
