import 'package:sneaker_shop/constants.dart';

class ProductModel {
  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;

  final List<String> sizes;
  final List<String> tags;

  ProductModel({
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
    this.sizes = const ["39", "40", "41", "42", "43", "44"],
    this.tags = const [],
  });
}

List<ProductModel> demoPopularProducts = [
  ProductModel(
    image: sneakerImg1,
    title: "Air Jordan 1 Retro High",
    brandName: "Nike",
    price: 189.99,
    priceAfetDiscount: 149.99,
    dicountpercent: 21,
    tags: const ["New arrivals", "Retro", "High tops", "Basketball"],
  ),
  ProductModel(
    image: sneakerImg7,
    title: "Future Rider Trainers",
    brandName: "Puma",
    price: 89.99,
    tags: const ["Lifestyle", "Running"],
  ),
  ProductModel(
    image: sneakerImg10,
    title: "Sports Sneakers Off White & Red",
    brandName: "Off White",
    price: 119.99,
    priceAfetDiscount: 95.99,
    dicountpercent: 20,
    tags: const ["New arrivals", "Lifestyle"],
  ),
  ProductModel(
    image: sneakerImg4,
    title: "Air Jordan 4 Retro",
    brandName: "Nike",
    price: 199.99,
    priceAfetDiscount: 179.99,
    dicountpercent: 10,
    tags: const ["Retro", "High tops", "Basketball"],
  ),
  ProductModel(
    image: sneakerImg13,
    title: "Off White Red Low",
    brandName: "Off White",
    price: 139.99,
    sizes: const ["39", "40", "41"],
    tags: const ["Lifestyle"],
  ),
];

List<ProductModel> demoFlashSaleProducts = [
  ProductModel(
    image: sneakerImg2,
    title: "Air Jordan 1 Red & Black",
    brandName: "Nike",
    price: 189.99,
    priceAfetDiscount: 113.99,
    dicountpercent: 40,
    tags: const ["Retro", "High tops", "Basketball"],
  ),
  ProductModel(
    image: sneakerImg12,
    title: "Sports Sneakers Off White Red",
    brandName: "Off White",
    price: 109.99,
    priceAfetDiscount: 82.49,
    dicountpercent: 25,
    tags: const ["Lifestyle"],
  ),
  ProductModel(
    image: sneakerImg8,
    title: "Future Rider Play On",
    brandName: "Puma",
    price: 99.99,
    priceAfetDiscount: 74.99,
    dicountpercent: 25,
    tags: const ["Running"],
  ),
];

List<ProductModel> demoBestSellersProducts = [
  ProductModel(
    image: sneakerImg9,
    title: "Future Rider Neon Pack",
    brandName: "Puma",
    price: 94.99,
    priceAfetDiscount: 79.99,
    dicountpercent: 16,
    tags: const ["Running", "Lifestyle"],
  ),
  ProductModel(
    image: sneakerImg11,
    title: "Off White Court Sneakers",
    brandName: "Off White",
    price: 129.99,
    tags: const ["Basketball", "Lifestyle"],
  ),
  ProductModel(
    image: sneakerImg3,
    title: "Air Jordan 1 Mid Chicago",
    brandName: "Nike",
    price: 169.99,
    priceAfetDiscount: 144.49,
    dicountpercent: 15,
    tags: const ["Retro", "Basketball"],
  ),
];

List<ProductModel> demoExtraProducts = [
  ProductModel(
    image: "assets/images/products/extra_1.jpg",
    title: "Nike Free RN Flyknit",
    brandName: "Nike",
    price: 129.99,
    priceAfetDiscount: 109.99,
    dicountpercent: 15,
    tags: const ["Running", "New arrivals"],
  ),
  ProductModel(
    image: "assets/images/products/extra_2.jpg",
    title: "Nike Court Low",
    brandName: "Nike",
    price: 89.99,
    tags: const ["Lifestyle", "Retro"],
  ),
  ProductModel(
    image: "assets/images/products/extra_3.jpg",
    title: "Nike Air Force Shadow",
    brandName: "Nike",
    price: 119.99,
    priceAfetDiscount: 99.99,
    dicountpercent: 17,
    sizes: const ["28", "29", "30", "31", "32", "33"],
    tags: const ["Girls", "Lifestyle", "New arrivals"],
  ),
  ProductModel(
    image: "assets/images/products/extra_4.jpg",
    title: "Nike SuperRep",
    brandName: "Nike",
    price: 139.99,
    tags: const ["Running"],
  ),
  ProductModel(
    image: "assets/images/products/extra_5.jpg",
    title: "Nike Air Force 1",
    brandName: "Nike",
    price: 109.99,
    sizes: const ["34", "35", "36", "37", "38"],
    tags: const ["Boys", "High tops", "Lifestyle"],
  ),
  ProductModel(
    image: "assets/images/products/extra_6.jpg",
    title: "New Balance X-90",
    brandName: "New Balance",
    price: 99.99,
    priceAfetDiscount: 84.99,
    dicountpercent: 15,
    sizes: const ["28", "29", "30", "31", "32", "33"],
    tags: const ["Girls", "Lifestyle"],
  ),
  ProductModel(
    image: "assets/images/products/extra_7.jpg",
    title: "Puma Smash Kids",
    brandName: "Puma",
    price: 49.99,
    sizes: const ["22", "23", "24", "25", "26", "27"],
    tags: const ["First steps"],
  ),
  ProductModel(
    image: "assets/images/products/extra_8.jpg",
    title: "Color Block Kids",
    brandName: "Puma",
    price: 59.99,
    sizes: const ["28", "29", "30", "31", "32", "33"],
    tags: const ["Boys", "First steps"],
  ),
  ProductModel(
    image: "assets/images/products/extra_12.jpg",
    title: "Nike Phantom Indoor",
    brandName: "Nike",
    price: 149.99,
    priceAfetDiscount: 129.99,
    dicountpercent: 13,
    tags: const ["Football boots", "New arrivals"],
  ),
  ProductModel(
    image: "assets/images/products/extra_13.jpg",
    title: "New Balance 247",
    brandName: "New Balance",
    price: 94.99,
    sizes: const ["34", "35", "36", "37", "38"],
    tags: const ["Running", "Boys"],
  ),
];

List<ProductModel> catalogProducts() {
  final byTitle = <String, ProductModel>{};
  for (final product in [
    ...demoPopularProducts,
    ...demoFlashSaleProducts,
    ...demoBestSellersProducts,
    ...demoExtraProducts,
  ]) {
    byTitle[product.title] = product;
  }
  return byTitle.values.toList();
}

ProductModel? productByTitle(String title) {
  for (final product in catalogProducts()) {
    if (product.title == title) return product;
  }
  return null;
}
