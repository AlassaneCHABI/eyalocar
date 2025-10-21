import 'package:flutter/material.dart';


class SliderModel{

  String imageAssetPath;
  String title;
  String desc;

  SliderModel({required this.imageAssetPath,required this.title,required this.desc});

  void setImageAssetPath(String getImageAssetPath){
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle){
    title = getTitle;
  }

  void setDesc(String getDesc){
    desc = getDesc;
  }

  String getImageAssetPath(){
    return imageAssetPath;
  }

  String getTitle(){
    return title;
  }

  String getDesc(){
    return desc;
  }

}


List<SliderModel> getSlides(){

  List<SliderModel> slides = <SliderModel>[];
  SliderModel sliderModel = new SliderModel(imageAssetPath: '', title: '', desc: '');

  //1
  sliderModel.setDesc("Trouvez les vehicules que vous recherchez en quelques clics.");
  sliderModel.setTitle("Louer un véhicule");
  sliderModel.setImageAssetPath("assets/illustration.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel(imageAssetPath: '', title: '', desc: '');

  //2
  sliderModel.setDesc("Mettez à disposition de professionnels votre véhicule et faites-vous des gains.");
  sliderModel.setTitle("Louez votre véhicule");
  sliderModel.setImageAssetPath("assets/location.PNG");
  slides.add(sliderModel);

  sliderModel = new SliderModel(imageAssetPath: '', title: '', desc: '');

  //3
  sliderModel.setDesc("Recevez à 30 jours d’expiration de vos pieces des rappels journaliers en vous inscrivant gratuitement à nos programmes d'alertes.");
  sliderModel.setTitle("Services Alertes");
  sliderModel.setImageAssetPath("assets/alerte.PNG");
  slides.add(sliderModel);

  sliderModel = new SliderModel(imageAssetPath: '', title: '', desc: '');

  return slides;
}