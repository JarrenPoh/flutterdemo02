class CartModel {
  final String id;
  final String name;
  final String shopname;

  final String? description;
  final String? text; //可選
  final int price;
  final int quantity;
  final String textprice;
  final List<List>? radiolist;
  final List<String?>? radioTitleList;
  List<bool?>? radioMultiple;
  final List<List>? addCheckBool;
  final List? radioprices;
  final int? radiopricesnum;
  final List? options;
  final List? requiredCheckBool;
  final List<String?>? RadioTitleList;
  List<bool?>? RadioMultiple;
  final List<List>? Radiolist;
  final List? Radioprices;
  final int? Radiopricesnum;
  final String? imageUrl;
  CartModel({
    this.text,
    this.description,
    
    required this.id,
    required this.name,
    required this.shopname,
    required this.price,
    required this.quantity,
    required this.textprice,
    this.radiolist,
    this.radioTitleList,
    this.radioMultiple,
    this.addCheckBool,
    this.radioprices,
    this.radiopricesnum,
    this.options,
    this.requiredCheckBool,
    this.RadioTitleList,
    this.RadioMultiple,
    this.Radiolist,
    this.Radioprices,
    this.Radiopricesnum,
    this.imageUrl,
  });
}

class Options {
  String? title;
  List<dynamic>? option;

  Options(
    this.title,
    this.option,
  );
  Map toJson() => {
        'title': title,
        'option': option,
      };
}

class Order {
  String? id;
  int? count;
  String? note;
  String? options;

  Order(
    this.id,
    this.count,
    this.note,
    this.options,
  );
  Map toJson() => {
        'id': id,
        'count': count,
        'note': note,
        'options': options,
      };
}

class Orders {
  bool tableware;
  String? reservationTime;
  List? order;
  Orders(
    this.tableware,
    this.reservationTime,
    this.order,
  );
  Map toJson() => {
        'tableware': tableware,
        'reservation':reservationTime,
        'orders': order,
      };
}

class OptionsStr {
  String? title;
  String? option;

  OptionsStr(
    this.title,
    this.option,
  );
  Map toJson() => {
        'title': title,
        'option': option,
      };
}
