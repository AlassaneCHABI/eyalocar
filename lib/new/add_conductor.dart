import 'dart:io';

import 'package:eyav2/components/form_error.dart';
import 'package:eyav2/constants.dart';
import 'package:eyav2/function/function.dart';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/new/drawer.dart';
import 'package:eyav2/new/entry_screen.dart';
import 'package:eyav2/new/sign-in.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddConductorScreen extends StatefulWidget {
  @override
  State<AddConductorScreen> createState() => _AddConductorScreenState();
}

class _AddConductorScreenState extends State<AddConductorScreen> {
  final _formKey = GlobalKey<FormState>();
  String? driver_lastname;
  String? driver_firstname;
  String? driver_phone_number;
  String? driver_email;
  String? driver_address;
  String? driver_city;
  String? driver_user;
  String? driver_year;
  bool remember = false;
  TextEditingController car_year = TextEditingController();
  late TextEditingController _documentController = TextEditingController();
  final List<String?> errors = [];
  final List<Category> liste_Category = [];
  XFile? driver_cip;
  XFile? driver_photo;
  XFile? driver_permis;

  List<String> driver_type = ['Permis B','Permis C','Permis D'];
  String? selectedOption_type_conducteur = 'Permis B';
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  bool imageupload = false;
  DateTime now = DateTime.now();
  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }


  final List<XFile?> uploadedImages = []; // Liste pour stocker les images uploadées
  XFile? selectedImage; // Image sélectionnée à afficher en grand

  // Fonction pour ouvrir la galerie et ajouter une image
  // void _openGallery(BuildContext context) async {
  //   final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
  //   if (pickedImage != null) {
  //     setState(() {
  //       uploadedImages.add(pickedImage); // Ajouter l'image à la liste
  //       if (uploadedImages.length == 1) {
  //         selectedImage = pickedImage; // Afficher la première image par défaut
  //       }
  //     });
  //   }
  //   Navigator.pop(context);
  // }

  // Fonction pour sélectionner une image à afficher en grand
  void _selectImage(XFile image) {
    setState(() {
      selectedImage = image;
    });
  }

  // void _openCamera(BuildContext context,int index) async {
  //   final XFile? pickedPhoto =
  //   await _picker.pickImage(source: ImageSource.camera);
  //   if (pickedPhoto != null) {
  //     setState(() {
  //       if(index==1){
  //         driver_cip = pickedPhoto!;
  //       }else if(index==2){
  //         driver_photo = pickedPhoto!;
  //       }else if(index==3){
  //         driver_permis = pickedPhoto!;
  //       }
  //     });
  //   }
  //   Navigator.pop(context);
  // }

  void _openGallery(BuildContext context, int index) async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        if (uploadedImages.length == 0) {
          driver_cip = pickedImage; // Première image
        } else if (uploadedImages.length == 1) {
          driver_photo = pickedImage; // Deuxième image
        } else if (uploadedImages.length == 2) {
          driver_permis = pickedImage; // Troisième image
        }
        // if (uploadedImages.length < 3) {
        //   uploadedImages.add(pickedImage); // Ajouter l'image à la liste
        //   selectedImage = pickedImage; // Afficher la dernière image ajoutée
        // }
        if (uploadedImages.length > index - 1) {
          uploadedImages[index - 1] = pickedImage;
        } else {
          uploadedImages.add(pickedImage);
        }

        selectedImage = pickedImage;
      });
    }
    Navigator.pop(context);
  }

  void _openCamera(BuildContext context, int index) async {
    final XFile? pickedPhoto = await _picker.pickImage(source: ImageSource.camera);
    if (pickedPhoto != null) {
      setState(() {
        if (uploadedImages.length == 0) {
          driver_cip = pickedPhoto; // Première image
        } else if (uploadedImages.length == 1) {
          driver_photo = pickedPhoto; // Deuxième image
        } else if (uploadedImages.length == 2) {
          driver_permis = pickedPhoto; // Troisième image
        }
        // if (uploadedImages.length < 3) {
        //   uploadedImages.add(pickedPhoto); // Ajouter l'image à la liste
        //   selectedImage = pickedPhoto; // Afficher la dernière image ajoutée
        // }
        if (uploadedImages.length > index - 1) {
          uploadedImages[index - 1] = pickedPhoto;
        } else {
          uploadedImages.add(pickedPhoto);
        }

        selectedImage = pickedPhoto;
      });
    }
    Navigator.pop(context);
  }

  void modalBottomMenu(BuildContext context,int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(10.0),
              topRight: const Radius.circular(10.0),
            ),
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  _openCamera(context, index);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Gallery'),
                onTap: () {
                  _openGallery(context, index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File?> Send_conducteur( String driver_lastname,
      String driver_firstname,
      String driver_type,
      String driver_phone_number,
      String driver_email,
      String driver_address,
      String driver_city,
      String token,
      String driver_year,
      XFile driver_cip,
      XFile driver_photo,
      XFile driver_permis,
     ) async {

          showAlertDialog(context);

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
          request.fields['driver_year'] = driver_year;

          try{
            var response = await request.send();
            print("le status");
            if (response.statusCode == 200) {
              print('File uploaded successfully');
              Navigator.of(context).pop();
              showDialog(
                context: this.context,
                barrierDismissible: false,
                builder: (BuildContext ctx) {
                  return PopScope(
                      canPop: false,
                      child: AlertDialog(
                    title: Text("Enregistrement"),
                    content: Text("Le conducteur a été ajouté avec succès.", textAlign: TextAlign.center,),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EntryScreen()));
                        },
                        child: const Text('OK'),
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(15),
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                            backgroundColor: MaterialStateProperty.all(vertFonceColor),
                            shadowColor: MaterialStateProperty.all(vertFonceColor),
                            padding: MaterialStateProperty.all(const EdgeInsets.all(5)),
                            fixedSize: MaterialStateProperty.all(const Size(100, 40))),
                      ),
                    ],
                    actionsAlignment: MainAxisAlignment.center,
                    icon: Image.asset(
                      'assets/images/checked_img.png',
                      width: 80,
                      height: 80,
                    ),
                  ), onPopInvoked : (didPop){
                    // logic
                  },
                  );
                },
              );

              ///Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        car_year.text = picked.toString().substring(0, 10);
      });
    }
  }


  @override
  void initState() {
    super.initState();
    getCategorie().then((value){
      if(value!=null){
        setState(() {
          liste_Category.addAll(value);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child:Scaffold(
      appBar: AppBar(
        title: Text("", style: TextStyle(fontFamily: "Ubuntu", fontSize: 22, fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: CustomDrawer(),

      body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ajouter un conducteur',
                      style: TextStyle(fontFamily: "Ubuntu", fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDriverLastnameTextField(),
                          SizedBox(height: 8),
                          _buildDriverFirstnameTextField(),
                          SizedBox(height: 8),
                          _buildDriverTypeDropdown(),
                          SizedBox(height: 8),
                          _buildDriverEmailTextField(),
                          SizedBox(height: 8),
                          _buildDriverAddressTextField(),
                          SizedBox(height: 8),
                          _buildDriverCityTextField(),
                          SizedBox(height: 8),
                          _buildDriverNumTextField(),
                          SizedBox(height: 8),
                          _buildDriverExpYearTextField(),
                          SizedBox(height: 8),
                          FormError(errors: errors),
                          SizedBox(height: 20),
                          /*SizedBox(
                            // width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                modalBottomMenu(context,1);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: greenThemeColor,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80),
                                ),
                              ),
                              child: const Text("+ Photos", style: TextStyle(color: Colors.white, fontSize: 18),),
                            ),
                          ),
                          SizedBox(height: 20,),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFD9FFD9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 100,
                                  child: Row(
                                    children: List.generate(3, (index) {
                                        return Expanded(
                                          child: _buildImagePicker(index),
                                          /*GestureDetector(
                                            onTap: () {
                                              if (index < uploadedImages.length && uploadedImages[index] != null) {
                                                _selectImage(uploadedImages[index]!); // Sélectionner l'image à afficher en grand
                                              }
                                            },
                                            child: Container(
                                              height: 80,
                                              padding: EdgeInsets.all(5),
                                              margin: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                                // border: Border.all(color: Colors.grey),
                                              ),
                                              child: uploadedImages.length > index && uploadedImages[index] != null
                                                  ? Image.file(File(uploadedImages[index]!.path), fit: BoxFit.cover)
                                                  : Icon(Icons.image, size: 60, color: Colors.grey), // Si aucune image
                                            ),
                                          ),*/
                                        );},),
                                  ),
                                ),

                                SizedBox(height: 20,),

                                // Afficher l'image sélectionnée en grand
                                selectedImage != null
                                    ? Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        height: 200,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Image.file(File(selectedImage!.path), fit: BoxFit.cover),
                                      )
                                    : Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Center(child: Text("Sélectionnez une image")),
                                      ),

                              ],
                            ),
                          ),*/
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFD9FFD9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildImageContainer(0), // Container pour CIP
                                    _buildImageContainer(1), // Container pour Photo
                                    _buildImageContainer(2), // Container pour Permis
                                  ],
                                ),
                                SizedBox(height: 20,),
                                selectedImage != null
                                    ? Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        height: 200,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Image.file(File(selectedImage!.path), fit: BoxFit.cover),
                                      )
                                    : Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Center(child: Text("Sélectionnez une image")),
                                      ), // Affichage de l'image sélectionnée
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  var token =prefs.get("token");
                                  print(token);
                                  Send_conducteur(driver_lastname!,driver_firstname!,selectedOption_type_conducteur.toString()!,driver_phone_number!,driver_email!,driver_address!,driver_city!,token.toString(),driver_year!,driver_cip!,driver_photo!,driver_permis!);
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: greenThemeColor,
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Valider", style: TextStyle(color: Colors.white, fontSize: 16),),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    // HaveAccountText(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
    ), onPopInvoked : (didPop){
      // logic
    },
    );
  }

  Widget _buildImageContainer(int index) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (index < uploadedImages.length && uploadedImages[index] != null) {
              _selectImage(uploadedImages[index]!); // Sélectionner l'image à afficher en grand
            }
          },
          child: Column(
            children: [
              SizedBox(height: 10,),
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width / 4,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  // border: Border.all(color: Colors.grey),
                ),
                child: uploadedImages.length > index && uploadedImages[index] != null
                    ? Image.file(File(uploadedImages[index]!.path), fit: BoxFit.cover)
                    : Icon(Icons.image, size: 60, color: Colors.grey), // Icône si aucune image
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Center(
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle
              ),
              child: Center(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.edit, size: 20, color: Colors.white),
                  onPressed: () {
                    modalBottomMenu(context, index + 1); // Ouvrir le menu pour modifier l'image
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildImagePicker(int index) {
    return GestureDetector(
      onTap: () {
        modalBottomMenu(context, index); // Ouvre l'option pour sélectionner une image
      },
      child: Container(
        height: 80,
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            // Affiche l'image si elle existe
            uploadedImages.length > index && uploadedImages[index] != null
                ? Image.file(File(uploadedImages[index]!.path), fit: BoxFit.cover, width: double.infinity)
                : Icon(Icons.image, size: 60, color: Colors.grey), // Si aucune image, affiche l'icône par défaut

            // Icône d'édition fixée en haut à droite
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: Icon(Icons.edit, color: Colors.black),
                onPressed: () {
                  modalBottomMenu(context, index);  // Permet de changer l'image
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverLastnameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Nom du conducteur",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          // keyboardType: TextInputType.phone,
          onSaved: (newValue) => driver_lastname = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kcar_nameNullError);
            }
            driver_lastname = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kcar_nameNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Nom",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverFirstnameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Prénom",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          obscureText: false,
          onSaved: (newValue) => driver_firstname = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kprenomNullError);
            }
            driver_firstname = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kprenomNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Prénom",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverAddressTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Adresse",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          obscureText: false,
          onSaved: (newValue) => driver_address = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kAddressNullError);
            }
            driver_address = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kAddressNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Adresse",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverCityTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Ville",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          obscureText: false,
          onSaved: (newValue) => driver_city = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kVilleNullError);
            }
            driver_city = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kVilleNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Ville ",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverEmailTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Email",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          onSaved: (newValue) => driver_email = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kEmailNullError);
            }
            driver_email = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kEmailNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Email",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverTypeDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Type de pièce d'identité",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(80)),
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectedOption_type_conducteur,
            onChanged: (String? newValue) {
              setState(() {
                selectedOption_type_conducteur = newValue;
              });
            },
            underline: SizedBox(), // Suppression de la ligne par défaut
            items: driver_type.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(value),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverExpYearTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Année du conducteur",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          keyboardType: TextInputType.number,
          onSaved: (newValue) => driver_year = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: ktelephoneNullError);
            }
            driver_year = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: ktelephoneNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Année",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDriverNumTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Numéro de téléphone",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          keyboardType: TextInputType.number,
          onSaved: (newValue) => driver_phone_number = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: ktelephoneNullError);
            }
            driver_phone_number = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: ktelephoneNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "N° de téléphone",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(80)),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ],
    );
  }


  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Ajout du conducteur ....." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }


}
