
class Users {
  final int id,bonus;
  final String username,lastname,firstname,city,address,type_identifier,
      identifier,phone_number,email,token,bonus_expiration;

  Users({
    required this.id,
    required this.username,
    required this.lastname,
    required this.firstname,
    required this.city,
    required this.address,
    required this.type_identifier,
    required this.identifier,
    required this.phone_number,
    required this.email,
    required this.token,
    required this.bonus,
    required this.bonus_expiration,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      username: json['username'],
      lastname: json['lastname'],
      firstname: json['firstname'],
      city: json['city'],
      address: json['address'],
      type_identifier: json['type_identifier'],
      identifier: json['identifier'],
      phone_number: json['phone_number'],
      email: json['email'],
      token: json['token'],
      bonus: json['bonus'],
      bonus_expiration: json['bonus_expiration']?? "Vide",

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['lastname'] = this.lastname;
    data['firstname'] = this.firstname;
    data['city'] = this.city;
    data['address'] = this.address;
    data['type_identifier'] = this.type_identifier;
    data['identifier'] = this.identifier;
    data['phone_number'] = this.phone_number;
    data['email'] = this.email;
    data['token'] = this.token;
    data['bonus'] = this.bonus;
    data['bonus_expiration'] = this.bonus_expiration;
    return data;
  }


}

