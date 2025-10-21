
class Category {
  final int id,category_reduction;
  final String category_name,category_description,category_tarif_apd,category_photo,category_status;

  Category({
    required this.id,
    required this.category_name,
    required this.category_description,
    required this.category_reduction,
    required this.category_tarif_apd,
    required this.category_photo,
    required this.category_status,


  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      category_name: json['category_name'],
      category_description: json['category_description'],
      category_reduction: json['category_reduction'],
      category_tarif_apd: json['category_tarif_apd'],
      category_photo: json['category_photo'],
      category_status: json['category_status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.category_name;
    data['category_description'] = this.category_description;
    data['category_reduction'] = this.category_reduction;
    data['category_tarif_apd'] = this.category_tarif_apd;
    data['category_photo'] = this.category_photo;
    data['category_status'] = this.category_status;
    return data;
  }

}

