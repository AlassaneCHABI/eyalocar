
import 'dart:convert';
import 'dart:io';

import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/modeles/Conducteur.dart';
import 'package:eyav2/modeles/Conducteur_reponse.dart';
import 'package:eyav2/modeles/Request_conducteur.dart';
import 'package:eyav2/modeles/Reservation.dart';
import 'package:eyav2/modeles/Setting.dart';
import 'package:eyav2/modeles/Users.dart';
import 'package:eyav2/modeles/Voiture.dart';
import 'package:eyav2/modeles/request_cars.dart';
import 'package:http/http.dart ' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../modeles/Historique_paiement.dart';


Future <void> register(String pseudo,String nom,String prenom, String ville,String adresse,String type_identifier,String identifier,String email,String password) async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/auth/register');

  final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
      body: json.encode({
        "username": pseudo,
        "lastname": nom,
        "firstname": prenom,
        "city": ville,
        "address": adresse,
        "type_identifier": type_identifier,
        "identifier": identifier,
        "email": email,
        "password": password,
        "phone_number": "65735082",
      })
  );
  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          },
          body: json.encode({
            "username": pseudo,
            "lastname": nom,
            "firstname": prenom,
            "city": ville,
            "address": adresse,
            "type_identifier": type_identifier,
            "identifier": identifier,
            "email": email,
            "password": password,
            "phone_number": "65735082",
          })
      );

      // Process the new response
      print(newResponse.statusCode);
      print(newResponse.body);
    }
  }
}

Future <void> AddAlerte(String alerte_name,String alerte_car_informations, String alerte_email,String alerte_type,String alerte_telephone,String alerte_date) async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/add-alertes');
  print("Les details ");
  print(alerte_car_informations);
  print(alerte_name);
  print(alerte_email);
  print(alerte_type);
  print(alerte_telephone);
  print(alerte_date);

  final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
      body: json.encode({
        "alerte_name": alerte_name,
        "alerte_car_informations": alerte_car_informations,
        "alerte_email": alerte_email,
        "alerte_type": alerte_type,
        "alerte_telephone": alerte_telephone,
        "alerte_date": alerte_date,
      })
  );
  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          },
          body: json.encode({
            "alerte_name": alerte_name,
            "alerte_car_informations": alerte_car_informations,
            "alerte_email": alerte_email,
            "alerte_type": alerte_type,
            "alerte_telephone": alerte_telephone,
            "alerte_date": alerte_date,
          })
      );
      // Process the new response
      print(newResponse.statusCode);
      print(newResponse.body);
    }
  }
}

