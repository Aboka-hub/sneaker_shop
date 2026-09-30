import 'package:flutter/material.dart';
import 'package:sneaker_shop/components/cart_button.dart';
import 'package:sneaker_shop/components/custom_modal_bottom_sheet.dart';
import 'package:sneaker_shop/components/network_image_with_loader.dart';
import 'package:sneaker_shop/screens/product/views/added_to_cart_message_screen.dart';
import 'package:sneaker_shop/screens/product/views/components/product_list_tile.dart';
import 'package:sneaker_shop/screens/product/views/location_permission_store_availability_screen.dart';

import '../../../constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import '../../../models/product_model.dart';
import '../../../models/shop_store.dart';
import 'components/product_quantity.dart';
import 'components/selected_colors.dart';
import 'components/selected_size.dart';
import 'components/unit_price.dart';

class ProductBuyNowScreen extends StatefulWidget {
  const ProductBuyNowScreen({super.key, required this.product});

  final ProductModel product;

  @override
  _ProductBuyNowScreenState createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  late final ProductModel _product = widget.product;
  int _quantity = 1;
  int _colorIndex = 0;
  late int _sizeIndex;

  List<String> get _sizes =>
      _product.sizes.isEmpty ? shoeSizes : _product.sizes;

  double get _unitPrice => _product.priceAfetDiscount ?? _product.price;

  @override
  void initState() {
    super.initState();
    final middle = _sizes.length ~/ 2;
    _sizeIndex = middle.clamp(0, _sizes.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CartButton(
        price: _unitPrice * _quantity,
        title: tr(context, "Add to cart"),
        subTitle: tr(context, "Total"),
        press: () {
          ShopStore.instance.addToCart(
            _product,
            size: _sizes[_sizeIndex],
            colorName: shoeColors[_colorIndex].name,
            quantity: _quantity,
          );
          customModalBottomSheet(
            context,
            isDismissible: false,
            child: const AddedToCartMessageScreen(),
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding / 2, vertical: defaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackButton(),
                Expanded(
                  child: Text(
                    _product.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ShopStore.instance.toggleWishlist(_product);
                    setState(() {});
                  },
                  icon: Icon(
                    ShopStore.instance.isInWishlist(_product)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: AspectRatio(
                      aspectRatio: 1.05,
                      child: NetworkImageWithLoader(_product.image),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: UnitPrice(
                            price: _product.price,
                            priceAfterDiscount: _product.priceAfetDiscount,
                          ),
                        ),
                        ProductQuantity(
                          numOfItem: _quantity,
                          onIncrement: () => setState(() => _quantity++),
                          onDecrement: () {
                            if (_quantity > 1) setState(() => _quantity--);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: Divider()),
                SliverToBoxAdapter(
                  child: SelectedColors(
                    colors: [for (final color in shoeColors) color.color],
                    selectedColorIndex: _colorIndex,
                    press: (value) => setState(() => _colorIndex = value),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SelectedSize(
                    sizes: _sizes,
                    selectedIndex: _sizeIndex,
                    press: (value) => setState(() => _sizeIndex = value),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  sliver: ProductListTile(
                    title: tr(context, "Size guide"),
                    svgSrc: "assets/icons/Sizeguid.svg",
                    isShowBottomBorder: true,
                    press: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            tr(context, "EU {size}")
                                .replaceAll("{size}", _sizes[_sizeIndex]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SliverPadding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: defaultPadding / 2),
                        Text(
                          "Store pickup availability",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: defaultPadding / 2),
                        const Text(
                            "Select a size to check store availability and In-Store pickup options.")
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  sliver: ProductListTile(
                    title: "Check stores",
                    svgSrc: "assets/icons/Stores.svg",
                    isShowBottomBorder: true,
                    press: () {
                      customModalBottomSheet(
                        context,
                        height: MediaQuery.of(context).size.height * 0.92,
                        child: const LocationPermissonStoreAvailabilityScreen(),
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                    child: SizedBox(height: defaultPadding))
              ],
            ),
          )
        ],
      ),
    );
  }
}
