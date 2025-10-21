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

class AddCarScreen extends StatefulWidget {
  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();
  String? car_name;
  int? car_category;
  String? car_price;
  String? car_reg_no;
  String? car_features;
  String? car_year;
  bool v_year=false;
  bool remember = false;
  //TextEditingController car_year = TextEditingController();
  late TextEditingController _documentController = TextEditingController();
  final List<String?> errors = [];
  final List<Category> liste_Category = [];
  XFile? car_exterior_img;
  XFile? car_interior_img;
  XFile? car_front_img;
  XFile? car_rear_img;
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile;
  DateTime now = DateTime.now();
  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  /* Future<void> requestPermissions() async {
    final PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission is granted, you can use path_provider now
    } else {
      // Permission denied, handle accordingly
    }
  }
*/



  // void _openGallery(BuildContext context,int index) async {
  //   final XFile? pickedImage =
  //   await _picker.pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     if(index==1){
  //       car_exterior_img = pickedImage!;
  //     }else if(index==2){
  //       car_interior_img = pickedImage!;
  //     }else if(index==3){
  //       car_front_img = pickedImage!;
  //     }else if(index==4){
  //       car_rear_img = pickedImage!;
  //     }
  //
  //   });
  //   Navigator.pop(context);
  //
  // }
  final List<XFile?> uploadedImages = []; // Liste pour stocker les images uploadées
  XFile? selectedImage; // Image sélectionnée à afficher en grand

