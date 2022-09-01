class Store {
  String? status;
  bool? code;
  List<Result>? result;

  Store({this.status, this.code, this.result});

  Store.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? address;
  String? place;
  String? id;
  String? image;
  String? discount;
  double? lat;
  double? lng;
  String? placeID;

  Result({
    this.name,
    this.address,
    this.place,
    this.id,
    this.discount,
    this.image,
    this.lat,
    this.lng,
    this.placeID,
  });

  Result.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    place = json['place'];
    id = json['id'];
    image = json['image'];
    discount = json['discount'];
  }
}
