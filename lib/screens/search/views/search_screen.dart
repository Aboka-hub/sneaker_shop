import 'package:flutter/material.dart';
import 'package:sneaker_shop/components/product/product_card.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/models/product_model.dart';
import 'package:sneaker_shop/route/route_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Весь демо-каталог без дублей по названию
  late final List<ProductModel> _allProducts = {
    for (final p in [
      ...demoPopularProducts,
      ...demoFlashSaleProducts,
      ...demoBestSellersProducts,
    ])
      p.title: p
  }.values.toList();

  String _query = "";

  List<ProductModel> get _results {
    if (_query.isEmpty) return _allProducts;
    final q = _query.toLowerCase();
    return _allProducts
        .where((p) =>
            p.title.toLowerCase().contains(q) ||
            p.brandName.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Search sneakers"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: TextField(
                autofocus: true,
                onChanged: (value) => setState(() => _query = value),
                decoration: const InputDecoration(
                  hintText: "Nike, Puma, running…",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            if (results.isEmpty)
              const Expanded(
                child: Center(child: Text("Nothing found")),
              )
            else
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding, vertical: defaultPadding / 2),
                  itemCount: results.length,
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200.0,
                    mainAxisSpacing: defaultPadding,
                    crossAxisSpacing: defaultPadding,
                    childAspectRatio: 0.66,
                  ),
                  itemBuilder: (context, index) => ProductCard(
                    image: results[index].image,
                    brandName: results[index].brandName,
                    title: results[index].title,
                    price: results[index].price,
                    priceAfetDiscount: results[index].priceAfetDiscount,
                    dicountpercent: results[index].dicountpercent,
                    press: () {
                      Navigator.pushNamed(context, productDetailsScreenRoute);
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
