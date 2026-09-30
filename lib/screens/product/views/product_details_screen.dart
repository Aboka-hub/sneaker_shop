import 'package:flutter/material.dart';
import 'package:sneaker_shop/components/cart_button.dart';
import 'package:sneaker_shop/components/custom_modal_bottom_sheet.dart';
import 'package:sneaker_shop/components/product/product_card.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/product_model.dart';
import 'package:sneaker_shop/models/shop_store.dart';
import 'package:sneaker_shop/screens/product/views/product_returns_screen.dart';

import 'package:sneaker_shop/route/screen_export.dart';

import 'components/notify_me_card.dart';
import 'components/product_images.dart';
import 'components/product_info.dart';
import 'components/product_list_tile.dart';
import '../../../components/review_card.dart';
import 'product_buy_now_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, this.isProductAvailable = true});

  final bool isProductAvailable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: isProductAvailable
          ? CartButton(
              price: demoPopularProducts.first.priceAfetDiscount ??
                  demoPopularProducts.first.price,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ProductBuyNowScreen(),
                );
              },
            )
          :

          NotifyMeCard(
              isNotify: false,
              onChanged: (value) {},
            ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              floating: true,
              actions: [
                ListenableBuilder(
                  listenable: ShopStore.instance,
                  builder: (context, _) {
                    final saved = ShopStore.instance
                        .isInWishlist(demoPopularProducts.first);
                    return IconButton(
                      onPressed: () => ShopStore.instance
                          .toggleWishlist(demoPopularProducts.first),
                      icon: Icon(
                        saved ? Icons.favorite : Icons.favorite_border,
                        color: primaryColor,
                      ),
                    );
                  },
                ),
              ],
            ),
            const ProductImages(
              images: [sneakerImg1, sneakerImg2, sneakerImg3, sneakerImg4],
            ),
            ProductInfo(
              brand: "NIKE",
              title: "Air Jordan 1 Retro High",
              isAvailable: isProductAvailable,
              description:
                  "Легендарный силуэт 1985 года: кожаный верх, перфорация на мыске "
                  "для вентиляции и амортизация Air в подошве. Универсальная пара "
                  "и для города, и для площадки.",
              rating: 4.4,
              numOfReviews: 126,
            ),
            ProductListTile(
              svgSrc: "assets/icons/Product.svg",
              title: tr(context, "Product Details"),
              press: () => _showInfoSheet(
                context,
                tr(context, "Product Details"),
                "Верх: натуральная кожа. Подошва: резина.\n"
                    "Тип фиксации: шнуровка.\nСтрана производства: Вьетнам.",
              ),
            ),
            ProductListTile(
              svgSrc: "assets/icons/Delivery.svg",
              title: tr(context, "Shipping Information"),
              press: () => _showInfoSheet(
                context,
                tr(context, "Shipping Information"),
                "Доставка по городу — 1–2 дня, по стране — 3–7 дней.\n"
                    "Бесплатно при заказе от \$150.",
              ),
            ),
            ProductListTile(
              svgSrc: "assets/icons/Return.svg",
              title: tr(context, "Returns"),
              isShowBottomBorder: true,
              press: () {
                customModalBottomSheet(
                  context,
                  height: MediaQuery.of(context).size.height * 0.92,
                  child: const ProductReturnsScreen(),
                );
              },
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: ReviewCard(
                  rating: 4.3,
                  numOfReviews: 128,
                  numOfFiveStar: 80,
                  numOfFourStar: 30,
                  numOfThreeStar: 5,
                  numOfTwoStar: 4,
                  numOfOneStar: 1,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(defaultPadding),
              sliver: SliverToBoxAdapter(
                child: Text(
                  tr(context, "You may also like"),
                  style: Theme.of(context).textTheme.titleSmall!,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: demoBestSellersProducts.length,
                  itemBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(
                        left: defaultPadding,
                        right: index == demoBestSellersProducts.length - 1
                            ? defaultPadding
                            : 0),
                    child: ProductCard(
                      image: demoBestSellersProducts[index].image,
                      title: demoBestSellersProducts[index].title,
                      brandName: demoBestSellersProducts[index].brandName,
                      price: demoBestSellersProducts[index].price,
                      priceAfetDiscount:
                          demoBestSellersProducts[index].priceAfetDiscount,
                      dicountpercent:
                          demoBestSellersProducts[index].dicountpercent,
                      press: () {
                        Navigator.pushNamed(context, productDetailsScreenRoute);
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: defaultPadding),
            )
          ],
        ),
      ),
    );
  }

  void _showInfoSheet(BuildContext context, String title, String body) {
    customModalBottomSheet(
      context,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: defaultPadding),
            Text(body),
          ],
        ),
      ),
    );
  }
}
