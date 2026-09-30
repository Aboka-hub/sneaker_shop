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
  final _name = TextEditingController(text: ShopStore.instance.userName);
  final _phone = TextEditingController(text: ShopStore.instance.userPhone);
  final _address = TextEditingController();
  final _promo = TextEditingController();
  int _cardIndex = 0;
  String? _appliedCode;
  bool _promoRejected = false;

  static const _shippingFee = 12.0;
  static const _freeFrom = 150.0;

  double _discount(double subtotal) {
    switch (_appliedCode) {
      case "SNEAKER10":
        return subtotal * 0.10;
      case "HUB5":
        return subtotal < 5 ? subtotal : 5;
      default:
        return 0;
    }
  }

  double _shipping(double subtotal, double discount) {
    if (subtotal - discount >= _freeFrom) return 0;
    return _shippingFee;
  }

  double _payable(ShopStore store) {
    final subtotal = store.cartTotal;
    final discount = _discount(subtotal);
    return subtotal - discount + _shipping(subtotal, discount);
  }

  void _applyPromo() {
    final code = _promo.text.trim().toUpperCase();
    setState(() {
      if (code == "SNEAKER10" || code == "HUB5") {
        _appliedCode = code;
        _promoRejected = false;
        _promo.text = code;
      } else {
        _appliedCode = null;
        _promoRejected = true;
      }
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _promo.dispose();
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
      chargedTotal: _payable(store),
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
            price: _payable(store),
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
                Text(tr(context, "Promo code"),
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: defaultPadding),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _promo,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          labelText: tr(context, "Promo code"),
                          hintText: "SNEAKER10 / HUB5",
                          errorText: _promoRejected
                              ? tr(context, "Invalid promo code")
                              : null,
                          helperText: _appliedCode == null
                              ? null
                              : tr(context, "Promo applied"),
                        ),
                      ),
                    ),
                    const SizedBox(width: defaultPadding / 2),
                    TextButton(
                      onPressed: _applyPromo,
                      child: Text(tr(context, "Apply")),
                    ),
                  ],
                ),
                const SizedBox(height: defaultPadding),
                _SummaryLine(
                  label: tr(context, "Subtotal"),
                  value: store.cartTotal,
                ),
                if (_discount(store.cartTotal) > 0)
                  _SummaryLine(
                    label: tr(context, "Discount"),
                    value: -_discount(store.cartTotal),
                  ),
                _SummaryLine(
                  label: tr(context, "Shipping"),
                  value: _shipping(store.cartTotal, _discount(store.cartTotal)),
                  freeLabel: tr(context, "Free"),
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

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.freeLabel,
  });

  final String label;
  final double value;
  final String? freeLabel;

  @override
  Widget build(BuildContext context) {
    final text = value == 0 && freeLabel != null
        ? freeLabel!
        : value < 0
            ? "-\$${value.abs().toStringAsFixed(2)}"
            : "\$${value.toStringAsFixed(2)}";
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(label),
          const Spacer(),
          Text(text),
        ],
      ),
    );
  }
}
