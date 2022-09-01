class Autogenerated {
  String? status;
  bool? code;
  Result? result;

  Autogenerated({this.status, this.code, this.result});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Result {
  String? order;
  String? dATE;
  StoreInfo? storeInfo;
  int? total;
  String? discount;
  bool? complete;
  bool? accept;
  bool? tableware;
  Result({
    this.order,
    this.dATE,
    this.storeInfo,
    this.total,
    this.discount,
    this.complete,
    this.accept,
    this.tableware,
  });

  Result.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    dATE = json['DATE'];
    storeInfo = json['store_info'] != null
        ? new StoreInfo.fromJson(json['store_info'])
        : null;
    total = json['total'];
    discount = json['discount'];
    complete = json['complete'];
    accept = json['accept'];
    tableware = json['tableware'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order'] = this.order;
    data['DATE'] = this.dATE;
    if (this.storeInfo != null) {
      data['store_info'] = this.storeInfo!.toJson();
    }
    data['total'] = this.total;
    data['discount'] = this.discount;
    data['complete'] = this.complete;
    data['accept'] = this.accept;
    data['tableware'] = this.tableware;
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
