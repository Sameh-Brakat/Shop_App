class GetCatProductsModel {
  bool? status;
  Data? data;


  GetCatProductsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }
}

class Data {
  List<ProData>? data;

  Data.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ProData>[];
      json['data'].forEach((v) {
        data!.add(new ProData.fromJson(v));
      });
    }
  }

}

class ProData {
  late int id;
  dynamic? price;
  dynamic? oldPrice;
  dynamic? discount;
  String? image;
  String? name;
  String? description;
  List<dynamic>? images;


  ProData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'];
  }
}
