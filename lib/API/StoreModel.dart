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
  List? businessTime;
  String? timeEstimate;
  String? describe;
  Locationss? location;
  List? product;
  String? last_update;
  double? status;

  Result({
    this.name,
    this.address,
    this.place,
    this.id,
    this.discount,
    this.image,
    this.businessTime,
    this.timeEstimate,
    this.describe,
    this.location,
    this.product,
    this.last_update,
    this.status,
  });

  Result.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    place = json['place'];
    id = json['id'];
    image = json['image'];
    discount = json['discount'];
    businessTime = json['businessTime'];
    product = json['product'];
    timeEstimate = json['timeEstimate'];
    describe = json['describe'];
    last_update = json['last_update'];
    status = json['status'] ?? 1000;
    location = json['location'] != null
        ? new Locationss.fromJson(json['location'])
        : null;
  }
}

class Locationss {
  String? lat;
  String? lng;
  String? googlePlaceId;

  Locationss({this.lat, this.lng, this.googlePlaceId});

  Locationss.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    googlePlaceId = json['googlePlaceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['googlePlaceId'] = this.googlePlaceId;
    return data;
  }
}
