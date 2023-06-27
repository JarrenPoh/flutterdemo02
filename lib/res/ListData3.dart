import 'listData.dart';

////form5的radio
List<Map> checkboxData = [
  {
    "name": "加飯",
    "price": 10,
  },
  {
    "name": "加菜",
    "price": 10,
  },
  {
    "name": "加湯",
    "price": 100,
  },
  {
    "name": "加肉",
    "price": 10,
  },
  {
    "name": "加蛋",
    "price": 10,
  },
  {
    "name": "加愛心",
    "price": 10,
  },
];
List<List<Map>> radioData = [
  [
    {
      "name": "飯",
      "price": 0,
    },
    {
      "name": "麵",
      "price": 0,
    },
    {
      "name": "冬粉",
      "price": 5,
    }
  ],
  [
    {
      "name": "正常",
      "price": 0,
    },
    {
      "name": "小辣",
      "price": 0,
    },
    {
      "name": "中辣",
      "price": 0,
    },
    {
      "name": "大辣",
      "price": 0,
    }
  ],
  [
    {
      "name": "大",
      "price": 10,
    },
    {
      "name": "中",
      "price": 5,
    },
    {
      "name": "小",
      "price": 0,
    },
  ],
  [
    {
      "name": "去冰",
      "price": 0,
    },
    {
      "name": "微冰",
      "price": 0,
    },
    {
      "name": "多冰",
      "price": 0,
    },
  ],
];
////
////form5的checkbox
////

////沒用
class Comida {
  String title;
  String descibe;
  String imageUrl;
  String price;

  Comida({
    required this.title,
    required this.descibe,
    required this.imageUrl,
    required this.price,
  });
}

////沒用
class JarrenClinic {
  // static List<Page1> inforM = [
  //   Page1(
  //     name: "小杰診所主題餐廳",
  //     image: "images/pexels-photo-2182979.jpeg",
  //     location: "桃園市環中東路150號",
  //   ),
  // ];
  static List<Comida> rice = [
    Comida(
      title: demoMediumCardData[0]['title'],
      descibe: demoMediumCardData[0]['descibe'],
      imageUrl: demoMediumCardData[0]['imageUrl'],
      price: demoMediumCardData[0]['price'],
    ),
    Comida(
      title: demoMediumCardData[0]['title'],
      descibe: demoMediumCardData[0]['descibe'],
      imageUrl: demoMediumCardData[0]['imageUrl'],
      price: demoMediumCardData[0]['price'],
    ),
    Comida(
      title: demoMediumCardData[0]['title'],
      descibe: demoMediumCardData[0]['descibe'],
      imageUrl: demoMediumCardData[0]['imageUrl'],
      price: demoMediumCardData[0]['price'],
    ),
  ];
  static List<Comida> soup = [
    Comida(
      title: '葉子怪怪湯',
      descibe: '很好吃的食物用怪怪的東西和葉子組成的',
      imageUrl: 'https://www.itying.com/images/flutter/1.png',
      price: '\$ 100',
    ),
    Comida(
      title: '葉子怪怪湯',
      descibe: '很好吃的食物用怪怪的東西和葉子組成的',
      imageUrl: 'https://www.itying.com/images/flutter/1.png',
      price: '\$ 100',
    ),
    Comida(
      title: '葉子怪怪湯',
      descibe: '很好吃的食物用怪怪的東西和葉子組成的',
      imageUrl: 'https://www.itying.com/images/flutter/1.png',
      price: '\$ 100',
    ),
  ];
  static List<Comida> beverage = [
    Comida(
      title: '葉子怪怪飲料',
      descibe: '很好吃的食物用怪怪的東西和葉子組成的',
      imageUrl: 'https://www.itying.com/images/flutter/1.png',
      price: '\$ 100',
    ),
    Comida(
      title: '葉子怪怪飲料',
      descibe: '很好吃的食物用怪怪的東西和葉子組成的',
      imageUrl: 'https://www.itying.com/images/flutter/1.png',
      price: '\$ 100',
    ),
    Comida(
      title: '葉子怪怪飲料',
      descibe: '很好吃的食物用怪怪的東西和葉子組成的',
      imageUrl: 'https://www.itying.com/images/flutter/1.png',
      price: '\$ 100',
    ),
    Comida(
      title: '葉子怪怪飲料',
      descibe: '很好吃的食物用怪怪的東西和葉子組成的',
      imageUrl: 'https://www.itying.com/images/flutter/1.png',
      price: '\$ 100',
    ),
    Comida(
      title: '葉子怪怪飲料',
      descibe: '很好吃的食物用怪怪的東西和葉子組成的',
      imageUrl: 'https://www.itying.com/images/flutter/1.png',
      price: '\$ 100',
    ),
  ];
}
