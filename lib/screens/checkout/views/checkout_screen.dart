import 'package:flutter/material.dart';
import 'package:sneaker_shop/components/cart_button.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/shop_store.dart';
import 'package:sneaker_shop/route/route_constants.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(text: "Alex Runner");
  final _phone = TextEditingController(text: "+7 700 000 00 00");
  final _address = TextEditingController(text: "Abay 10, Almaty");
  int _cardIndex = 0;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  void _placeOrder() {
    final store = ShopStore.instance;
    if (!_formKey.currentState!.validate()) return;
    if (store.cards.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(context, "Add a payment card first"))),
      );
      Navigator.pushNamed(context, cardsScreenRoute);
      return;
    }
    store.placeOrder(
      address: "${_name.text}, ${_phone.text}, ${_address.text}",
      card: store.cards[_cardIndex],
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      ordersScreenRoute,
      (route) => route.isFirst,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr(context, "Order placed"))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ShopStore.instance,
      builder: (context, _) {
        final store = ShopStore.instance;
        if (store.cart.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(tr(context, "Checkout"))),
            body: Center(child: Text(tr(context, "Your cart is empty"))),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(tr(context, "Checkout"))),
          bottomNavigationBar: CartButton(
            price: store.cartTotal,
            title: tr(context, "Place order"),
            subTitle: tr(context, "Total"),
            press: _placeOrder,
          ),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(defaultPadding),
              children: [
                Text(tr(context, "Delivery"), style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: defaultPadding),
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(labelText: tr(context, "Full name")),
                  validator: (value) =>
                      value == null || value.isEmpty ? tr(context, "Required") : null,
                ),
                const SizedBox(height: defaultPadding),
                TextFormField(
                  controller: _phone,
                  decoration: InputDecoration(labelText: tr(context, "Phone")),
                  validator: (value) =>
                      value == null || value.isEmpty ? tr(context, "Required") : null,
                ),
                const SizedBox(height: defaultPadding),
                TextFormField(
                  controller: _address,
                  decoration: InputDecoration(labelText: tr(context, "Address")),
                  validator: (value) =>
                      value == null || value.isEmpty ? tr(context, "Required") : null,
                ),
                const SizedBox(height: defaultPadding * 1.5),
                Row(
                  children: [
                    Text(tr(context, "Payment card"),
                        style: Theme.of(context).textTheme.titleSmall),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, cardsScreenRoute),
                      child: Text(tr(context, "Manage")),
                    ),
                  ],
                ),
                if (store.cards.isEmpty)
                  Text(tr(context, "No cards yet"))
                else
                  ...List.generate(store.cards.length, (index) {
                    final card = store.cards[index];
                    return RadioListTile<int>(
                      value: index,
                      groupValue: _cardIndex,
                      onChanged: (value) =>
                          setState(() => _cardIndex = value ?? 0),
                      title: Text("•••• ${card.last4}"),
                      subtitle: Text("${card.holder}  ${card.expiry}"),
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}
