class Autogenerated2 {
  String? status;
  bool? code;
  List<Result2>? result;

  Autogenerated2({this.status, this.code, this.result});

  Autogenerated2.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    if (json['result'] != null) {
      result = <Result2>[];
      json['result'].forEach((v) {
        result!.add(new Result2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result2 {
  String? sId;
  String? order;
  String? dATE;
  StoreInfo? storeInfo;
  int? total;
  String? discount;
  String? image;
  bool? complete;
  bool? accept;
  bool? tableWare;
  int? sequence;
  String? comments;
  String?reservation;

  Result2({
    this.sId,
    this.order,
    this.dATE,
    this.storeInfo,
    this.total,
    this.discount,
    this.complete,
    this.accept,
    this.image,
    this.tableWare,
    this.sequence,
    this.comments,
    this.reservation,
  });

  Result2.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    order = json['order'];
    dATE = json['DATE'];
    storeInfo = json['store_info'] != null
        ? new StoreInfo.fromJson(json['store_info'])
        : null;
    total = json['total'];
    discount = json['discount'];
    complete = json['complete'];
    accept = json['accept'];
    image = json['image'];
    tableWare = json['tableware'];
    sequence = json['sequence'];
    comments = json['comments'];
    reservation = json['reservation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['order'] = this.order;
    data['DATE'] = this.dATE;
    if (this.storeInfo != null) {
      data['store_info'] = this.storeInfo!.toJson();
    }
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['complete'] = this.complete;
    data['accept'] = this.accept;
    data['image'] = this.image;
    data['sequence'] = this.sequence;
    data['comments'] = this.comments;
    data['reservation'] = this.reservation;
    return data;
  }
}

class StoreInfo {
  String? name;
  String? address;

  StoreInfo({this.name, this.address});

  StoreInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }
}
