class FavoritesModel 
{
  late bool status;
  late Null message;
  late Data? data;
  
  FavoritesModel.fromJson(Map<String, dynamic> json) 
  {
    status = json['status'];
    message = json['message'];
    data = (json['data'] != null ? new Data.fromJson(json['data']) : null)!;
  }
}
class Data {
  late int currentPage;
  late List<FavoritesData> data;
  late String firstPageUrl;
  late int? from;
  late int lastPage;
  late String lastPageUrl;
  late String? nextPageUrl;
  late String path;
  late int perPage;
  late String? prevPageUrl;
  late int? to;
  late int total;

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'] ?? 1;
    data = [];
    if (json['data'] != null) {
      json['data'].forEach((v) {
        data.add(FavoritesData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'] ?? "";
    from = json['from'] ?? 0; // توفير قيمة افتراضية
    lastPage = json['last_page'] ?? 1;
    lastPageUrl = json['last_page_url'] ?? "";
    nextPageUrl = json['next_page_url'];
    path = json['path'] ?? "";
    perPage = json['per_page'] ?? 0;
    prevPageUrl = json['prev_page_url'];
    to = json['to'] ?? 0;
    total = json['total'] ?? 0; // توفير قيمة افتراضية
  }
}

class FavoritesData {
  late int id;
  late Product product;

  FavoritesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product =
    (json['product'] != null ? new Product.fromJson(json['product']) : null)!;
  }
}

class Product {
  late int id;
  late dynamic price;
  late dynamic oldPrice;
  late int discount;
  late String image;
  late String name;
  late String description;

  Product(
      {
        required this.id,
        required this.price,
        required this.oldPrice,
        required this.discount,
        required this.image,
        required this.name,
        required this.description});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['old_price'] = this.oldPrice;
    data['discount'] = this.discount;
    data['image'] = this.image;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}