Future<void> AddAVehicule(
    String carName,
    int carCategory,
    String carPrice,
    String carRegNo,
    String carYear,
    String carFeatures,
    String token,
    File carExteriorImg,
    File carInteriorImg,
    File carFrontImg,
    File carRearImg,
    ) async {
  var url = Uri.http('${Configuration.base_url_}', 'apiv2/add-cars');
  print("Les details ");
  print(carName);
  print(carCategory);
  print(carPrice);
  print(carRegNo);
  print(carYear);
  print(carFeatures);

  var request = http.MultipartRequest('POST', url);
  request.headers['Authorization'] = 'Bearer $token';
  request.headers['Accept'] = 'application/json';
  request.headers['Content-Type'] = 'multipart/form-data';

  request.fields['car_name'] = carName;
  request.fields['car_category'] = carCategory.toString();
  request.fields['car_price'] = carPrice;
  request.fields['car_reg_no'] = carRegNo;
  request.fields['car_year'] = carYear;
  request.fields['car_features'] = carFeatures;

  request.files.add(
    http.MultipartFile(
      'car_exterior_img',
      carExteriorImg.readAsBytes().asStream(),
      carExteriorImg.lengthSync(),
      filename: 'car_exterior_img.jpg',
    ),
  );

  request.files.add(
    http.MultipartFile(
      'car_interior_img',
      carInteriorImg.readAsBytes().asStream(),
      carInteriorImg.lengthSync(),
      filename: 'car_interior_img.jpg',
    ),
  );

  request.files.add(
    http.MultipartFile(
      'car_front_img',
      carFrontImg.readAsBytes().asStream(),
      carFrontImg.lengthSync(),
      filename: 'car_front_img.jpg',
    ),
  );

  request.files.add(
    http.MultipartFile(
      'car_rear_img',
      carRearImg.readAsBytes().asStream(),
      carRearImg.lengthSync(),
      filename: 'car_rear_img.jpg',
    ),
  );
  try{
    var response = await request.send();
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      final newUrl = response.headers['location'];
      if (newUrl != null) {
        var newRequest = http.MultipartRequest('POST', Uri.parse(newUrl));
        newRequest.headers['Authorization'] = 'Bearer $token';
        newRequest.headers['Accept'] = 'application/json';
        newRequest.headers['Content-Type'] = 'multipart/form-data';

        newRequest.fields['car_name'] = carName;
        newRequest.fields['car_category'] = carCategory.toString();
        newRequest.fields['car_price'] = carPrice;
        newRequest.fields['car_reg_no'] = carRegNo;
        newRequest.fields['car_year'] = carYear;
        newRequest.fields['car_features'] = carFeatures;

        newRequest.files.add(
          http.MultipartFile(
            'car_exterior_img',
            carExteriorImg.readAsBytes().asStream(),
            carExteriorImg.lengthSync(),
            filename: 'car_exterior_img.jpg',
          ),
        );

        newRequest.files.add(
          http.MultipartFile(
            'car_interior_img',
            carInteriorImg.readAsBytes().asStream(),
            carInteriorImg.lengthSync(),
            filename: 'car_interior_img.jpg',
          ),
        );

        newRequest.files.add(
          http.MultipartFile(
            'car_front_img',
            carFrontImg.readAsBytes().asStream(),
            carFrontImg.lengthSync(),
            filename: 'car_front_img.jpg',
          ),
        );

        newRequest.files.add(
          http.MultipartFile(
            'car_rear_img',
            carRearImg.readAsBytes().asStream(),
            carRearImg.lengthSync(),
            filename: 'car_rear_img.jpg',
          ),
        );
        var newResponse = await newRequest.send();
        print(newResponse.statusCode);
        print(await newResponse.stream.bytesToString());
      }
    }

  }catch(e){
   print("Erreur : $e");
  }
}



Future<File?> Send_conducteur( String driver_lastname,
    String driver_firstname,
    String driver_type,
    String driver_phone_number,
    String driver_email,
    String driver_address,
    String driver_city,
    String token,
    XFile driver_cip,
    XFile driver_photo,
    XFile driver_permis,) async {
  print("Les details ");
  print(driver_lastname);
  print(driver_firstname);
  print(driver_type);
  print(driver_phone_number);
  print(driver_email);
  print(driver_address);
  print(driver_city);
  print(token);
  print(driver_cip.path);
  print(driver_photo.path);
  print(driver_permis.path);

  var request = http.MultipartRequest('POST', Uri.parse('${Configuration.base_url_}/apiv2/add-drivers',),);
  request.headers['Authorization'] = 'Bearer $token';
  request.headers['Accept'] = 'application/json';
  request.headers['Content-Type'] = 'multipart/form-data';
  request.files.add(await http.MultipartFile.fromPath('driver_cip', driver_cip.path));
  request.files.add(await http.MultipartFile.fromPath('driver_photo', driver_photo.path));
  request.files.add(await http.MultipartFile.fromPath('driver_permis', driver_permis.path));
  request.fields['driver_firstname'] = driver_firstname;
  request.fields['driver_type'] = driver_type;
  request.fields['driver_phone_number'] = driver_phone_number;
  request.fields['driver_email'] = driver_email;
  request.fields['driver_address'] = driver_address;
  request.fields['driver_city'] = driver_city;
  request.fields['driver_lastname'] = driver_lastname;

  try{
    var response = await request.send();
    print("le status");
    if (response.statusCode == 200) {
      print('File uploaded successfully');
    } else {
      print(response.statusCode);
      print('Error uploading file');
      print('Response status code: ${response.statusCode}');
      print('Response body: ${await response.stream.bytesToString()}');
    }
  }catch(e){
   print("Erreur :$e");
  }
}


