import 'package:flutter/material.dart';
import 'package:sneaker_shop/components/product/product_card.dart';
import 'package:sneaker_shop/models/product_model.dart';
import 'package:sneaker_shop/models/shop_store.dart';
import 'package:sneaker_shop/route/route_constants.dart';

import '../../../constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ShopStore.instance,
      builder: (context, _) {
        final products = [
          for (final title in ShopStore.instance.wishlist)
            if (productByTitle(title) != null) productByTitle(title)!,
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(tr(context, "Wishlist")),
          ),
          body: products.isEmpty
              ? Center(
                  child: Text(tr(context, "Tap the heart on a sneaker")),
                )
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding, vertical: defaultPadding),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.0,
                          mainAxisSpacing: defaultPadding,
                          crossAxisSpacing: defaultPadding,
                          childAspectRatio: 0.66,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final product = products[index];
                            return ProductCard(
                              image: product.image,
                              brandName: product.brandName,
                              title: product.title,
                              price: product.price,
                              priceAfetDiscount: product.priceAfetDiscount,
                              dicountpercent: product.dicountpercent,
                              press: () {
                                Navigator.pushNamed(
                                    context, productDetailsScreenRoute);
                              },
                            );
                          },
                          childCount: products.length,
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}
