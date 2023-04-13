class CategoriesModel {
  late bool status;
  CategoriesData? data;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? CategoriesData.fromJson(json['data']) : null;
  }
}

class CategoriesData {
  late int current_page;
  List<DataModel> data = [];

  CategoriesData.fromJson(Map<String, dynamic> json) {
    current_page = json['current_page'];

    json['data'].forEach((e) {
      data.add(DataModel.fromJson(e) as DataModel);
    });
  }
}

class DataModel {
  late int id;
  late String name;
  late String image;

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
