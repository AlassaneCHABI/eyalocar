
class Conducteur {
  final int id;
  final String driver_photo,driver_type,driver_year;

  Conducteur({
    required this.id,
    required this.driver_type,
    required this.driver_photo,
    required this.driver_year,
  });

  factory Conducteur.fromJson(Map<String, dynamic> json) {
    return Conducteur(
      id: json['id'],
      driver_type: json['driver_type'],
      driver_photo: json['driver_photo'],
      driver_year: json['driver_year'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['driver_type'] = this.driver_type;
    data['driver_photo'] = this.driver_photo;
    data['driver_year'] = this.driver_year;
    return data;
  }

}

