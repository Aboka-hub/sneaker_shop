import 'package:flutter/material.dart';
import 'package:sneaker_shop/components/cart_button.dart';
import 'package:sneaker_shop/components/network_image_with_loader.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/models/product_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Демо-корзина: первые три товара каталога. Реальная корзина хранится
  // в состоянии приложения или на бэкенде.
  final List<ProductModel> _items = demoPopularProducts.take(3).toList();
  final List<int> _quantities = [1, 1, 2];

  double get _total {
    double sum = 0;
    for (var i = 0; i < _items.length; i++) {
      final item = _items[i];
      sum += (item.priceAfetDiscount ?? item.price) * _quantities[i];
    }
    return sum;
  }

  void _changeQuantity(int index, int delta) {
    setState(() {
      final next = _quantities[index] + delta;
      if (next >= 1) _quantities[index] = next;
    });
  }

  void _remove(int index) {
    setState(() {
      _items.removeAt(index);
      _quantities.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Your cart is empty")),
      );
    }

    return Scaffold(
      bottomNavigationBar: CartButton(
        price: _total,
        title: "Checkout",
        subTitle: "Total price",
        press: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Checkout is not connected yet")),
          );
        },
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.all(defaultPadding),
          itemCount: _items.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: defaultPadding),
          itemBuilder: (context, index) => _CartItemTile(
            product: _items[index],
            quantity: _quantities[index],
            onIncrement: () => _changeQuantity(index, 1),
            onDecrement: () => _changeQuantity(index, -1),
            onRemove: () => _remove(index),
          ),
        ),
      ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  const _CartItemTile({
    required this.product,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  final ProductModel product;
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
