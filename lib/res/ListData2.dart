import '../provider/Shared_Preference.dart';

class historyCategory {
  const historyCategory(
      {required this.shopname,
      required this.shopimage,
      required this.discount,
      required this.date,
      required this.products,
      required this.numbering,
      required this.address});
  final String shopname;
  final String shopimage;
  final int discount;
  final String date;
  final List<historyProduct> products;
  final String numbering, address;
}

class historyProduct {
  const historyProduct(
      {required this.orders,
      required this.number,
      required this.price,
      required this.describes});
  final String orders;
  final int number;
  final int price;
  final String describes;
}

const historyOrders = [
  historyCategory(
      shopname: '草苗義式餐廳草苗義式餐廳 - 松山店',
      shopimage: 'images/pexels-photo-3734031.jpeg',
      discount: 40,
      date: '04 01月,00:55',
      numbering: '#a0de-4yeb',
      address: '291之2號 新中北路 touyuan city, 320',
      products: [
        historyProduct(
            orders: 'OREO小御園鮮奶',
            number: 1,
            price: 126,
            describes: '這是描述這是描述這是描述這是描述這是描述這是描述'),
        historyProduct(
            orders: '好夥伴鮮奶',
            number: 1,
            price: 224,
            describes: '這是描述這是描述這是描述這是描述這是描述這是描述'),
        historyProduct(
            orders: '椰果鮮奶',
            number: 1,
            price: 150,
            describes: '這是描述這是描述這是描述這是描述這是描述這是描述'),
      ]),
  historyCategory(
      shopname: '馬來西亞風味餐館 - 中壢南西店',
      shopimage: 'images/pexels-photo-628776.jpeg',
      discount: 20,
      date: '05 02月,00:55',
      numbering: '#d4t7-4yeb',
      address: '114之5號 wwdfe北路 touyuan city, 320',
      products: [
        historyProduct(
            orders: 'OREO小御園鮮奶',
            number: 1,
            price: 126,
            describes: '這是描述這是描述這是描述這是描述這是描述這是描述'),
        historyProduct(
            orders: '好夥伴鮮奶',
            number: 1,
            price: 224,
            describes: '這是描述這是描述這是描述這是描述這是描述這是描述'),
        historyProduct(
            orders: '椰果鮮奶',
            number: 1,
            price: 150,
            describes: '這是描述這是描述這是描述這是描述這是描述這是描述'),
      ]),
  historyCategory(
      shopname: '小杰診所主題餐廳 - 松山店',
      shopimage: 'images/pexels-photo-1279330.jpeg',
      discount: 30,
      date: '09 15月,00:55',
      numbering: '#atpx-4yeb',
      address: '270之3號 agfd北路 touyuan city, 320',
      products: [
        historyProduct(
            orders: 'OREO小御園鮮奶',
            number: 1,
            price: 126,
            describes: '這是描述這是描述這是描述這是描述這是描述這是描述'),
        historyProduct(
            orders: '好夥伴鮮奶',
            number: 1,
            price: 224,
            describes: '這是描述這是描述這是描述這是描述這是描述這是描述'),
        historyProduct(
            orders: '椰果鮮奶',
            number: 1,
            price: 150,
            describes: '這是描述這是描述這是描述這是描述這是描述這是描述'),
      ]),
];

final List<String> ShopNames = [
  'Candy Shop',
  'Childhood in the picture',
  'Alibaba Shop',
  'Candy Shop',
  'Mohamed Chahin',
  'Alibaba',
  'Google',
  'he only person that ',
  'jarren',
  'joelyn',
  'hahaha',
];
final List<String> ShopNamesSuggestion = [
  'Candy Shop',
  'Childhood in the picture',
  'Alibaba Shop',
  'Candy Shop',
  'Mohamed Chahin',
  'Alibaba',
  'Google',
  'he only person that ',
  'jarren',
  'joelyn',
  'hahaha',
];
