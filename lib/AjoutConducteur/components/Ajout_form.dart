import 'dart:async';
import 'dart:io';
import 'package:eyav2/global_config.dart';
import 'package:eyav2/modeles/Categorie.dart';
import 'package:eyav2/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:eyav2/components/default_button.dart';
import 'package:eyav2/components/form_error.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../../../size_config.dart';
import 'package:eyav2/function/function.dart';
import 'package:http/http.dart ' as http;

class AjoutForm extends StatefulWidget {
  @override
  _AjoutFormFormState createState() => _AjoutFormFormState();
}

class _AjoutFormFormState extends State<AjoutForm> {
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
                  _openGallery(context,index);
                },
              ),
            ],
          ),
        );
      },
    );
  }


/*  Future<void> _pickdriver_cipImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      File pickedImage = File(result.files.single.path!);

      setState(() {
        driver_cip = pickedImage;
      });

      print(driver_cip);


    }
  }

  Future<void> _pickdriver_photoImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      File pickedImage = File(result.files.single.path!);

      setState(() {
        driver_photo = pickedImage;
      });

      print(driver_photo);

      // Upload the image to a hosting service
      /*   final response = await http.post(
        Uri.parse('YOUR_UPLOAD_ENDPOINT'), // Replace with your hosting endpoint
        body: {
          'file': http.MultipartFile.fromBytes(
            'file',
            pickedImage.readAsBytesSync(),
            filename: 'image.jpg',
          ),
        },
      );

      if (response.statusCode == 200) {
        print('Image uploaded successfully.');
      } else {
        print('Failed to upload image.');
      }
      */
    }
  }

  Future<void> _pickdriver_permisImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      File pickedImage = File(result.files.single.path!);

      setState(() {
        driver_permis = pickedImage;
      });

      print(driver_permis);

      // Upload the image to a hosting service
      /*   final response = await http.post(
        Uri.parse('YOUR_UPLOAD_ENDPOINT'), // Replace with your hosting endpoint
        body: {
          'file': http.MultipartFile.fromBytes(
            'file',
            pickedImage.readAsBytesSync(),
            filename: 'image.jpg',
          ),
        },
      );

      if (response.statusCode == 200) {
        print('Image uploaded successfully.');
      } else {
        print('Failed to upload image.');
      }
      */
    }
  }

