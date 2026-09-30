import 'package:flutter/material.dart';
import 'package:sneaker_shop/components/product/product_card.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/product_model.dart';
import 'package:sneaker_shop/route/route_constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.category});

  final String? category;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final List<ProductModel> _allProducts = catalogProducts();
  late final List<String> _brands = {
    for (final product in _allProducts) product.brandName,
  }.toList();

  String _query = "";
  String? _brand;
  String? _size;
  String? _category;

  @override
  void initState() {
    super.initState();
    final category = widget.category;
    _category = category == null || category == "All sneakers" ? null : category;
  }

  List<String> get _availableSizes {
    final sizes = <String>{};
    for (final product in _allProducts) {
      if (_category != null && !product.tags.contains(_category)) continue;
      sizes.addAll(product.sizes);
    }
    final list = sizes.toList();
    list.sort((a, b) => (int.tryParse(a) ?? 0).compareTo(int.tryParse(b) ?? 0));
    return list;
  }

  List<ProductModel> get _results {
    final q = _query.toLowerCase();
    return _allProducts.where((product) {
      final matchesQuery = q.isEmpty ||
          product.title.toLowerCase().contains(q) ||
          product.brandName.toLowerCase().contains(q);
      final matchesBrand = _brand == null || product.brandName == _brand;
      final matchesSize = _size == null || product.sizes.contains(_size);
      final matchesCategory =
          _category == null || product.tags.contains(_category);
      return matchesQuery && matchesBrand && matchesSize && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      appBar: AppBar(
        title: Text(_category == null
            ? tr(context, "Search sneakers")
            : tr(context, _category!)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  defaultPadding, defaultPadding, defaultPadding, 0),
              child: TextField(
                autofocus: true,
                onChanged: (value) => setState(() => _query = value),
                decoration: InputDecoration(
                  hintText: tr(context, "Nike, Puma, running…"),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(tr(context, "All brands")),
                      selected: _brand == null,
                      onSelected: (_) => setState(() => _brand = null),
                    ),
                  ),
                  for (final brand in _brands)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(brand),
                        selected: _brand == brand,
                        onSelected: (_) => setState(
                          () => _brand = _brand == brand ? null : brand,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(tr(context, "All sizes")),
                      selected: _size == null,
                      onSelected: (_) => setState(() => _size = null),
                    ),
                  ),
                  for (final size in _availableSizes)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(size),
                        selected: _size == size,
                        onSelected: (_) => setState(
                          () => _size = _size == size ? null : size,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_category != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: FilterChip(
                    label: Text(tr(context, _category!)),
                    selected: true,
                    onSelected: (_) => setState(() => _category = null),
                  ),
                ),
              ),
            if (results.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    _category == null
                        ? tr(context, "Nothing found")
                        : tr(context, "No products in category")
                            .replaceAll("{name}", tr(context, _category!)),
                  ),
                ),
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
