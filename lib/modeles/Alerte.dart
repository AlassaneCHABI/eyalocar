
class Alerte {
  final int id;
  final String alerte_name,alerte_car_informations,alerte_email,alerte_type,alerte_telephone,alerte_date;

  Alerte({
    required this.id,
    required this.alerte_name,
    required this.alerte_car_informations,
    required this.alerte_email,
    required this.alerte_type,
    required this.alerte_telephone,
    required this.alerte_date,

  });

  factory Alerte.fromJson(Map<String, dynamic> json) {
    return Alerte(
      id: json['id'],
      alerte_name: json['alerte_name'],
      alerte_car_informations: json['alerte_car_informations'],
      alerte_email: json['alerte_email'],
      alerte_type: json['alerte_type'],
      alerte_telephone: json['alerte_telephone'],
      alerte_date: json['alerte_date'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['alerte_name'] = this.alerte_name;
    data['alerte_car_informations'] = this.alerte_car_informations;
    data['alerte_email'] = this.alerte_email;
    data['alerte_type'] = this.alerte_type;
    data['alerte_telephone'] = this.alerte_telephone;
    data['alerte_date'] = this.alerte_date;
    return data;
  }

}

