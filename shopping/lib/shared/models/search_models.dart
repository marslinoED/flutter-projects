class SearchModel {
  bool status;
  String? message; // <-- تأكد أنه nullable
  SearchData data;

  SearchModel.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'], // قد يكون null
        data = SearchData.fromJson(json['data']);
}

class SearchData {
  int currentPage;
  List<ProductData> data;

  SearchData.fromJson(Map<String, dynamic> json)
      : currentPage = json['current_page'] ?? 1, // افتراضي لو null
        data = (json['data'] as List)
            .map((e) => ProductData.fromJson(e))
            .toList();
}

class ProductData {
  int id;
  double? price; // <-- تأكد أنه nullable
  String image;
  String name;
  String? description; // <-- تأكد أنه nullable

  ProductData.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0, // افتراضي لو null
        price = json['price'] != null ? (json['price'] as num).toDouble() : null, // قد يكون null
        image = json['image'] ?? 'https://example.com/default.png', // افتراضي
        name = json['name'] ?? 'No Name',
        description = json['description']; // قد يكون null
}
