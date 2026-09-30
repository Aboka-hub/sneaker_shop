import 'package:flutter/material.dart';
import 'package:sneaker_shop/components/product/product_card.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/category_model.dart';
import 'package:sneaker_shop/models/product_model.dart';
import 'package:sneaker_shop/route/route_constants.dart';
import 'package:sneaker_shop/screens/search/views/search_screen.dart';
import 'package:sneaker_shop/screens/search/views/components/search_form.dart';

import 'components/expansion_category.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  void _openSearch(BuildContext context, {String? query, String? category}) {
    final text = query?.trim() ?? "";
    Navigator.pushNamed(
      context,
      searchScreenRoute,
      arguments: SearchArgs(
        query: text.isEmpty ? null : text,
        category: category,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final openedAsPage =
        ModalRoute.of(context)?.settings.name == discoverScreenRoute;
    final popular = catalogProducts().take(8).toList();
    final brands = {
      for (final product in catalogProducts()) product.brandName,
    }.toList();

    return Scaffold(
      appBar: openedAsPage
          ? AppBar(
              title: Text(tr(context, "Sneaker categories")),
            )
          : null,
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SearchForm(
                onFieldSubmitted: (value) => _openSearch(context, query: value),
                onTabFilter: () => _openSearch(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                tr(context, "Brands"),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                children: [
                  for (final brand in brands)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(brand),
                        onPressed: () => _openSearch(context, query: brand),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(
                tr(context, "Popular sneakers"),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: defaultPadding / 2),
            SizedBox(
              height: 220,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popular.length,
                itemBuilder: (context, index) {
                  final product = popular[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      left: defaultPadding,
                      right: index == popular.length - 1 ? defaultPadding : 0,
                    ),
                    child: ProductCard(
                      image: product.image,
                      brandName: product.brandName,
                      title: product.title,
                      price: product.price,
                      priceAfetDiscount: product.priceAfetDiscount,
                      dicountpercent: product.dicountpercent,
                      press: () {
                        Navigator.pushNamed(
                          context,
                          productDetailsScreenRoute,
                          arguments: product.id,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            if (!openedAsPage)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: defaultPadding),
                child: Text(
                  tr(context, "Sneaker categories"),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              )
            else
              const SizedBox(height: defaultPadding),
            ...List.generate(
              demoCategories.length,
              (index) => ExpansionCategory(
                svgSrc: demoCategories[index].svgSrc!,
                title: demoCategories[index].title,
                subCategory: demoCategories[index].subCategories!,
              ),
            ),
            const SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }
}
