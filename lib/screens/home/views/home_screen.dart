import 'package:flutter/material.dart';
import 'package:sneaker_shop/components/Banner/S/banner_s_style_1.dart';
import 'package:sneaker_shop/components/Banner/S/banner_s_style_5.dart';
import 'package:sneaker_shop/components/product/product_card.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/product_model.dart';
import 'package:sneaker_shop/route/screen_export.dart';

import 'components/best_sellers.dart';
import 'components/flash_sale.dart';
import 'components/most_popular.dart';
import 'components/new_this_week.dart';
import 'components/offer_carousel_and_categories.dart';
import 'components/popular_products.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _category = "All Sneakers";

  @override
  Widget build(BuildContext context) {
    final filtered = catalogProducts()
        .where((product) => matchesHomeChip(product, _category))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: OffersCarouselAndCategories(
                selected: _category,
                onSelected: (value) => setState(() => _category = value),
              ),
            ),
            if (_category != "All Sneakers")
              filtered.isEmpty
                  ? SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(tr(context, "Nothing found")),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.all(defaultPadding),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          mainAxisSpacing: defaultPadding,
                          crossAxisSpacing: defaultPadding,
                          childAspectRatio: 0.68,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = filtered[index];
                            return ProductCard(
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
                            );
                          },
                          childCount: filtered.length,
                        ),
                      ),
                    )
            else ...[
            const SliverToBoxAdapter(child: NewThisWeek()),
            const SliverToBoxAdapter(child: PopularProducts()),
            const SliverPadding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding * 1.5),
              sliver: SliverToBoxAdapter(child: FlashSale()),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  BannerSStyle1(
                    title: tr(context, "New \nsneakers"),
                    subtitle: tr(context, "SPECIAL OFFER"),
                    discountParcent: 50,
                    press: () {
                      Navigator.pushNamed(
                        context,
                        productDetailsScreenRoute,
                        arguments: "Sports Sneakers Off White Red",
                      );
                    },
                  ),
                  const SizedBox(height: defaultPadding / 4),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: BestSellers()),
            const SliverToBoxAdapter(child: MostPopular()),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: defaultPadding * 1.5),
                  const SizedBox(height: defaultPadding / 4),
                  BannerSStyle5(
                    title: tr(context, "Running \nweek"),
                    subtitle: tr(context, "50% Off"),
                    bottomText: tr(context, "SNEAKERS"),
                    press: () {
                      Navigator.pushNamed(
                        context,
                        searchScreenRoute,
                        arguments: "Running",
                      );
                    },
                  ),
                  const SizedBox(height: defaultPadding / 4),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: BestSellers()),
            ],
          ],
        ),
      ),
    );
  }
}
