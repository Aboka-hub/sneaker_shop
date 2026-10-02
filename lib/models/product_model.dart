import 'package:sneaker_shop/constants.dart';

class ProductModel {
  final String id;
  final String image, brandName, title;
  final double price;
  final double? priceAfetDiscount;
  final int? dicountpercent;

  final List<String> sizes;
  final List<String> tags;

  ProductModel({
    required this.id,
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
    id: "air-jordan-1-retro-high",
    image: sneakerImg1,
    title: "Air Jordan 1 Retro High",
    brandName: "Nike",
    price: 189.99,
    priceAfetDiscount: 149.99,
    dicountpercent: 21,
    tags: const ["New arrivals", "Retro", "High tops", "Basketball"],
  ),
  ProductModel(
    id: "future-rider-trainers",
    image: sneakerImg7,
    title: "Future Rider Trainers",
    brandName: "Puma",
    price: 89.99,
    tags: const ["Lifestyle", "Running"],
  ),
  ProductModel(
    id: "sports-sneakers-off-white-red",
    image: sneakerImg10,
    title: "Sports Sneakers Off White & Red",
    brandName: "Off White",
    price: 119.99,
    priceAfetDiscount: 95.99,
    dicountpercent: 20,
    tags: const ["New arrivals", "Lifestyle"],
  ),
  ProductModel(
    id: "air-jordan-4-retro",
    image: sneakerImg4,
    title: "Air Jordan 4 Retro",
    brandName: "Nike",
    price: 199.99,
    priceAfetDiscount: 179.99,
    dicountpercent: 10,
    tags: const ["Retro", "High tops", "Basketball"],
  ),
  ProductModel(
    id: "off-white-red-low",
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
    id: "air-jordan-1-red-black",
    image: sneakerImg2,
    title: "Air Jordan 1 Red & Black",
    brandName: "Nike",
    price: 189.99,
    priceAfetDiscount: 113.99,
    dicountpercent: 40,
    tags: const ["Retro", "High tops", "Basketball"],
  ),
  ProductModel(
    id: "sports-sneakers-off-white-red-2",
    image: sneakerImg12,
    title: "Sports Sneakers Off White Red",
    brandName: "Off White",
    price: 109.99,
    priceAfetDiscount: 82.49,
    dicountpercent: 25,
    tags: const ["Lifestyle"],
  ),
  ProductModel(
    id: "future-rider-play-on",
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
    id: "future-rider-neon-pack",
    image: sneakerImg9,
    title: "Future Rider Neon Pack",
    brandName: "Puma",
    price: 94.99,
    priceAfetDiscount: 79.99,
    dicountpercent: 16,
    tags: const ["Running", "Lifestyle"],
  ),
  ProductModel(
    id: "off-white-court-sneakers",
    image: sneakerImg11,
    title: "Off White Court Sneakers",
    brandName: "Off White",
    price: 129.99,
    tags: const ["Basketball", "Lifestyle"],
  ),
  ProductModel(
    id: "air-jordan-1-mid-chicago",
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
    id: "nike-free-rn-flyknit",
    image: "assets/images/products/extra_1.jpg",
    title: "Nike Free RN Flyknit",
    brandName: "Nike",
    price: 129.99,
    priceAfetDiscount: 109.99,
    dicountpercent: 15,
    tags: const ["Running", "New arrivals"],
  ),
  ProductModel(
    id: "nike-court-low",
    image: "assets/images/products/extra_2.jpg",
    title: "Nike Court Low",
    brandName: "Nike",
    price: 89.99,
    tags: const ["Lifestyle", "Retro"],
  ),
  ProductModel(
    id: "nike-air-force-shadow",
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
    id: "nike-superrep",
    image: "assets/images/products/extra_4.jpg",
    title: "Nike SuperRep",
    brandName: "Nike",
    price: 139.99,
    tags: const ["Running"],
  ),
  ProductModel(
    id: "nike-air-force-1",
    image: "assets/images/products/extra_5.jpg",
    title: "Nike Air Force 1",
    brandName: "Nike",
    price: 109.99,
    sizes: const ["34", "35", "36", "37", "38"],
    tags: const ["Boys", "High tops", "Lifestyle"],
  ),
  ProductModel(
    id: "new-balance-x-90",
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
    id: "puma-smash-kids",
    image: "assets/images/products/extra_7.jpg",
    title: "Puma Smash Kids",
    brandName: "Puma",
    price: 49.99,
    sizes: const ["22", "23", "24", "25", "26", "27"],
    tags: const ["First steps"],
  ),
  ProductModel(
    id: "color-block-kids",
    image: "assets/images/products/extra_8.jpg",
    title: "Color Block Kids",
    brandName: "Puma",
    price: 59.99,
    sizes: const ["28", "29", "30", "31", "32", "33"],
    tags: const ["Boys", "First steps"],
  ),
  ProductModel(
    id: "nike-phantom-indoor",
    image: "assets/images/products/extra_12.jpg",
    title: "Nike Phantom Indoor",
    brandName: "Nike",
    price: 149.99,
    priceAfetDiscount: 129.99,
    dicountpercent: 13,
    tags: const ["Football boots", "New arrivals"],
  ),
  ProductModel(
    id: "new-balance-247",
    image: "assets/images/products/extra_13.jpg",
    title: "New Balance 247",
    brandName: "New Balance",
    price: 94.99,
    sizes: const ["34", "35", "36", "37", "38"],
    tags: const ["Running", "Boys"],
  ),
];

List<ProductModel> catalogProducts() {
  final byId = <String, ProductModel>{};
  for (final product in [
    ...demoPopularProducts,
    ...demoFlashSaleProducts,
    ...demoBestSellersProducts,
    ...demoExtraProducts,
  ]) {
    byId[product.id] = product;
  }
  return byId.values.toList();
}

const brandSections = ["Nike", "Puma", "New Balance", "Off White"];

double productPrice(ProductModel product) =>
    product.priceAfetDiscount ?? product.price;

bool matchesHomeChip(ProductModel product, String chip) {
  if (chip == "All Sneakers") return true;
  if (chip == "On Sale" || chip == "On sale") {
    return product.priceAfetDiscount != null;
  }
  final kids = product.tags.any(
    (tag) => tag == "Boys" || tag == "Girls" || tag == "First steps",
  );
  if (chip == "Kids") return kids;
  if (chip == "Men's") {
    return !kids &&
        !product.tags.contains("Girls") &&
        !product.tags.contains("Lifestyle");
  }
  if (chip == "Women’s") {
    return product.tags.contains("Girls") ||
        (!kids && product.tags.contains("Lifestyle"));
  }
  return matchesCatalogSection(product, chip);
}

bool matchesCatalogSection(ProductModel product, String? section) {
  if (section == null ||
      section == "All sneakers" ||
      section == "All Sneakers") {
    return true;
  }
  switch (section) {
    case "On Sale":
    case "On sale":
    case "Discounted pairs":
      return product.priceAfetDiscount != null;
    case "Under \$100":
      return productPrice(product) < 100;
    default:
      if (brandSections.contains(section)) {
        return product.brandName == section;
      }
      return product.tags.contains(section);
  }
}

ProductModel? productById(String id) {
  for (final product in catalogProducts()) {
    if (product.id == id || product.title == id) return product;
  }
  return null;
}
