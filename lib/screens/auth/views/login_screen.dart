import 'package:flutter/material.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/route/route_constants.dart';

import 'components/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

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
                  tr(context, "Welcome back!"),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: defaultPadding / 2),
                Text(
                  tr(
                    context,
                    "Log in with your data that you intered during your registration.",
                  ),
                ),
                const SizedBox(height: defaultPadding),
                LogInForm(formKey: _formKey),
                Align(
                  child: TextButton(
                    child: Text(tr(context, "Forgot password")),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            tr(context, "Password recovery is not connected yet"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: size.height > 700
                      ? size.height * 0.1
                      : defaultPadding,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        entryPointScreenRoute,
                        (route) => false,
                      );
                    }
                  },
                  child: Text(tr(context, "Log in")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tr(context, "Don't have an account?")),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, signUpScreenRoute);
                      },
                      child: Text(tr(context, "Sign up")),
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