Future <void> reserver(int car_id,String booking_society,String booking_phone_number, String booking_ifu,String booking_circuit,String booking_le,String booking_ld,String booking_he,String booking_dd,String booking_de,String token) async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/add-bookings');
  final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader:'Bearer $token'
      },
      body: json.encode({
        "car_id": car_id,
        "booking_society": booking_society,
        "booking_phone_number": booking_phone_number,
        "booking_ifu": booking_ifu,
        "booking_circuit": booking_circuit,
        "booking_le": booking_le,
        "booking_ld": booking_ld,
        "booking_he": booking_he,
        "booking_de": booking_de,
        "booking_dd": booking_dd,
      })
  );
  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader:'Bearer $token'
          },
          body: json.encode({
            "car_id": car_id,
            "booking_society": booking_society,
            "booking_phone_number": booking_phone_number,
            "booking_ifu": booking_ifu,
            "booking_circuit": booking_circuit,
            "booking_le": booking_le,
            "booking_ld": booking_ld,
            "booking_he": booking_he,
            "booking_de": booking_de,
            "booking_dd": booking_dd,
          })
      );
      // Process the new response
      print(newResponse.statusCode);
      print(newResponse.body);
    }
  }
}

Future<List<Users>>  login(String email,String password,String user_token) async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/auth/login');
  List<Users> user = [];
  final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
      body: json.encode({
        "email": email,
        "password": password,
        "device_token": user_token,
      })
  );
  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          },
          body: json.encode({
            "email": email,
            "password": password,
            "device_token": user_token,
          })
      );
      print(newResponse.statusCode);
      print(newResponse.body);
      try{
        List<dynamic> body = json.decode(newResponse.body);
        body.forEach((element) {
          user.add(Users.fromJson(element));
        });
      }catch(e){
        print("erreur");
        user=[];
      }
    }
  }

  return user;
}


void  paiement_reservation(int booking_id,int restant,String token) async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/add-payments');

  final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader:'Bearer $token'
      },
      body: json.encode({
        "booking_id": booking_id,
      })
  );

  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader:'Bearer $token'
          },
          body: json.encode({
            "booking_id": booking_id,
          })
      );

      print(newResponse.body);
      print(newResponse.statusCode);
      print("My token :"+token);
    }
  }

}


void  ResetPin(String email) async {
  try{
    var url = Uri.http('${Configuration.base_url}', 'apiv2/auth/reset-pin');
    int status = 0;
    final response = await http.post(
        url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
        body: json.encode({
          "email": email,
        })
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 301) {
      final newUrl = response.headers['location'];
      if (newUrl != null) {
        // Make a new request to the new URL
        final newResponse = await http.post(Uri.parse(newUrl),
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.acceptHeader: 'application/json',
            },
            body: json.encode({
              "email": email,
            })
        );
        print(newResponse.body);
        print(newResponse.statusCode);
      }
    }
  }catch(e){
    print("erreur  :$e");
  }


}

void  Update_Password(String email,String codepin,String password ,String confirmpassword) async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/auth/reset-password');
  int status = 0;
  final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
      body: json.encode({
        "email": email,
        "pin": codepin,
        "new_password": password,
        "new_password_confirmation": confirmpassword,
      })
  );

  print(response.statusCode);
  print(response.body);
  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          },
          body: json.encode({
            "email": email,
            "pin": codepin,
            "new_password": password,
            "new_password_confirmation": confirmpassword,
          })
      );

      print(newResponse.body);
      print(newResponse.statusCode);
    }
  }

}

Future<List<Voitures>>  getVoiturebyRequest_id(int request_id) async {
  print(request_id);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token= prefs.getString("token");
  var url = Uri.http('${Configuration.base_url}', 'apiv2/get-rrcars');
  List<Voitures> voitures = [];
  final response = await http.post(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:'Bearer $token'
    },
      body: json.encode({
        "request_id": request_id,
      })
  );
  print(response.body);
  print(response.statusCode);

  if(response.statusCode == 200){
    List<dynamic> body = json.decode(response.body);
    body.forEach((element) {
      voitures.add(Voitures.fromJson(element)) ;
    });
  }
  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:'Bearer $token'
        },
          body: json.encode({
            "request_id": request_id,
          })
      );

      print(newResponse.body);
      print(newResponse.statusCode);
        List<dynamic> body = json.decode(newResponse.body);
        body.forEach((element) {
          voitures.add(Voitures.fromJson(element)) ;
        });
    }

  }
  return voitures;
}

