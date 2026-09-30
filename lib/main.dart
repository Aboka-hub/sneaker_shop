import 'package:flutter/material.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/shop_store.dart';
import 'package:sneaker_shop/route/route_constants.dart';
import 'package:sneaker_shop/route/router.dart' as router;
import 'package:sneaker_shop/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ShopStore.instance.load();
  await L10n.instance.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: L10n.instance,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sneaker Hub',
          theme: AppTheme.lightTheme(context),
          themeMode: ThemeMode.light,
          builder: (context, child) => LocaleScope(
            notifier: L10n.instance,
            child: child ?? const SizedBox.shrink(),
          ),
          onGenerateRoute: router.generateRoute,
          initialRoute: onbordingScreenRoute,
        );
      },
    );
  }
}