  void _openGallery(BuildContext context, int index) async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        if (uploadedImages.length == 0) {
          car_exterior_img = pickedImage; // Première image
        } else if (uploadedImages.length == 1) {
          car_interior_img = pickedImage; // Deuxième image
        } else if (uploadedImages.length == 2) {
          car_front_img = pickedImage; // Troisième image
        } else if (uploadedImages.length == 3) {
          car_rear_img = pickedImage; // Quatrième image
        }
        // if (uploadedImages.length < 4) {
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
          car_exterior_img = pickedPhoto; // Première image
        } else if (uploadedImages.length == 1) {
          car_interior_img = pickedPhoto; // Deuxième image
        } else if (uploadedImages.length == 2) {
          car_front_img = pickedPhoto; // Troisième image
        } else if (uploadedImages.length == 3) {
          car_rear_img = pickedPhoto; // Quatrième image
        }
        // if (uploadedImages.length < 4) {
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


  // Fonction pour sélectionner une image à afficher en grand
  void _selectImage(XFile image) {
    setState(() {
      selectedImage = image;
    });
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
                  _openCamera(context,index);
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

  Future<File?> AddAVehicule(
      String carName,
      int carCategory,
      String carPrice,
      String carRegNo,
      String carYear,
      String carFeatures,
      String token,
      /*XFile carExteriorImg,
      XFile carInteriorImg,
      XFile carFrontImg,
      XFile carRearImg,*/
      ) async {

    //showAlertDialog(context);

    print("Les details ");
    print(carCategory);
    print(carPrice);
    print(carRegNo);
    print(carYear);
    print(carFeatures);
    print(token);
    /*print(carExteriorImg.path);
    print(carFrontImg.path);
    print(carRearImg.path);*/

    var request = http.MultipartRequest('POST', Uri.parse('${Configuration.base_url_}/apiv2/add-cars',),);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';
    /*Srequest.files.add(await http.MultipartFile.fromPath('car_exterior_img', carExteriorImg.path));
    request.files.add(await http.MultipartFile.fromPath('car_front_img', carFrontImg.path));
    request.files.add(await http.MultipartFile.fromPath('car_rear_img', carRearImg.path));
    request.files.add(await http.MultipartFile.fromPath('car_interior_img', carInteriorImg.path));*/
    request.fields['car_category'] = carCategory.toString();
    request.fields['car_price'] = carPrice;
    request.fields['car_reg_no'] = carRegNo;
    request.fields['car_year'] = carYear.toString();
    request.fields['car_features'] = carFeatures;
    request.fields['car_name'] = carName;

    try{
      var response = await request.send();
      print("le status: ${response.statusCode}");
      var responseBody = await response.stream.bytesToString();
      print("Le retour: $responseBody");
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
              content: Text("Le véhicule a été ajouté avec succès.", textAlign: TextAlign.center,),
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

        Navigator.of(context).pop();
        showDialog(
          context: this.context,
          barrierDismissible: false,
          builder: (BuildContext ctx) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
                title: Text("Enregistrement"),
                content: Text("Le véhicule n’a pas été ajouté. Veuillez vérifier les données et réessayer.", textAlign: TextAlign.center,),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => EntryScreen()));
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
                  'assets/images/warning_img.png',
                  width: 80,
                  height: 80,
                ),
              ), onPopInvoked : (didPop){
              // logic
            },
            );
          },
        );
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
        child: Scaffold(
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
                  'Ajouter un véhicule',
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
                      _buildCarNameTextField(),
                      SizedBox(height: 20),
                      _buildCarCategoryDropdown(),
                      SizedBox(height: 20),
                      _buildCarPriceTextField(),
                      SizedBox(height: 20),
                      _buildCarImmatriculationTextField(),
                      SizedBox(height: 20),
                      _buildCarYearTextField(),
                      v_year?Text("Cette valeur doit être supérieur ou égale à ${now.year-5} et inférieur ou égale à ${now.year}",style: TextStyle(color: Colors.red),):Text(""),
                      SizedBox(height: 20),
                      _buildCarDetailsTextField(),
                      SizedBox(height: 20),
                      FormError(errors: errors),
                      SizedBox(height: 20),
                      /*
                      SizedBox(
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
                                children: List.generate(4, (index) {
                                  return Expanded(
                                    child: GestureDetector(
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
                                    ),
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
                      ),
                      */
                     /* Container(
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
                                _buildImageContainer(0),
                                _buildImageContainer(1),
                                _buildImageContainer(2),
                                _buildImageContainer(4),
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
                      ),*/
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              showAlertDialog(context);
                              SharedPreferences prefs = await SharedPreferences
                                  .getInstance();
                              var token = prefs.get("token");
                              print(token);

                              if (int.parse(car_year!) < (now.year - 5) ||
                                  int.parse(car_year!) > now.year) {
                                print("pas maintenant");
                                setState(() {
                                  v_year = true;
                                });
                                Navigator.of(context).pop();
                              } else {
                                setState(() {
                                  v_year = false;
                                });
                                AddAVehicule(
                                    car_name!,
                                    car_category!,
                                    car_price!,
                                    car_reg_no!,
                                    car_year!,
                                    car_features!,
                                    token.toString(),
                                    /*car_exterior_img!,
                                    car_interior_img!,
                                    car_front_img!,
                                    car_rear_img!*/);
                              }
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
      //print("Ajouter une photo");
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
                height: 80,
                width: MediaQuery.of(context).size.width / 6,
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

  Widget _buildCarCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Catégorie de véhicule",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(80)),
          ),
          child: DropdownButton<int?>(
            isExpanded: true,
            hint: const Text(
              'Sélectionner la catégorie',
            ),
            onChanged: (value) {
              setState(() {
                car_category = value;
              });
            },
            items: liste_Category.map((item) {
              return DropdownMenuItem<int?>(
                value: item.id,
                child: Text(item.category_name),
              );
            }).toList(),
            value: car_category,
            underline: SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildCarNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Nom du véhicule",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          // keyboardType: TextInputType.phone,
          onSaved: (newValue) => car_name = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kcar_nameNullError);
            }
            car_name = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kcar_nameNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Nom du véhicule",
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

  Widget _buildCarImmatriculationTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Numéro d'immatriculation",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          onSaved: (newValue) => car_reg_no = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kAcar_reg_noNullError);
            }
            car_reg_no = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kAcar_reg_noNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "N° d'immatriculation",
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

  Widget _buildCarPriceTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Prix du véhicule",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          keyboardType: TextInputType.number,
          onSaved: (newValue) => car_price = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kcar_priceNullError);
            }
            car_price = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kcar_priceNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Prix",
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

  Widget _buildCarYearTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Année du véhicule",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          keyboardType: TextInputType.number,
          onSaved: (newValue) => car_year = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kcar_yearNullError);
            }
            car_year = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kcar_yearNullError);
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

  Widget _buildCarDetailsTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   "Caractéristiques du véhicule",
        //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        // ),
        // SizedBox(height: 8,),
        TextFormField(
          onSaved: (newValue) => car_features = newValue,
          onChanged: (value) {
            if (value.isNotEmpty) {
              removeError(error: kcar_featuresNullError);
            }
            car_features = value;
          },
          validator: (value) {
            if (value!.isEmpty) {
              addError(error: kcar_featuresNullError);
              return "";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "Caractéristiques",
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),

          ),
          maxLines: 3,
        ),
      ],
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return PopScope(
            canPop: false,
            child: AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text("Ajout du véhicule ..."),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialogue
              },
              child: Text("Fermer"),
            ),
          ],
        ),onPopInvoked : (didPop){
          // logic
        },
        );
      },
    );
  }



}
