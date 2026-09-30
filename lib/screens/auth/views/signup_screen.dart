import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sneaker_shop/screens/auth/views/components/sign_up_form.dart';
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
                Text(
                  "Let’s get started!",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: defaultPadding / 2),
                const Text(
                  "Please enter your valid data in order to create an account.",
                ),
                const SizedBox(height: defaultPadding),
                SignUpForm(formKey: _formKey),
                const SizedBox(height: defaultPadding),
                Row(
                  children: [
                    Checkbox(
                      onChanged: (value) {},
                      value: false,
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: "I agree with the",
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {},
                              text: " Terms of service ",
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const TextSpan(
                              text: "& privacy policy.",
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: defaultPadding * 2),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, entryPointScreenRoute);
                  },
                  child: Text(tr(context, "Continue")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(tr(context, "Do you have an account?")),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, logInScreenRoute);
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
