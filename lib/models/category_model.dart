class CategoryModel {
  final String title;
  final String? image, svgSrc;
  final List<CategoryModel>? subCategories;

  CategoryModel({
    required this.title,
    this.image,
    this.svgSrc,
    this.subCategories,
  });
}

final List<CategoryModel> demoCategoriesWithImage = [
  CategoryModel(title: "Men’s", image: "assets/images/products/jordan_4.webp"),
  CategoryModel(title: "Women’s", image: "assets/images/products/puma_1.webp"),
  CategoryModel(title: "Running", image: "assets/images/products/puma_2.webp"),
  CategoryModel(title: "Kid’s", image: "assets/images/products/jordan_2.webp"),
];

final List<CategoryModel> demoCategories = [
  CategoryModel(
    title: "Sneakers",
    svgSrc: "assets/icons/Man&Woman.svg",
    subCategories: [
      CategoryModel(title: "All sneakers"),
      CategoryModel(title: "New arrivals"),
      CategoryModel(title: "Lifestyle"),
      CategoryModel(title: "Retro"),
      CategoryModel(title: "High tops"),
    ],
  ),
  CategoryModel(
    title: "Sport",
    svgSrc: "assets/icons/Sale.svg",
    subCategories: [
      CategoryModel(title: "Running"),
      CategoryModel(title: "Basketball"),
      CategoryModel(title: "Football boots"),
    ],
  ),
  CategoryModel(
    title: "Kids",
    svgSrc: "assets/icons/Child.svg",
    subCategories: [
      CategoryModel(title: "Boys"),
      CategoryModel(title: "Girls"),
      CategoryModel(title: "First steps"),
    ],
  ),
  CategoryModel(
    title: "On Sale",
    svgSrc: "assets/icons/Sale.svg",
    subCategories: [
      CategoryModel(title: "Discounted pairs"),
      CategoryModel(title: "Under \$100"),
    ],
  ),
  CategoryModel(
    title: "Brands",
    svgSrc: "assets/icons/Category.svg",
    subCategories: [
      CategoryModel(title: "Nike"),
      CategoryModel(title: "Puma"),
      CategoryModel(title: "New Balance"),
      CategoryModel(title: "Off White"),
    ],
  ),
];
