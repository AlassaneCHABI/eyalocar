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



  void _openGallery(BuildContext context,int index) async {
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(index==1){
        car_exterior_img = pickedImage!;
      }else if(index==2){
        car_interior_img = pickedImage!;
      }else if(index==3){
        car_front_img = pickedImage!;
      }else if(index==4){
        car_rear_img = pickedImage!;
      }

    });
    Navigator.pop(context);

  }

  void _openCamera(BuildContext context,int index) async {
    final XFile? pickedPhoto =
    await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(index==1){
        car_exterior_img = pickedPhoto!;
      }else if(index==2){
        car_interior_img = pickedPhoto!;
      }else if(index==3){
        car_front_img = pickedPhoto!;
      }else if(index==4){
        car_rear_img = pickedPhoto!;
      }
    });
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

  Future<File?> AddAVehicule(
      String carName,
      int carCategory,
      String carPrice,
      String carRegNo,
      String carYear,
      String carFeatures,
      String token,
      XFile carExteriorImg,
      XFile carInteriorImg,
      XFile carFrontImg,
      XFile carRearImg,
     ) async {

    showAlertDialog(context);

    print("Les details ");
    print(carCategory);
    print(carPrice);
    print(carRegNo);
    print(carYear);
    print(carFeatures);
    print(token);
    print(carExteriorImg.path);
    print(carFrontImg.path);
    print(carRearImg.path);

    var request = http.MultipartRequest('POST', Uri.parse('${Configuration.base_url_}/apiv2/add-cars',),);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.files.add(await http.MultipartFile.fromPath('car_exterior_img', carExteriorImg.path));
    request.files.add(await http.MultipartFile.fromPath('car_front_img', carFrontImg.path));
    request.files.add(await http.MultipartFile.fromPath('car_rear_img', carRearImg.path));
    request.files.add(await http.MultipartFile.fromPath('car_interior_img', carInteriorImg.path));
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
        showDialog(
          context: this.context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              title: Text("Enregistrement"),
              content: Text("Le véhicule a été ajouté avec succès.", textAlign: TextAlign.center,),
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

          Container(child: Text(("AJOUTER UNE VOITURE"), style: TextStyle(color: kPrimaryColor,fontSize: 20),),),
          SizedBox(height: 20),
          buildcar_nameFormField(),
          SizedBox(height: 20),
          DropdownButtonFormField(
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500),
            hint: const Text(
              'Selectionner la categorie',
            ),
            isExpanded: true,
            onChanged: (value) {
              setState(() {
                car_category = value!.id;
              });
            },
            items: liste_Category.map((item) =>
                DropdownMenuItem(
                    value: item,
                    child: Text('${item.category_name}',
                    ))).toList(),
            validator: (value) => (value==null)?"Selectionner la categorie":null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  vertical: 1,
                  horizontal: 10),
            ),
          ),

          SizedBox(height: 20),
          buildcar_priceFormField(),
          SizedBox(height: 20),
          buildcar_reg_noFormField(),
          SizedBox(height: 20),
          buildanneFormField(),
          SizedBox(height: 20),
          v_year?Text("Cette valeur doit être supérieur ou égale à ${now.year-5} et inférieur ou égale à ${now.year}",style: TextStyle(color: Colors.red),):Text(""),

          /*TextFormField(
            controller: car_year,
            decoration: InputDecoration(
              labelText: 'Année du véhicule',
              suffixIcon: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),
            keyboardType: TextInputType.datetime,
            onTap: () => _selectDate(context),
          ),*/
          SizedBox(height: 20),
          buildcar_featuresFormField(),
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
              Text('Image extérieure de la voiture',style: TextStyle(color: kPrimaryColor),),
              SizedBox(width: 15,),
              Icon(
              Icons.camera_alt_outlined,
              //color: Colors.red,
              size: 30,
                color: kPrimaryColor,
            ),],) ,
          ),
          SizedBox(height: 20),
          car_exterior_img==null?Text(""):
          Image.file(File(car_exterior_img!.path),height: 150),
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
              Text('Image intérieure de la voiture',style: TextStyle(color: kPrimaryColor),),
              SizedBox(width: 20,),
              Icon(
              Icons.camera_alt_outlined,
              //color: Colors.red,
              size: 30,
                color: kPrimaryColor,
            ),],) ,
          ),
          SizedBox(height: 20),
          car_interior_img==null?Text(""):
          Image.file(File(car_interior_img!.path),height: 150),
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
              Text('Image avant de la voiture',style: TextStyle(color: kPrimaryColor),),
              SizedBox(width: 50,),
              Icon(
              Icons.camera_alt_outlined,
              //color: Colors.red,
              size: 30,
                color: kPrimaryColor,
            ),],) ,
          ),
          SizedBox(height: 20),
          car_front_img==null?Text(""):
          Image.file(File(car_front_img!.path),height: 150),

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
              modalBottomMenu(context,4);
            },
            child:Row(children: [
              Text('Image arrière de la voiture',style: TextStyle(color: kPrimaryColor),),
              SizedBox(width: 50,),
              Icon(
              Icons.camera_alt_outlined,
              //color: Colors.red,
              size: 30,
                color: kPrimaryColor,
            ),],) ,
          ),
          SizedBox(height: 20),
          car_rear_img==null?Text(""):
          Image.file(File(car_rear_img!.path),height: 150),
          SizedBox(height: getProportionateScreenHeight(30)),

          FormError(errors: errors),
          DefaultButton(
            text: "AJOUTER ",
            press: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                showAlertDialog(context);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var token =prefs.get("token");
                print(token);

                if(int.parse(car_year!) < (now.year-5) || int.parse(car_year!) > now.year ){
                  setState(() {
                    v_year=true;
                  });
                }else{
                  AddAVehicule(car_name!,car_category!,car_price!,car_reg_no!,car_year!,car_features!,token.toString(),car_exterior_img!,car_interior_img!,car_front_img!,car_rear_img!);
                }

                //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
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
          Container(margin: EdgeInsets.only(left: 5),child:Text("Ajout du véhicule ....." )),
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
        //labelText: "Nom du véhicule",
        hintText: "Entrez le nom du véhicule",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }



  TextFormField buildcar_priceFormField() {
    return TextFormField(
      obscureText: false,
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
      //  labelText: "Prix",
        hintText: "Entrez le prix",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/adresse.svg"),
      ),
    );
  }

  TextFormField buildcar_reg_noFormField() {
    return TextFormField(
      obscureText: false,
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
     //   labelText: "Immatriculation ",
        hintText: "Entrez votre Immatriculation",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/about.svg"),
      ),
    );
  }

  TextFormField buildcar_featuresFormField() {
    return TextFormField(
      obscureText: false,
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
     //   labelText: "Caractéristiques",
        hintText: "Entrez les Caractéristiques",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildanneFormField() {
    return TextFormField(
      keyboardType: TextInputType.number,
      obscureText: false,
      onSaved: (newValue) =>  car_year= newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kVilleNullError);
        }
        car_year = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kVilleNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
       // labelText: "Ville",
        hintText: "Entrez l'année du véhicule",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        //suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/city.svg"),
      ),
    );
  }

}
