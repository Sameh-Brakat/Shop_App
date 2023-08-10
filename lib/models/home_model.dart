class HomeModel {
  late bool status;
  HomeData? data;

  HomeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? HomeData.fromJson(json['data']) : null;
  }
}

class HomeData {
  List<BannersModel> banners = [];
  List<ProductsModel> products = [];

  HomeData.fromJson(Map<String, dynamic> json) {
    json['banners'].forEach((e) {
      banners.add(BannersModel.fromJson(e) as BannersModel);
    });
    json['products'].forEach((e) {
      products.add(ProductsModel.fromJson(e) as ProductsModel);
    });
  }
}

class BannersModel {
  late int id;
  late String image;

  BannersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
  }
}

class ProductsModel {
  late int id;
  late dynamic price;
  late dynamic old_price;
  dynamic? discount;
  late String image;
  late String name;
  late String description;
  late bool in_favorites;
  late bool in_cart;
  late List images;

  ProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    old_price = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    in_favorites = json['in_favorites'];
    in_cart = json['in_cart'];
    images = json['images'];
  }
}
