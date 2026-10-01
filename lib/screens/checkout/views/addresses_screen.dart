import 'package:flutter/material.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/models/shop_store.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _label = TextEditingController();
  final _fullAddress = TextEditingController();

  @override
  void dispose() {
    _label.dispose();
    _fullAddress.dispose();
    super.dispose();
  }

  void _addAddress() {
    if (!_formKey.currentState!.validate()) return;
    ShopStore.instance.addAddress(_label.text.trim(), _fullAddress.text.trim());
    _label.clear();
    _fullAddress.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ShopStore.instance,
      builder: (context, _) {
        final addresses = ShopStore.instance.addresses;
        return Scaffold(
          appBar: AppBar(title: Text(tr(context, "My addresses"))),
          body: ListView(
            padding: const EdgeInsets.all(defaultPadding),
            children: [
              if (addresses.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: defaultPadding),
                  child: Text(tr(context, "No addresses yet")),
                ),
              ...addresses.map(
                (address) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_on_outlined,
                      color: primaryColor),
                  title: Text(address.label),
                  subtitle: Text(address.fullAddress),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 18, color: greyColor),
                    onPressed: () =>
                        ShopStore.instance.removeAddress(address.id),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
              Text(tr(context, "Add an address"),
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: defaultPadding),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _label,
                      decoration:
                          InputDecoration(labelText: tr(context, "Label")),
                      validator: (value) => value == null || value.isEmpty
                          ? tr(context, "Required")
                          : null,
                    ),
                    const SizedBox(height: defaultPadding),
                    TextFormField(
                      controller: _fullAddress,
                      decoration: InputDecoration(
                          labelText: tr(context, "Full address")),
                      validator: (value) => value == null || value.isEmpty
                          ? tr(context, "Required")
                          : null,
                    ),
                    const SizedBox(height: defaultPadding * 1.5),
                    ElevatedButton(
                      onPressed: _addAddress,
                      child: Text(tr(context, "Save address")),
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
