class HomeModel{
  late bool status;
  late HomeDataModel data;

  HomeModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    data = HomeDataModel.fromJson(json['data']);
  }
}

class HomeDataModel {
  List<BannerModel> banners = [];
  List<ProductModel> products = [];

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      json['banners'].forEach((element) {
        banners.add(BannerModel.fromJson(element));
      });
    }

    if (json['products'] != null) {
      json['products'].forEach((element) {
        products.add(ProductModel.fromJson(element));
      });
    }
  }
}


class ProductModel {
  late int id;
  late String image;
  late dynamic price;
  late dynamic oldPrice;
  late dynamic discount;
  late String name;
  late bool inFavorites;
  late bool inCart;

  ProductModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    image = json['image'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    name = json['name'];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  } 
}

class BannerModel {
  late int id;
  late String image;

  BannerModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    image = json['image'];
  }
  
}
