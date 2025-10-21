
class Conducteur_reponse {
  final int id,rrdriver_id,request_id;
  final String driver_firstname,driver_lastname,driver_email,driver_city,
      driver_type,driver_address,driver_phone_number,driver_photo,driver_status,
      created_at,driver_year,status;

  Conducteur_reponse({
    required this.id,
    required this.rrdriver_id,
    required this.request_id,
    required this.driver_type,
    required this.driver_firstname,
    required this.driver_lastname,
    required this.driver_email,
    required this.driver_city,
    required this.driver_address,
    required this.driver_phone_number,
    required this.driver_photo,
    required this.driver_status,
    required this.created_at,
    required this.driver_year,
    required this.status,
  });

  factory Conducteur_reponse.fromJson(Map<String, dynamic> json) {
    return Conducteur_reponse(
      id: json['id'],
      rrdriver_id: json['rrdriver_id'],
      request_id: json['request_id'],
      driver_type: json['driver_type'],
      driver_firstname: json['driver_firstname'],
      driver_lastname: json['driver_lastname'],
      driver_email: json['driver_email'],
      driver_city: json['driver_city'],
      driver_address: json['driver_address'],
      driver_phone_number: json['driver_phone_number'],
      driver_photo: json['driver_photo'],
      driver_status: json['driver_status'],
      created_at: json['created_at'],
      driver_year: json['driver_year'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rrdriver_id'] = this.rrdriver_id;
    data['request_id'] = this.request_id;
    data['driver_type'] = this.driver_type;
    data['driver_firstname'] = this.driver_firstname;
    data['driver_lastname'] = this.driver_lastname;
    data['driver_email'] = this.driver_email;
    data['driver_city'] = this.driver_city;
    data['driver_address'] = this.driver_address;
    data['driver_phone_number'] = this.driver_phone_number;
    data['driver_photo'] = this.driver_photo;
    data['driver_status'] = this.driver_status;
    data['created_at'] = this.created_at;
    data['driver_year'] = this.driver_year;
    data['status'] = this.status;
    return data;
  }

}

