import 'package:flutter/material.dart';
import 'package:sneaker_shop/components/cart_button.dart';
import 'package:sneaker_shop/components/network_image_with_loader.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/product_model.dart';
import 'package:sneaker_shop/models/shop_store.dart';
import 'package:sneaker_shop/route/route_constants.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ShopStore.instance,
      builder: (context, _) {
        final store = ShopStore.instance;
        if (store.cart.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(tr(context, "Cart"))),
            body: Center(child: Text(tr(context, "Your cart is empty"))),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(tr(context, "Cart"))),
          bottomNavigationBar: CartButton(
            price: store.cartTotal,
            title: tr(context, "Checkout"),
            subTitle: tr(context, "Total price"),
            press: () {
              Navigator.pushNamed(context, checkoutScreenRoute);
            },
          ),
          body: ListView.separated(
            padding: const EdgeInsets.all(defaultPadding),
            itemCount: store.cart.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: defaultPadding),
            itemBuilder: (context, index) {
              final line = store.cart[index];
              return _CartItemTile(
                product: line.product,
                size: line.size,
                colorName: line.colorName,
                quantity: line.quantity,
                onIncrement: () => store.changeQuantity(index, 1),
                onDecrement: () => store.changeQuantity(index, -1),
                onRemove: () => store.removeFromCart(index),
              );
            },
          ),
        );
      },
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.product,
    required this.size,
    required this.colorName,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final ProductModel product;
  final String size;
  final String colorName;
  final int quantity;
  final VoidCallback onIncrement, onDecrement, onRemove;

  @override
  Widget build(BuildContext context) {
    final price = product.priceAfetDiscount ?? product.price;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 1,
            child: NetworkImageWithLoader(product.image,
                radius: defaultBorderRadious),
          ),
        ),
        const SizedBox(width: defaultPadding),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.brandName.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontSize: 10),
              ),
              const SizedBox(height: defaultPadding / 4),
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: defaultPadding / 4),
              Text(
                "$size · $colorName",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: defaultPadding / 2),
              Row(
                children: [
                  Text(
                    "\$${(price * quantity).toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  _QuantityButton(icon: Icons.remove, press: onDecrement),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: Text("$quantity"),
                  ),
                  _QuantityButton(icon: Icons.add, press: onIncrement),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onRemove,
          icon: const Icon(Icons.close, size: 18, color: greyColor),
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.press});

  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: BorderRadius.circular(defaultBorderRadious),
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(defaultBorderRadious),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }
}
