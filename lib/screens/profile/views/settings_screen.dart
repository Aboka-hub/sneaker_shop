import 'package:flutter/material.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/shop_store.dart';
import 'package:sneaker_shop/screens/auth/views/components/login_form.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _passwordFormKey = GlobalKey<FormState>();
  final _oldPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _oldPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (!_passwordFormKey.currentState!.validate()) return;
    final ok = ShopStore.instance.changePassword(
      _oldPassword.text,
      _newPassword.text,
    );
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(context, "Current password is incorrect"))),
      );
      return;
    }
    _oldPassword.clear();
    _newPassword.clear();
    _confirmPassword.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr(context, "Password changed"))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = L10n.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(tr(context, "Settings"))),
      body: ListView(
        padding: const EdgeInsets.all(defaultPadding),
        children: [
          Text(
            tr(context, "Language"),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: defaultPadding),
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Text("Русский"),
                  selected: lang.code == "ru",
                  onSelected: (_) {
                    if (lang.code != "ru") L10n.instance.toggle();
                  },
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: ChoiceChip(
                  label: const Text("English"),
                  selected: lang.code == "en",
                  onSelected: (_) {
                    if (lang.code != "en") L10n.instance.toggle();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding * 2),
          Text(
            tr(context, "Account"),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: defaultPadding / 2),
          ListenableBuilder(
            listenable: ShopStore.instance,
            builder: (context, _) => Text(
              ShopStore.instance.userEmail,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: defaultPadding * 1.5),
          Text(
            tr(context, "Change password"),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: defaultPadding),
          Form(
            key: _passwordFormKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _oldPassword,
                  obscureText: true,
                  decoration:
                      InputDecoration(labelText: tr(context, "Current password")),
                  validator: (value) =>
                      value == null || value.isEmpty ? tr(context, "Required") : null,
                ),
                const SizedBox(height: defaultPadding),
                TextFormField(
                  controller: _newPassword,
                  obscureText: true,
                  decoration:
                      InputDecoration(labelText: tr(context, "New password")),
                  validator: (value) => passwordError(context, value),
                ),
                const SizedBox(height: defaultPadding),
                TextFormField(
                  controller: _confirmPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: tr(context, "Confirm new password")),
                  validator: (value) => value != _newPassword.text
                      ? tr(context, "Passwords don't match")
                      : null,
                ),
                const SizedBox(height: defaultPadding * 1.5),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _changePassword,
                    child: Text(tr(context, "Save")),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
