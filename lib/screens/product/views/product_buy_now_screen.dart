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
  const ProductBuyNowScreen({super.key});

  @override
  _ProductBuyNowScreenState createState() => _ProductBuyNowScreenState();
}

class _ProductBuyNowScreenState extends State<ProductBuyNowScreen> {
  final ProductModel _product = demoPopularProducts.first;
  int _quantity = 1;
  int _colorIndex = 0;
  int _sizeIndex = 3;

  double get _unitPrice => _product.priceAfetDiscount ?? _product.price;

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
            size: shoeSizes[_sizeIndex],
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
                Text(
                  "Air Jordan 1 Retro High",
                  style: Theme.of(context).textTheme.titleSmall,
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
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: AspectRatio(
                      aspectRatio: 1.05,
                      child: NetworkImageWithLoader(sneakerImg1),
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
                    sizes: shoeSizes,
                    selectedIndex: _sizeIndex,
                    press: (value) => setState(() => _sizeIndex = value),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                  sliver: ProductListTile(
                    title: "Size guide",
                    svgSrc: "assets/icons/Sizeguid.svg",
                    isShowBottomBorder: true,
                    press: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("EU 40 ≈ US 7 ≈ 25.5 cm"),
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
