import 'package:flutter/material.dart';
import 'package:sneaker_shop/components/product/product_card.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/product_model.dart';
import 'package:sneaker_shop/route/screen_export.dart';

import '../../../../constants.dart';

class NewThisWeek extends StatelessWidget {
  const NewThisWeek({super.key});

  @override
  Widget build(BuildContext context) {
    final products = catalogProducts()
        .where((product) => product.tags.contains("New arrivals"))
        .take(6)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            tr(context, "New this week"),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(
                left: defaultPadding,
                right: index == products.length - 1 ? defaultPadding : 0,
              ),
              child: ProductCard(
                image: products[index].image,
                brandName: products[index].brandName,
                title: products[index].title,
                price: products[index].price,
                priceAfetDiscount: products[index].priceAfetDiscount,
                dicountpercent: products[index].dicountpercent,
                press: () {
                  Navigator.pushNamed(
                    context,
                    productDetailsScreenRoute,
                    arguments: products[index].id,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
