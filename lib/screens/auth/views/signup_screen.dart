import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sneaker_shop/screens/auth/views/components/sign_up_form.dart';
import 'package:sneaker_shop/models/shop_store.dart';
import 'package:sneaker_shop/route/route_constants.dart';

import '../../../constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreed = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(tr(context, "Please agree to the terms to continue")),
        ),
      );
      return;
    }
    final ok = ShopStore.instance.register(
      _emailController.text,
      _passwordController.text,
    );
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            tr(context, "An account with this email already exists"),
          ),
        ),
      );
      return;
    }
    Navigator.pushNamedAndRemoveUntil(
      context,
      entryPointScreenRoute,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _AuthShoe(),
                Text(
                  tr(context, "Let's get started!"),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: defaultPadding / 2),
                Text(
                  tr(
                    context,
                    "Please enter your valid data in order to create an account.",
                  ),
                ),
                const SizedBox(height: defaultPadding),
                SignUpForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  passwordController: _passwordController,
                ),
                const SizedBox(height: defaultPadding),
                Row(
                  children: [
                    Checkbox(
                      onChanged: (value) =>
                          setState(() => _agreed = value ?? false),
                      value: _agreed,
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: tr(context, "I agree with the"),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {},
                              text: tr(context, " Terms of service "),
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: tr(context, "& privacy policy."),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: defaultPadding * 2),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(tr(context, "Continue")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tr(context, "Do you have an account?")),
                    TextButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(
                            context,
                            logInScreenRoute,
                          );
                        }
                      },
                      child: Text(tr(context, "Log in")),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthShoe extends StatelessWidget {
  const _AuthShoe();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding),
      child: Center(
        child: Container(
          height: 168,
          width: 168,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(defaultPadding * 1.25),
          child: Image.asset(sneakerImg1, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
