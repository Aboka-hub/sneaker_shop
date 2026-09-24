// Демо-каталог кроссовок. В реальном приложении эти списки приходят с бэкенда.
import 'package:sneaker_shop/constants.dart';

class ProductModel {
  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;

  ProductModel({
    required this.image,
    required this.brandName,
    required this.title,
    required this.price,
    this.priceAfetDiscount,
    this.dicountpercent,
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
  ),
  ProductModel(
    image: sneakerImg7,
    title: "Future Rider Trainers",
    brandName: "Puma",
    price: 89.99,
  ),
  ProductModel(
    image: sneakerImg10,
    title: "Sports Sneakers Off White & Red",
    brandName: "Off White",
    price: 119.99,
    priceAfetDiscount: 95.99,
    dicountpercent: 20,
  ),
  ProductModel(
    image: sneakerImg5,
    title: "Baseball Cleats Pro",
    brandName: "Nike",
    price: 79.99,
    priceAfetDiscount: 65.99,
    dicountpercent: 18,
  ),
  ProductModel(
    image: sneakerImg14,
    title: "Pampi Street Sneakers",
    brandName: "Pampi",
    price: 59.99,
  ),
  ProductModel(
    image: sneakerImg15,
    title: "Red Runner Low",
    brandName: "Fashion Express",
    price: 34.99,
    priceAfetDiscount: 28.99,
    dicountpercent: 17,
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
  ),
  ProductModel(
    image: sneakerImg12,
    title: "Sports Sneakers Off White Red",
    brandName: "Off White",
    price: 109.99,
    priceAfetDiscount: 82.49,
    dicountpercent: 25,
  ),
  ProductModel(
    image: sneakerImg8,
    title: "Future Rider Play On",
    brandName: "Puma",
    price: 99.99,
    priceAfetDiscount: 74.99,
    dicountpercent: 25,
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
  ),
  ProductModel(
    image: sneakerImg11,
    title: "Off White Court Sneakers",
    brandName: "Off White",
    price: 129.99,
  ),
  ProductModel(
    image: sneakerImg3,
    title: "Air Jordan 1 Mid Chicago",
    brandName: "Nike",
    price: 169.99,
    priceAfetDiscount: 144.49,
    dicountpercent: 15,
  ),
  ProductModel(
    image: sneakerImg16,
    title: "Golden Sneakers Woman",
    brandName: "Fashion Diva",
    price: 49.99,
    priceAfetDiscount: 42.99,
    dicountpercent: 14,
  ),
];
