import 'package:flutter/material.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/shop_store.dart';
import 'package:sneaker_shop/route/route_constants.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ShopStore.instance,
      builder: (context, _) {
        final orders = ShopStore.instance.orders;
        return Scaffold(
          appBar: AppBar(title: Text(tr(context, "Orders"))),
          body: orders.isEmpty
              ? Center(child: Text(tr(context, "No orders yet")))
              : ListView.separated(
                  padding: const EdgeInsets.all(defaultPadding),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: defaultPadding),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          orderDetailsScreenRoute,
                          arguments: order.id,
                        );
                      },
                      child: Container(
                      padding: const EdgeInsets.all(defaultPadding),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).dividerColor),
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadious),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                order.id,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const Spacer(),
                              Text(
                                tr(context, orderStatusLabel(order.status)),
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: defaultPadding / 2),
                          Text(
                            order.items
                                .map((item) =>
                                    "${item.product.title} · ${item.size} · ${item.colorName} × ${item.quantity}")
                                .join("\n"),
                          ),
                          const SizedBox(height: defaultPadding / 2),
                          Text(order.address),
                          Text("${tr(context, "Card")} •••• ${order.cardLast4}"),
                          const SizedBox(height: defaultPadding / 2),
                          Text(
                            "\$${order.total.toStringAsFixed(2)}",
                            style: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    );
                  },
                ),
        );
      },
    );
  }
}
