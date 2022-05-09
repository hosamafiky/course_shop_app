class ChangeFavoriteModel {
  bool? status;
  String? message;
  ChangeFavoriteDataModel? data;
  ChangeFavoriteModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"];
    data = status! ? ChangeFavoriteDataModel.fromJson(json["data"]) : null;
  }
}

class ChangeFavoriteDataModel {
  int? id;
  FavoriteProduct? product;
  ChangeFavoriteDataModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    product = FavoriteProduct.fromJson(json["product"]);
  }
}

class FavoriteProduct {
  int? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;

  FavoriteProduct.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    price = json["price"];
    oldPrice = json["old_price"];
    discount = json["discount"];
  }
}
