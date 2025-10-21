
class Request_cars {
  final int id,user_id,year_minimum,year_maximum,budget;
  final String status,created_at;

  Request_cars({
    required this.id,
    required this.user_id,
    required this.year_minimum,
    required this.year_maximum,
    required this.budget,
    required this.status,
    required this.created_at,
  });

  factory Request_cars.fromJson(Map<String, dynamic> json) {
    return Request_cars(
      id: json['id'],
      user_id: json['user_id'],
      year_minimum: json['year_minimum'],
      year_maximum: json['year_maximum'],
      budget: json['budget'],
      status: json['status'],
      created_at: json['created_at'],

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.user_id;
    data['year_minimum'] = this.year_minimum;
    data['year_maximum'] = this.year_maximum;
    data['budget'] = this.budget;
    data['status'] = this.status;
    data['created_at'] = this.created_at;
    return data;
  }

}