*/

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
      XFile driver_permis,) async {

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

        showDialog(
          context: this.context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: Text("Enregistrement"),
              content: Text("Le conducteur a été ajouté avec succès.", textAlign: TextAlign.center,),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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


  void _openGallery(BuildContext context,int index) async {
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(index==1){
        driver_cip = pickedImage!;
      }else if(index==2){
        driver_photo = pickedImage!;
      }else if(index==3){
        driver_permis = pickedImage!;
      }

    });
    Navigator.pop(context);

  }

  void _openCamera(BuildContext context,int index) async {
    final XFile? pickedPhoto =
    await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(index==1){
        driver_cip = pickedPhoto!;
      }else if(index==2){
        driver_photo = pickedPhoto!;
      }else if(index==3){
        driver_permis = pickedPhoto!;
      }
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          /*Material(

            child: Padding(padding: EdgeInsets.all(8.0),
              child:   Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 5, color: Colors.white),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(5, 5),),
                    ],
                  ),
                  child: Image.asset("assets/logo.jpg",height: 80,)
              ),
            ),
          ),*/
          Container(child: Text(("AJOUTER UN CONDUCTEUR"), style: TextStyle(color: kPrimaryColor,fontSize: 20),),),
          SizedBox(height: 20),
          buildcar_nameFormField(),
          SizedBox(height: 20),
          builddriver_firstnameFormField(),
          SizedBox(height: 20),
          DropdownButton<String>(
            isExpanded: true,
            value: selectedOption_type_conducteur,
            onChanged: (String? newValue) {
              setState(() {
                selectedOption_type_conducteur = newValue;
              });
            },
            items: driver_type.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          builddriver_emailFormField(),
          SizedBox(height: 20),
          builddriver_addressFormField(),
          SizedBox(height: 20),
          builddriver_cityFormField(),
          SizedBox(height: 20),
          builddriver_phone_numberFormField(),
          SizedBox(height: 20),
          builddriverdriver_yearFormField(),
          SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white30), // Set background color
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color
              /*padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0), // Set padding
              ),*/
              textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(fontSize: 16.0), // Set text style
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Set border radius
                ),
              ),
            ),
            onPressed: (){
              modalBottomMenu(context,1);
            },
            child:Row(children: [
              Text('Image CIP du conducteur ',style: TextStyle(color: kPrimaryColor),),
              SizedBox(width: 50,),
              Icon(
                Icons.camera_alt_outlined,
                //color: Colors.red,
                size: 30,
                color: kPrimaryColor,
              ),],) ,
          ),
          SizedBox(height: 20),
          driver_cip==null?Text(""):
          Image.file(File(driver_cip!.path),height: 150),
          SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white30), // Set background color
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color
              /*padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0), // Set padding
              ),*/
              textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(fontSize: 16.0), // Set text style
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Set border radius
                ),
              ),
            ),
            onPressed: (){
              modalBottomMenu(context,2);
            },
            child:Row(children: [
              Text('Image de profil conducteur',style: TextStyle(color: kPrimaryColor),),
              SizedBox(width: 40,),
              Icon(
                Icons.camera_alt_outlined,
                //color: Colors.red,
                size: 30,
                color: kPrimaryColor,
              ),],) ,
          ),
          SizedBox(height: 20),
          driver_photo==null?Text(""):
          Image.file(File(driver_photo!.path),height: 150),
          SizedBox(height: 20),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white30), // Set background color
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Set text color
              /*padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 80.0, vertical: 10.0), // Set padding
              ),*/
              textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(fontSize: 16.0), // Set text style
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Set border radius
                ),
              ),
            ),
            onPressed: (){
              modalBottomMenu(context,3);
            },
            child:Row(children: [
              Text('Image permis du conducteur',style: TextStyle(color: kPrimaryColor),),
              SizedBox(width: 30,),
              Icon(
                Icons.camera_alt_outlined,
                //color: Colors.red,
                size: 30,
                color: kPrimaryColor,
              ),],) ,
          ),
          SizedBox(height: 20),
          driver_permis==null?Text(""):
          Image.file(File(driver_permis!.path),height: 150),
          SizedBox(height: getProportionateScreenHeight(30)),

          FormError(errors: errors),
          DefaultButton(
            text: "AJOUTER ",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var token =prefs.get("token");
                print(token);
                Send_conducteur(driver_lastname!,driver_firstname!,selectedOption_type_conducteur.toString()!,driver_phone_number!,driver_email!,driver_address!,driver_city!,token.toString(),driver_year!,driver_cip!,driver_photo!,driver_permis!);
               // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              }
            },
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Enregistrement  ....." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  TextFormField buildcar_nameFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => driver_lastname
      = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kcar_nameNullError);
        }
        driver_lastname
        = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kcar_nameNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //labelText: "Nom du conducteur",
        hintText: "Entrez le nom du conducteur",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }



  TextFormField builddriver_firstnameFormField() {
    return TextFormField(
      obscureText: false,
      keyboardType: TextInputType.text,
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
        //labelText: "Prénom",
        hintText: "Entrez le prénom du conducteur",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/adresse.svg"),
      ),
    );
  }

 /* TextFormField builddriver_typeFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => driver_type = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAcar_reg_noNullError);
        }
        driver_type = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAcar_reg_noNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Type ",
        hintText: "Entrez le type de conduceteur",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/about.svg"),
      ),
    );
  }
*/
  TextFormField builddriver_phone_numberFormField() {
    return TextFormField(
      obscureText: false,
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
        //labelText: "Numéro",
        hintText: "Entrez le numéro du conducteur",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField builddriverdriver_yearFormField() {
    return TextFormField(
      obscureText: false,
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
        //labelText: "Numéro",
        hintText: "Entrez l'année du permis",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }


  TextFormField builddriver_emailFormField() {
    return TextFormField(
      obscureText: false,
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
      //  labelText: "Email",
        hintText: "Entrez le mail",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField builddriver_addressFormField() {
    return TextFormField(
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
        //labelText: "Adresse",
        hintText: "Entrez l'adresse du conducteur",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField builddriver_cityFormField() {
    return TextFormField(
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
        //labelText: "Ville",
        hintText: "Entrez la ville du conducteur",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

/*TextFormField buildVilleFormField() {
    return TextFormField(
      obscureText: false,
      onSaved: (newValue) => ville = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kVilleNullError);
        }
        ville = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kVilleNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Ville",
        hintText: "Entrez votre ville",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/city.svg"),
      ),
    );
  }*/

}
