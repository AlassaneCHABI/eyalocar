
class Request_conducteur {
  final int id,user_id;
  final String tranche_age,permis,created_at,status;

  Request_conducteur({
    required this.id,
    required this.user_id,
    required this.tranche_age,
    required this.permis,
    required this.status,
    required this.created_at,
  });

  factory Request_conducteur.fromJson(Map<String, dynamic> json) {
    return Request_conducteur(
      id: json['id'],
      user_id: json['user_id'],
      tranche_age: json['tranche_age'],
      permis: json['permis'],
      status: json['status'],
      created_at: json['created_at'],

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.user_id;
    data['tranche_age'] = this.tranche_age;
    data['permis'] = this.permis;
    data['status'] = this.status;
    data['created_at'] = this.created_at;
    return data;
  }

}

