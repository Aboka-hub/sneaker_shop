import 'package:flutter/material.dart';

import '../../../../constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'categories.dart';
import 'offers_carousel.dart';

class OffersCarouselAndCategories extends StatelessWidget {
  const OffersCarouselAndCategories({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const OffersCarousel(),
        const SizedBox(height: defaultPadding / 2),
        Padding(
          padding: const EdgeInsets.all(defaultPadding),
          child: Text(
            tr(context, "Categories"),
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        Categories(selected: selected, onSelected: onSelected),
      ],
    );
  }
}
