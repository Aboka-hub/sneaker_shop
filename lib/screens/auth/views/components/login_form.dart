import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';

class LogInForm extends StatelessWidget {
  const LogInForm({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            onSaved: (emal) {
            },
            validator: (value) => emailError(context, value),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: tr(context, "Email address"),
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Message.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.3),
                      BlendMode.srcIn),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          TextFormField(
            onSaved: (pass) {
            },
            validator: (value) => passwordError(context, value),
            obscureText: true,
            decoration: InputDecoration(
              hintText: tr(context, "Password"),
              prefixIcon: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: defaultPadding * 0.75),
                child: SvgPicture.asset(
                  "assets/icons/Lock.svg",
                  height: 24,
                  width: 24,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.3),
                      BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String? emailError(BuildContext context, String? value) {
  final text = value?.trim() ?? "";
  if (text.isEmpty) return tr(context, "Email is required");
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(text)) {
    return tr(context, "Enter a valid email address");
  }
  return null;
}

String? passwordError(BuildContext context, String? value) {
  final text = value ?? "";
  if (text.isEmpty) return tr(context, "Password is required");
  if (text.length < 8) {
    return tr(context, "Password must be at least 8 characters");
  }
  if (!RegExp(r'[#?!@$%^&*-]').hasMatch(text)) {
    return tr(context, "Password needs a special character");
  }
  return null;
}
