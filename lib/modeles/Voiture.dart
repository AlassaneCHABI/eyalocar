
class Voitures {
  final int id,car_price,request_id,car_price_by_staff,rrcar_id;
  final String car_name,car_features,car_status,category_name,car_exterior_img,
      car_interior_img,car_rear_img,car_front_img,car_reg_no,status,car_year;

  Voitures({
    required this.id,
    required this.car_name,
    required this.car_features,
    required this.car_status,
    required this.car_price,
    required this.category_name,
    required this.car_exterior_img,
    required this.car_interior_img,
    required this.car_rear_img,
    required this.car_front_img,
    required this.car_reg_no,
    required this.request_id,
    required this.status,
    required this.car_price_by_staff,
    required this.car_year,
    required this.rrcar_id,

  });

  factory Voitures.fromJson(Map<String, dynamic> json) {
    return Voitures(
      id: json['id'],
      car_name: json['car_name'],
      car_features: json['car_features'],
      car_status: json['car_status'],
      car_price: json['car_price'],
      category_name: json['category_name'],
      car_exterior_img: json['car_exterior_img'],
      car_interior_img: json['car_interior_img'],
      car_rear_img: json['car_rear_img'],
      car_front_img: json['car_front_img'],
      car_reg_no: json['car_reg_no'],
      status: json['status'],
      request_id: json['request_id'],
      car_year: json['car_year'],
      car_price_by_staff: json['car_price_by_staff'],
      rrcar_id: json['rrcar_id'],

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['car_name'] = this.car_name;
    data['car_features'] = this.car_features;
    data['car_status'] = this.car_status;
    data['car_price'] = this.car_price;
    data['category_name'] = this.category_name;
    data['car_exterior_img'] = this.car_exterior_img;
    data['car_interior_img'] = this.car_interior_img;
    data['car_rear_img'] = this.car_rear_img;
    data['car_front_img'] = this.car_front_img;
    data['car_reg_no'] = this.car_reg_no;
    data['request_id'] = this.request_id;
    data['car_price_by_staff'] = this.car_price_by_staff;
    data['car_year'] = this.car_year;
    data['rrcar_id'] = this.rrcar_id;
    return data;
  }

}

