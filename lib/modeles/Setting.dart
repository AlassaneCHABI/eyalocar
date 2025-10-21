
class Setting {
  late final int id,minimum_paiement,allow_bonus;


  Setting({
    required this.id,
    required this.minimum_paiement,
    required this.allow_bonus,
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      id: json['id'],
      minimum_paiement: json['minimum_paiement'],
      allow_bonus: json['allow_bonus'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['minimum_paiement'] = this.minimum_paiement;
    data['allow_bonus'] = this.allow_bonus;
    return data;
  }

}