Future<List<Conducteur_reponse>>  getConducteurbyRequest_id(int request_id) async {
  print(request_id);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token= prefs.getString("token");
  var url = Uri.http('${Configuration.base_url}', 'apiv2/get-rrdrivers');
  List<Conducteur_reponse> conducteur = [];
  final response = await http.post(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:'Bearer $token'
    },
      body: json.encode({
        "request_id": request_id,
      })
  );
  print(response.body);
  print(response.statusCode);

  if(response.statusCode == 200){
    List<dynamic> body = json.decode(response.body);
    body.forEach((element) {
      conducteur.add(Conducteur_reponse.fromJson(element)) ;
    });
  }
  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:'Bearer $token'
        },
          body: json.encode({
            "request_id": request_id,
          })
      );

      print(newResponse.body);
      print(newResponse.statusCode);
        List<dynamic> body = json.decode(newResponse.body);
        body.forEach((element) {
          conducteur.add(Conducteur_reponse.fromJson(element)) ;
        });
    }

  }
  return conducteur;
}


Future<List<Request_cars>>  getsearch(String token) async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/get-requestcars');
  List<Request_cars> Liste_recherche = [];
  print(token);
  final response = await http.post(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:'Bearer $token'
    },
  );
  print(response.body);
  print(response.statusCode);

  if(response.statusCode == 200){
    List<dynamic> body = json.decode(response.body);
    body.forEach((element) {
      Liste_recherche.add(Request_cars.fromJson(element)) ;
    });
  }
  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:'Bearer $token'
        },
      );

      print(newResponse.body);
      print(newResponse.statusCode);
      List<dynamic> body = json.decode(newResponse.body);
      body.forEach((element) {
        Liste_recherche.add(Request_cars.fromJson(element)) ;
      });
    }
  }
  return Liste_recherche;
}

Future<List<Request_conducteur>>  getsearchconducteur(String token) async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/get-requestdrivers');
  List<Request_conducteur> Liste_recherche = [];
  print(token);
  final response = await http.post(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:'Bearer $token'
    },
  );
  print(response.body);
  print(response.statusCode);

  if(response.statusCode == 200){
    List<dynamic> body = json.decode(response.body);
    body.forEach((element) {
      Liste_recherche.add(Request_conducteur.fromJson(element)) ;
    });
  }
  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:'Bearer $token'
        },
      );

      print(newResponse.body);
      print(newResponse.statusCode);
      List<dynamic> body = json.decode(newResponse.body);
      body.forEach((element) {
        Liste_recherche.add(Request_conducteur.fromJson(element)) ;
      });
    }
  }
  return Liste_recherche;
}

/*
Future<List<Request_cars>>  getsearch(String token) async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/get-requestcars');
  List<Request_cars> voitures = [];
  final response = await http.post(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:'Bearer $token'
    },
      body: json.encode({
        "token": token,
      })
  );
  print(response.body);
  print(response.statusCode);

  if(response.statusCode == 200){
    List<dynamic> body = json.decode(response.body);
    body.forEach((element) {
      voitures.add(Request_cars.fromJson(element)) ;
    });
  }
  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:'Bearer $token'
        },
          body: json.encode({
            "token": token,
          })
      );

      print(newResponse.body);
      print(newResponse.statusCode);
        List<dynamic> body = json.decode(newResponse.body);
        body.forEach((element) {
          voitures.add(Request_cars.fromJson(element)) ;
        });
    }

  }
  return voitures;
}

*/

Future<List<Reservation>>  getHistorique(String token) async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/list-bookings');
  List<Reservation> voitures = [];
  final response = await http.post(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:'Bearer $token'
    },
  );
  print(response.body);
  print(response.statusCode);

  if(response.statusCode == 200){
    List<dynamic> body = json.decode(response.body);
    body.forEach((element) {
      voitures.add(Reservation.fromJson(element)) ;
    });
  }
  else if(response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:'Bearer $token'
        },
      );

      print(newResponse.body);
      print(newResponse.statusCode);
        List<dynamic> body = json.decode(newResponse.body);
        body.forEach((element) {
          voitures.add(Reservation.fromJson(element)) ;
        });
    }

  }
  return voitures;
}

/*Future<Setting>  getSetting() async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/setting');
  List<Setting> setting = [];
  final response = await http.get(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    },
  );
  print(response.body);
  print(response.statusCode);

  if(response.statusCode == 200){
    List<Map<String, dynamic>> body = json.decode(response.body);
    body.forEach((element) {
      setting.add(Setting.fromJson(element)) ;
    });
  }
  else if(response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.get(Uri.parse(newUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
      );

      print(newResponse.body);
      print(newResponse.statusCode);
      List<Map<String, dynamic>> body = json.decode(newResponse.body);
        body.forEach((element) {
          setting.add(Setting.fromJson(element)) ;
        });
    }

  }
  return setting;
}
*/

