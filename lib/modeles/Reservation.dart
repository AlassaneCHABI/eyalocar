
class Reservation {
  final int id,booking_car,booking_user,booking_price,booking_days,booking_amount;
  final String car_name,car_reg_no,category_name,car_features,car_exterior_img,car_status,booking_status
  ,booking_date,booking_society,booking_ifu,booking_phone_number,booking_le,booking_ld,booking_de,booking_dd
  ,booking_he,booking_circuit,total_payments,remaining_amount;

  Reservation({
    required this.id,
    required this.car_name,
    required this.car_reg_no,
    required this.category_name,
    required this.car_features,
    required this.car_exterior_img,
    required this.car_status,
    required this.booking_car,
    required this.booking_status,
    required this.booking_user,
    required this.booking_price,
    required this.booking_days,
    required this.booking_date,
    required this.booking_society,
    required this.booking_ifu,
    required this.booking_phone_number,
    required this.booking_le,
    required this.booking_ld,
    required this.booking_de,
    required this.booking_dd,
    required this.booking_he,
    required this.booking_amount,
    required this.booking_circuit,
    required this.total_payments,
    required this.remaining_amount,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      car_name: json['car_name'],
      car_reg_no: json['car_reg_no'],
      category_name: json['category_name'],
      car_features: json['car_features'],
      car_exterior_img: json['car_exterior_img'],
      car_status: json['car_status'],
      booking_car: json['booking_car'],
      booking_status: json['booking_status'],
      booking_user: json['booking_user'],
      booking_price: json['booking_price'],
      booking_days: json['booking_days'],
      booking_date: json['booking_date'],
      booking_society: json['booking_society'],
      booking_ifu: json['booking_ifu'],
      booking_phone_number: json['booking_phone_number'],
      booking_le: json['booking_le'],
      booking_ld: json['booking_ld'],
      booking_de: json['booking_de'],
      booking_dd: json['booking_dd'],
      booking_he: json['booking_he']?? "Pas defini",
      booking_amount: json['booking_amount'],
      booking_circuit: json['booking_circuit'],
      total_payments: json['total_payments'],
      remaining_amount: json['remaining_amount'],

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['car_name'] = this.car_name;
    data['car_reg_no'] = this.car_reg_no;
    data['category_name'] = this.category_name;
    data['car_features'] = this.car_features;
    data['car_exterior_img'] = this.car_exterior_img;
    data['car_status'] = this.car_status;
    data['booking_car'] = this.booking_car;
    data['booking_status'] = this.booking_status;
    data['booking_user'] = this.booking_user;
    data['booking_price'] = this.booking_price;
    data['booking_days'] = this.booking_days;
    data['booking_date'] = this.booking_date;
    data['booking_society'] = this.booking_society;
    data['booking_ifu'] = this.booking_ifu;
    data['booking_phone_number'] = this.booking_phone_number;
    data['booking_le'] = this.booking_le;
    data['booking_ld'] = this.booking_ld;
    data['booking_de'] = this.booking_de;
    data['booking_dd'] = this.booking_dd  ;
    data['booking_he'] = this.booking_he  ;
    data['booking_amount'] = this.booking_amount  ;
    data['booking_circuit'] = this.booking_circuit  ;
    data['total_payments'] = this.total_payments  ;
    data['remaining_amount'] = this.remaining_amount  ;
    return data;
  }

}

