import 'package:flutter/material.dart';
import 'package:sneaker_shop/components/network_image_with_loader.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/shop_store.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ShopStore.instance,
      builder: (context, _) {
        final order = ShopStore.instance.orderById(orderId);
        if (order == null) {
          return Scaffold(
            appBar: AppBar(title: Text(tr(context, "Order"))),
            body: Center(child: Text(tr(context, "Order not found"))),
          );
        }

        final date =
            "${order.createdAt.day.toString().padLeft(2, '0')}."
            "${order.createdAt.month.toString().padLeft(2, '0')}."
            "${order.createdAt.year}";

        return Scaffold(
          appBar: AppBar(title: Text(order.id)),
          body: ListView(
            padding: const EdgeInsets.all(defaultPadding),
            children: [
              Text(
                tr(context, orderStatusLabel(order.status)),
                style: const TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: defaultPadding / 2),
              Text("${tr(context, "Date")}: $date"),
              const SizedBox(height: defaultPadding),
              Text(tr(context, "Items"), style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: defaultPadding),
              for (final item in order.items) ...[
                Row(
                  children: [
                    SizedBox(
                      width: 64,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: NetworkImageWithLoader(item.product.image,
                            radius: defaultBorderRadious),
                      ),
                    ),
                    const SizedBox(width: defaultPadding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.product.title),
                          Text(
                            "${item.size} · ${item.colorName} · × ${item.quantity}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Text("\$${(item.price * item.quantity).toStringAsFixed(2)}"),
                  ],
                ),
                const SizedBox(height: defaultPadding),
              ],
              const Divider(),
              const SizedBox(height: defaultPadding),
              Text(tr(context, "Address"), style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: defaultPadding / 2),
              Text(order.address),
              const SizedBox(height: defaultPadding),
              Text(tr(context, "Payment"), style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: defaultPadding / 2),
              Text("${tr(context, "Card")} •••• ${order.cardLast4}"),
              const SizedBox(height: defaultPadding),
              Text(
                "${tr(context, "Total")} \$${order.total.toStringAsFixed(2)}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