Future<List<Setting>>  getSetting() async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/setting');
  List<Setting> setting = [];
  final response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
  );
  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.get(Uri.parse(newUrl),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          },
      );
      print(newResponse.statusCode);
      print(newResponse.body);
      try{
        List<dynamic> body = json.decode(newResponse.body);
        body.forEach((element) {
          setting.add(Setting.fromJson(element));
        });
      }catch(e){
        print("erreur");
        setting=[];
      }
    }
  }else if(response.statusCode == 200){
    print(response.statusCode);
    print(response.body);
    try{
      List<dynamic> body = json.decode(response.body);
      body.forEach((element) {
        setting.add(Setting.fromJson(element));
      });
    }catch(e){
      print("erreur $e");
      setting=[];
    }
  }

  return setting;
}

Future<List<Category>>  getCategorie() async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/category');
  List<Category> Liste_categorie = [];
  final response = await http.get(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    },
  );
  print(response.body);
  print(response.statusCode);

  if(response.statusCode == 200){
    List<dynamic> body = json.decode(response.body);
    body.forEach((element) {
      Liste_categorie.add(Category.fromJson(element)) ;
    });
  }
  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.get(Uri.parse(newUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
      );

      print(newResponse.body);
      print(newResponse.statusCode);
        List<dynamic> body = json.decode(newResponse.body);
        body.forEach((element) {
          Liste_categorie.add(Category.fromJson(element)) ;
        });
    }
  }
  return Liste_categorie;
}



Future<List<Historique_paiement>>  getHistorique_paiement(String token) async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/list-payments');
  List<Historique_paiement> historique = [];
  final response = await http.post(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader:'Bearer $token'
    },
  );

  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          HttpHeaders.authorizationHeader:'Bearer $token'
        },

      );

      print(newResponse.body);
      print(newResponse.statusCode);
      if(newResponse.statusCode == 200){
        List<dynamic> body = json.decode(newResponse.body);
        body.forEach((element) {
          historique.add(Historique_paiement.fromJson(element)) ;
        });
      }

    }

  }
  return historique;
}

Future<List<Voitures>> getVoitureByCategorie(int category_id) async {
  var url = Uri.http('${Configuration.base_url}','apiv2/cars-by-category?category_id=$category_id');

  final response = await http.get(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  print(response.statusCode);
  print(response.body);

  List<dynamic> body = json.decode(response.body);
  List<Voitures> voiture = [];

  if(response.statusCode == 200){
    body.forEach((element) {
      voiture.add(Voitures.fromJson(element)) ;
    });
  }
  return voiture;
}

Future<List<Conducteur>>  getConducteur() async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/list-conducteurs');
  List<Conducteur> Liste_conducteur = [];
  final response = await http.get(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.acceptHeader: 'application/json',
    },
  );
  print(response.body);
  print(response.statusCode);

  if(response.statusCode == 200){
    List<dynamic> body = json.decode(response.body);
    body.forEach((element) {
      Liste_conducteur.add(Conducteur.fromJson(element)) ;
    });
  }
  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
        },
      );

      print(newResponse.body);
      print(newResponse.statusCode);
      List<dynamic> body = json.decode(newResponse.body);
      body.forEach((element) {
        Liste_conducteur.add(Conducteur.fromJson(element)) ;
      });
    }
  }
  return Liste_conducteur;
}


Future <void> Add_Alerte(String alerte_name,String alerte_car_informations,String alerte_email, String alerte_type,String alerte_telephone,String alerte_date) async {
  var url = Uri.http('${Configuration.base_url}', 'apiv2/add-alerte');

  final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
      },
      body: json.encode({
        "alerte_name": alerte_name,
        "alerte_car_informations": alerte_car_informations,
        "alerte_email": alerte_email,
        "alerte_type": alerte_type,
        "alerte_telephone": alerte_telephone,
        "alerte_date": alerte_date,
      })
  );
  if (response.statusCode == 301) {
    final newUrl = response.headers['location'];
    if (newUrl != null) {
      // Make a new request to the new URL
      final newResponse = await http.post(Uri.parse(newUrl),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          },
          body: json.encode({
            "alerte_name": alerte_name,
            "alerte_car_informations": alerte_car_informations,
            "alerte_email": alerte_email,
            "alerte_type": alerte_type,
            "alerte_telephone": alerte_telephone,
            "alerte_date": alerte_date,
          })
      );

      // Process the new response
      print(newResponse.statusCode);
      print(newResponse.body);
    }
  }
}
