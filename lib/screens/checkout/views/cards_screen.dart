import 'package:flutter/material.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/models/shop_store.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _holder = TextEditingController();
  final _number = TextEditingController();
  final _expiry = TextEditingController();

  @override
  void dispose() {
    _holder.dispose();
    _number.dispose();
    _expiry.dispose();
    super.dispose();
  }

  void _addCard() {
    if (!_formKey.currentState!.validate()) return;
    final digits = _number.text.replaceAll(RegExp(r"\D"), "");
    ShopStore.instance.addCard(
      PaymentCard(
        holder: _holder.text.trim(),
        last4: digits.substring(digits.length - 4),
        expiry: _expiry.text.trim(),
      ),
    );
    _holder.clear();
    _number.clear();
    _expiry.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ShopStore.instance,
      builder: (context, _) {
        final cards = ShopStore.instance.cards;
        return Scaffold(
          appBar: AppBar(title: Text(tr(context, "Payment cards"))),
          body: ListView(
            padding: const EdgeInsets.all(defaultPadding),
            children: [
              if (cards.isEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: defaultPadding),
                  child: Text(tr(context, "No saved cards")),
                ),
              ...cards.map(
                (card) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.credit_card, color: primaryColor),
                  title: Text("•••• ${card.last4}"),
                  subtitle: Text("${card.holder}  ${card.expiry}"),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Text(tr(context, "Add a card"), style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: defaultPadding),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _holder,
                      decoration:
                          InputDecoration(labelText: tr(context, "Name on card")),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFormField(
                      controller: _number,
                      keyboardType: TextInputType.number,
                      decoration:
                          InputDecoration(labelText: tr(context, "Card number")),
                      validator: (value) {
                        final digits =
                            (value ?? "").replaceAll(RegExp(r"\D"), "");
                        if (digits.length < 12) return "Enter a valid card";
                        return null;
                      },
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFormField(
                      controller: _expiry,
                      decoration:
                          InputDecoration(labelText: tr(context, "Expiry MM/YY")),
                      validator: (value) =>
                          value == null || value.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: defaultPadding * 1.5),
                    ElevatedButton(
                      onPressed: _addCard,
                      child: Text(tr(context, "Save card")),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
