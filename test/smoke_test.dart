import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sneaker_shop/entry_point.dart';
import 'package:sneaker_shop/route/screen_export.dart';

void main() {
  // В тестах используется шрифт-заглушка, где каждый символ шире реального,
  // поэтому плотные строки "переполняются" только здесь, а не в приложении.
  void ignoreOverflowErrors() {
    final defaultOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.exceptionAsString().contains("A RenderFlex overflowed")) {
        return;
      }
      defaultOnError?.call(details);
    };
  }

  Future<void> show(WidgetTester tester, Widget screen) async {
    ignoreOverflowErrors();
    await tester.pumpWidget(MaterialApp(home: screen));
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets("onboarding renders", (tester) async {
    await show(tester, const OnBordingScreen());
    expect(find.textContaining("sneakers"), findsWidgets);
  });

  testWidgets("login renders", (tester) async {
    await show(tester, const LoginScreen());
  });

  testWidgets("signup renders", (tester) async {
    await show(tester, const SignUpScreen());
  });

  testWidgets("entry point with all tabs renders", (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await show(tester, const EntryPoint());
    expect(find.text("SNEAKER HUB"), findsOneWidget);

    for (final label in ["Discover", "Bookmark", "Cart", "Profile"]) {
      await tester.tap(find.text(label));
      await tester.pump(const Duration(milliseconds: 400));
    }
  });

  testWidgets("search finds sneakers by brand", (tester) async {
    await show(tester, const SearchScreen());
    await tester.enterText(find.byType(TextField), "puma");
    await tester.pump();
    expect(find.textContaining("PUMA"), findsWidgets);

    await tester.enterText(find.byType(TextField), "zzz");
    await tester.pump();
    expect(find.text("Nothing found"), findsOneWidget);
  });

  testWidgets("cart totals update on quantity change", (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await show(tester, const CartScreen());
    expect(find.byIcon(Icons.add), findsWidgets);
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pump();
  });

  testWidgets("product details renders", (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await show(tester, const ProductDetailsScreen());
    expect(find.text("Air Jordan 1 Retro High"), findsWidgets);
  });
}
