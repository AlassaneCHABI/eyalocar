
class Historique_paiement {
  final int id,payment_amount,payment_booking;
  final String payment_method,payment_reference,payment_status,payment_date,lastname,firstname,created_at;

  Historique_paiement({
    required this.id,
    required this.payment_amount,
    required this.payment_booking,
    required this.payment_method,
    required this.payment_reference,
    required this.payment_status,
    required this.payment_date,
    required this.lastname,
    required this.firstname,
    required this.created_at,
  });

  factory Historique_paiement.fromJson(Map<String, dynamic> json) {
    return Historique_paiement(
      id: json['id'],
      payment_amount: json['payment_amount'],
      payment_booking: json['payment_booking'],
      payment_method: json['payment_method'],
      payment_reference: json['payment_reference'],
      payment_status: json['payment_status'],
      payment_date: json['payment_date'],
      lastname: json['lastname'],
      firstname: json['firstname'],
      created_at: json['created_at'],

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['payment_amount'] = this.payment_amount;
    data['payment_booking'] = this.payment_booking;
    data['payment_method'] = this.payment_method;
    data['payment_reference'] = this.payment_reference;
    data['payment_status'] = this.payment_status;
    data['payment_date'] = this.payment_date;
    data['lastname'] = this.lastname;
    data['firstname'] = this.firstname;
    data['created_at'] = this.created_at;
    return data;
  }
}
