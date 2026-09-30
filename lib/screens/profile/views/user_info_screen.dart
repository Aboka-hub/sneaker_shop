import 'package:flutter/material.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/shop_store.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    final store = ShopStore.instance;
    _name = TextEditingController(text: store.userName);
    _email = TextEditingController(text: store.userEmail);
    _phone = TextEditingController(text: store.userPhone);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ShopStore.instance.updateProfile(
      name: _name.text.trim(),
      email: _email.text.trim(),
      phone: _phone.text.trim(),
    );
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr(context, "Profile updated"))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, "My profile"))),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(defaultPadding),
          children: [
            const SizedBox(height: defaultPadding),
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    radius: 58,
                    backgroundImage: AssetImage(profileAvatar),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.photo_camera,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: defaultPadding),
            Text(
              _name.text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              _email.text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: defaultPadding * 1.5),
            Text(
              tr(context, "Personal details"),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              controller: _name,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: tr(context, "Full name"),
                prefixIcon: const Icon(Icons.person_outline),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? tr(context, "Required") : null,
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              controller: _email,
              onChanged: (_) => setState(() {}),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: tr(context, "Email"),
                prefixIcon: const Icon(Icons.mail_outline),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? tr(context, "Required") : null,
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: tr(context, "Phone"),
                prefixIcon: const Icon(Icons.phone_outlined),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? tr(context, "Required") : null,
            ),
            const SizedBox(height: defaultPadding * 2),
            ElevatedButton(
              onPressed: _save,
              child: Text(tr(context, "Save")),
            ),
          ],
        ),
      ),
    );
  }
}
