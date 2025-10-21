import 'package:flutter/material.dart';
import 'package:eyav2/size_config.dart';

const kPrimaryColor = Color(0xff104911);
const kPrimaryLightColor = Color(0xFFFFECDF);
const kPrimarywhite = Color(0xFFFFEFFF);
const vertFonceColor = Color(0xff088c2e);
const greenThemeColor = Color(0xFF0EA000);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Entrez votre email";
const String kInvalidEmailError = "Entrez un email valide";
const String kPassNullError = "Entrez votre mot de passe";
const String kShortPassError = "Le mot de passe est trop court";
const String kMatchPassError = "Les mots de passe ne correspondent pas";
const String kNamelNullError = "Entrez votre nom";
const String kPhoneNumberNullError = "Entrez votre numéro de téléphone";
const String kbudgetNullError = "Entrez votre budget";
const String kAddressNullError = "Entrez votre adresse";
const String kcar_priceNullError = "Entrez le prix";
const String kprenomNullError = "Entrez votre prénom";
const String kbooking_circuitNullError = "Entrez le trajet";
const String kcar_informationsNullError = "Entrez les détails du véhicule";
const String ktelephoneNullError = "Entrez votre numéro de téléphone";
const String kTypeIdentiteNullError = "Renseignez votre type de pièce d'identité";

const String kVilleNullError = "Entrez la ville";
const String kAnneNullError = "Entrez l'année";
const String kbooking_ifuNullError = "Entrez votre IFU";
const String kvtelephoneNullError = "Entrez le numéro de téléphone";
const String kdateNullError = "Entrez la date";
const String kNomNullError = "Entrez le nom";
const String kcar_nameNullError = "Entrez le nom du véhicule";
const String kcaNullError = "Entrez le nom";
const String kbooking_heNullError = "Entrez l'heure";
const String kdestinationNullError = "Entrez la destination";
const String kbooking_leNullError = "Entrez la date";
const String kalerte_nameNullError = "Entrez le nom de l'alerte";
const String kDescriptionNullError = "Entrez la description";
const String kcar_featuresNullError = "Entrez les caractéristiques";
const String kcar_yearNullError = "Entrez l'année";
const String ktypeNullError = "Entrez le type";
const String kAPseudoNullError = "Entrez votre pseudo";
const String kAcar_reg_noNullError = "Entrez l'immatriculation";
const String kAbooking_societyNullError = "Entrez votre ville";
const String kAemailNullError = "Entrez l'email";

final otpInputDecoration = InputDecoration(
  contentPadding:
  EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
