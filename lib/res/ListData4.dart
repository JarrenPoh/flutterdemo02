class RappiCategory {
  const RappiCategory({
    required this.name,
    required this.products,
  });
  final String name;
  final List<RappiProduct> products;
}

class RappiProduct {
  const RappiProduct({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  final String name, description, image;
  final int price;
}

const rappiCategories = [
  RappiCategory(name: '主食', products: [
    RappiProduct(
      name: '葉子怪怪湯',
      description:
          '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      image: "images/pexels-photo-691077.jpeg",
      price: 100,
    ),
    RappiProduct(
      name: '葉子怪怪湯',
      description:
          '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      image: "images/111111.jpg",
      price: 100,
    ),
    RappiProduct(
      name: '葉子怪怪湯',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      image: "images/pexels-photo-691077.jpeg",
      price: 100,
    ),
  ]),
  RappiCategory(name: '套餐', products: [
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/pexels-photo-691077.jpeg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
  ]),
  RappiCategory(name: '單點', products: [
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/pexels-photo-691077.jpeg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/pexels-photo-691077.jpeg",
    ),
  ]),
  RappiCategory(name: '飲品', products: [
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/pexels-photo-691077.jpeg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/pexels-photo-691077.jpeg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/pexels-photo-691077.jpeg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
  ]),
  RappiCategory(name: '小菜', products: [
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/pexels-photo-691077.jpeg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/pexels-photo-691077.jpeg",
    ),
  ]),
  RappiCategory(name: '類', products: [
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/pexels-photo-691077.jpeg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/pexels-photo-691077.jpeg",
    ),
  ]),
  RappiCategory(name: '一般', products: [
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/pexels-photo-691077.jpeg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/pexels-photo-691077.jpeg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/pexels-photo-691077.jpeg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/111111.jpg",
    ),
    RappiProduct(
      name: '葉子怪怪飲料',
      description: '很好吃的食物用怪怪的東西和葉子組成的啦啦啦啦啦啦啦啦啦啦啦啦x8x87xx87x87xzx7啦啦啦',
      price: 100,
      image: "images/pexels-photo-691077.jpeg",
    ),
  ]),
];
