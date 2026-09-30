import 'package:flutter/material.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/shop_store.dart';

class ReturnsScreen extends StatelessWidget {
  const ReturnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ShopStore.instance,
      builder: (context, _) {
        final orders = ShopStore.instance.returnableOrders;
        return Scaffold(
          appBar: AppBar(title: Text(tr(context, "Returns"))),
          body: orders.isEmpty
              ? Center(
                  child: Text(tr(context, "Delivered orders will appear here")),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(defaultPadding),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: defaultPadding),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final canReturn = order.status == OrderStatus.delivered;
                    return Container(
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
                              Text(tr(context, orderStatusLabel(order.status))),
                            ],
                          ),
                          const SizedBox(height: defaultPadding / 2),
                          Text(
                            order.items
                                .map((item) => item.product.title)
                                .join(", "),
                          ),
                          const SizedBox(height: defaultPadding),
                          if (canReturn)
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {
                                  ShopStore.instance.requestReturn(order);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(tr(context, "Return requested")),
                                    ),
                                  );
                                },
                                child: Text(tr(context, "Request return")),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
