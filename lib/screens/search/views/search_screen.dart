import 'package:flutter/material.dart';
import 'package:sneaker_shop/components/product/product_card.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/product_model.dart';
import 'package:sneaker_shop/route/route_constants.dart';

class SearchArgs {
  const SearchArgs({this.category, this.query});

  final String? category;
  final String? query;
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.category, this.initialQuery});

  final String? category;
  final String? initialQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final List<ProductModel> _allProducts = catalogProducts();
  late final List<String> _brands = {
    for (final product in _allProducts) product.brandName,
  }.toList();

  late final TextEditingController _queryController;
  late String _query;
  String? _brand;
  String? _size;
  String? _category;
  _CatalogSort _sort = _CatalogSort.featured;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery ?? "";
    _queryController = TextEditingController(text: _query);
    final category = widget.category;
    _category = category == null || category == "All sneakers" ? null : category;
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  List<String> get _availableSizes {
    final sizes = <String>{};
    for (final product in _allProducts) {
      if (!matchesCatalogSection(product, _category)) continue;
      sizes.addAll(product.sizes);
    }
    final list = sizes.toList();
    list.sort((a, b) => (int.tryParse(a) ?? 0).compareTo(int.tryParse(b) ?? 0));
    return list;
  }

  double _unitPrice(ProductModel product) =>
      product.priceAfetDiscount ?? product.price;

  List<ProductModel> get _results {
    final q = _query.toLowerCase();
    final list = _allProducts.where((product) {
      final matchesQuery = q.isEmpty ||
          product.title.toLowerCase().contains(q) ||
          product.brandName.toLowerCase().contains(q);
      final matchesBrand = _brand == null || product.brandName == _brand;
      final matchesSize = _size == null || product.sizes.contains(_size);
      final matchesCategory = matchesCatalogSection(product, _category);
      return matchesQuery && matchesBrand && matchesSize && matchesCategory;
    }).toList();
    switch (_sort) {
      case _CatalogSort.cheaper:
        list.sort((a, b) => _unitPrice(a).compareTo(_unitPrice(b)));
      case _CatalogSort.expensive:
        list.sort((a, b) => _unitPrice(b).compareTo(_unitPrice(a)));
      case _CatalogSort.sale:
        list.sort((a, b) =>
            (b.dicountpercent ?? 0).compareTo(a.dicountpercent ?? 0));
      case _CatalogSort.featured:
        break;
    }
    return list;
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
                autofocus: widget.initialQuery == null,
                controller: _queryController,
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
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                children: [
                  for (final sort in _CatalogSort.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(tr(context, sort.label)),
                        selected: _sort == sort,
                        onSelected: (_) => setState(() => _sort = sort),
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
                    maxCrossAxisExtent: 220.0,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.68,
                  ),
                  itemBuilder: (context, index) => ProductCard(
                    image: results[index].image,
                    brandName: results[index].brandName,
                    title: results[index].title,
                    price: results[index].price,
                    priceAfetDiscount: results[index].priceAfetDiscount,
                    dicountpercent: results[index].dicountpercent,
                    press: () {
                      Navigator.pushNamed(
                        context,
                        productDetailsScreenRoute,
                        arguments: results[index].id,
                      );
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

enum _CatalogSort {
  featured,
  cheaper,
  expensive,
  sale;

  String get label {
    switch (this) {
      case _CatalogSort.featured:
        return "Featured";
      case _CatalogSort.cheaper:
        return "Cheaper";
      case _CatalogSort.expensive:
        return "More expensive";
      case _CatalogSort.sale:
        return "On sale";
    }
  }
}
