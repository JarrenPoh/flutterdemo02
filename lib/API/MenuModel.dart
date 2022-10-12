class Menu {
  String? status;
  bool? code;
  List<Result>? result;

  Menu({this.status, this.code, this.result});

  Menu.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['result'] != null) {
      result = <Result>[];
      for (var v in (json['result'] as List)) {
        result!.add(Result.fromJson(v));
      }
    }
  }
}

class Result {
  late String name;
  late String price;
  String? describe;
  late String type;
  String? discount;
  String? min;
  String? max;
  String? options;
  String? image;
  String? id;

  Result({
    required this.name,
    required this.price,
    required this.describe,
    required this.type,
    required this.image,
    required this.discount,
    required this.options,
    required this.id,
    required this.max,
    required this.min,
  });

  Result.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
    describe = json['describe'];
    type = json['type'];
    image = json['image'];
    discount = json['discount'];
    options = json['options'];
    id = json['id'];
    max = json['max'];
    min = json['min'];
  }
}

// class RappiCategory {
//    RappiCategory({
//     required this.name,
//     required this.products,
//   });
//   late String name;
//   late List<RappiProduct> products;

//   RappiCategory.fromJson(Map<String, dynamic> json) {
//     name = json['type'];
//     // products = json['products'];
//     if (json['products'] != null) {
//       products = <RappiProduct>[];
//       (json['products'] as List).forEach((v) {
//         products.add(RappiProduct.fromJson(v));
//       });
//     }
//   }
// }

// class RappiProduct {
//    RappiProduct({
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.image,
//   });

//   late String name, description, image;
//   late int price;

//    RappiProduct.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     description = json['description'];
//     image = json['image'];
//     price = json['price'];

//   }
// }
