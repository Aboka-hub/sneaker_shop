import 'package:flutter/material.dart';
import 'package:sneaker_shop/entry_point.dart';

import 'screen_export.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case onbordingScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OnBordingScreen(),
      );
    case logInScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case signUpScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
    case entryPointScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const EntryPoint(),
      );
    case homeScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
    case discoverScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const DiscoverScreen(),
      );
    case searchScreenRoute:
      return MaterialPageRoute(
        builder: (context) => SearchScreen(
          category: settings.arguments as String?,
        ),
      );
    case bookmarkScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const BookmarkScreen(),
      );
    case cartScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const CartScreen(),
      );
    case checkoutScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const CheckoutScreen(),
      );
    case cardsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const CardsScreen(),
      );
    case ordersScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const OrdersScreen(),
      );
    case orderDetailsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(
          orderId: settings.arguments as String? ?? "",
        ),
      );
    case returnsScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ReturnsScreen(),
      );
    case profileScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      );
    case userInfoScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const UserInfoScreen(),
      );
    case productDetailsScreenRoute:
      return MaterialPageRoute(
        builder: (context) {
          bool isProductAvailable = settings.arguments as bool? ?? true;
          return ProductDetailsScreen(isProductAvailable: isProductAvailable);
        },
      );
    default:
      return MaterialPageRoute(
        builder: (context) => const OnBordingScreen(),
      );
  }
}
