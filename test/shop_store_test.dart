import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/models/product_model.dart';
import 'package:sneaker_shop/models/shop_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    final store = ShopStore.instance;
    store.resetForTesting();
    // _seed() fills cart/cards/orders/wishlist with demo data for the UI
    // to show on first launch; tests need an actually empty starting point.
    store.cart.clear();
    store.cards.clear();
    store.addresses.clear();
    store.orders.clear();
    store.wishlist.clear();
    store.notifyList.clear();
  });

  group("Cart", () {
    test("adding the same product/size/color twice merges into one line", () {
      final store = ShopStore.instance;
      final product = demoPopularProducts.first;

      store.addToCart(product, size: "42", colorName: "Чёрный");
      store.addToCart(product, size: "42", colorName: "Чёрный", quantity: 2);

      expect(store.cart.length, 1);
      expect(store.cart.single.quantity, 3);
    });

    test("same product with a different size stays a separate line", () {
      final store = ShopStore.instance;
      final product = demoPopularProducts.first;

      store.addToCart(product, size: "42", colorName: "Чёрный");
      store.addToCart(product, size: "43", colorName: "Чёрный");

      expect(store.cart.length, 2);
    });

    test("cartTotal uses the discounted price when there is one", () {
      final store = ShopStore.instance;
      final product =
          demoPopularProducts.firstWhere((p) => p.priceAfetDiscount != null);

      store.addToCart(product, quantity: 2);

      expect(store.cartTotal, closeTo(product.priceAfetDiscount! * 2, 0.001));
    });

    test("changeQuantity never drops a line below 1", () {
      final store = ShopStore.instance;
      store.addToCart(demoPopularProducts.first);

      store.changeQuantity(0, -5);

      expect(store.cart.single.quantity, 1);
    });

    test("removeFromCart drops the right line", () {
      final store = ShopStore.instance;
      store.addToCart(demoPopularProducts[0]);
      store.addToCart(demoPopularProducts[1]);

      store.removeFromCart(0);

      expect(store.cart.single.product.id, demoPopularProducts[1].id);
    });
  });

  group("Orders", () {
    PaymentCard card() =>
        PaymentCard(holder: "Test", last4: "4242", expiry: "12/30");

    test("placeOrder snapshots the cart and then empties it", () {
      final store = ShopStore.instance;
      store.addToCart(demoPopularProducts.first, quantity: 2);

      final order = store.placeOrder(address: "Abay 10", card: card());

      expect(store.cart, isEmpty);
      expect(order.items.single.quantity, 2);
      expect(store.orders.first.id, order.id);
    });

    test("order ids never collide across consecutive orders", () {
      final store = ShopStore.instance;

      store.addToCart(demoPopularProducts.first);
      final first = store.placeOrder(address: "A", card: card());
      store.addToCart(demoPopularProducts.first);
      final second = store.placeOrder(address: "A", card: card());

      expect(first.id, isNot(equals(second.id)));
    });

    test("requestReturn only changes the order status", () {
      final store = ShopStore.instance;
      store.addToCart(demoPopularProducts.first);
      final order = store.placeOrder(address: "A", card: card());

      store.requestReturn(order);

      expect(order.status, OrderStatus.returnRequested);
      expect(order.items, hasLength(1));
    });
  });

  group("Auth", () {
    test("register rejects an email that is already taken", () {
      final store = ShopStore.instance;

      expect(store.register("Test@Example.com", "Passw0rd!"), isTrue);
      expect(store.register("test@example.com", "Different1!"), isFalse);
    });

    test("login only succeeds with the right password, email is case-insensitive", () {
      final store = ShopStore.instance;
      store.register("user@example.com", "Correct1!");
      store.logout();

      expect(store.login("user@example.com", "wrong"), isFalse);
      expect(store.login("USER@example.com", "Correct1!"), isTrue);
      expect(store.isLoggedIn, isTrue);
    });

    test("logout clears the session but keeps the account registered", () {
      final store = ShopStore.instance;
      store.register("user2@example.com", "Correct1!");

      store.logout();

      expect(store.isLoggedIn, isFalse);
      expect(store.login("user2@example.com", "Correct1!"), isTrue);
    });

    test("changing email in the profile moves the account to the new address", () {
      final store = ShopStore.instance;
      store.register("old@example.com", "Correct1!");

      store.updateProfile(name: "Name", email: "new@example.com", phone: "+1");
      store.logout();

      expect(store.login("old@example.com", "Correct1!"), isFalse);
      expect(store.login("new@example.com", "Correct1!"), isTrue);
    });

    test("changePassword requires the current password to be correct", () {
      final store = ShopStore.instance;
      store.register("pw@example.com", "Correct1!");

      expect(store.changePassword("wrong", "NewPass1!"), isFalse);
      expect(store.changePassword("Correct1!", "NewPass1!"), isTrue);

      store.logout();
      expect(store.login("pw@example.com", "NewPass1!"), isTrue);
    });
  });

  group("Addresses", () {
    test("addAddress assigns a stable, unique id", () {
      final store = ShopStore.instance;

      store.addAddress("Дом", "Абая 10, Алматы");
      store.addAddress("Работа", "Достык 5, Алматы");

      expect(store.addresses.map((a) => a.id).toSet(), hasLength(2));
    });

    test("removeAddress only removes the matching id", () {
      final store = ShopStore.instance;
      store.addAddress("Дом", "Абая 10, Алматы");
      store.addAddress("Работа", "Достык 5, Алматы");
      final toRemove = store.addresses.first.id;

      store.removeAddress(toRemove);

      expect(store.addresses, hasLength(1));
      expect(store.addresses.single.label, "Работа");
    });
  });

  group("Wishlist & notify list", () {
    test("toggleWishlist adds then removes the product by id", () {
      final store = ShopStore.instance;
      final product = demoPopularProducts.first;

      expect(store.isInWishlist(product), isFalse);
      store.toggleWishlist(product);
      expect(store.isInWishlist(product), isTrue);
      store.toggleWishlist(product);
      expect(store.isInWishlist(product), isFalse);
    });

    test("notify list is independent from the wishlist", () {
      final store = ShopStore.instance;
      final product = demoPopularProducts.first;

      store.toggleNotify(product);

      expect(store.isNotifyRequested(product), isTrue);
      expect(store.isInWishlist(product), isFalse);
    });
  });

  group("Persistence", () {
    test("cart and wishlist survive a save/load round trip", () async {
      final store = ShopStore.instance;
      store.addToCart(demoPopularProducts.first,
          size: "41", colorName: "Белый", quantity: 2);
      store.toggleWishlist(demoPopularProducts[1]);

      // addToCart/toggleWishlist persist in the background without awaiting;
      // give that write a turn of the event loop before reading it back.
      await Future<void>.delayed(Duration.zero);
      await store.load();

      expect(store.cart.single.quantity, 2);
      expect(store.cart.single.size, "41");
      expect(store.isInWishlist(demoPopularProducts[1]), isTrue);
    });

    test("a saved address survives a save/load round trip", () async {
      final store = ShopStore.instance;
      store.addAddress("Дом", "Абая 10, Алматы");

      await Future<void>.delayed(Duration.zero);
      await store.load();

      expect(store.addresses.single.label, "Дом");
      expect(store.addresses.single.fullAddress, "Абая 10, Алматы");
    });

    test("a registered account survives a save/load round trip", () async {
      final store = ShopStore.instance;
      store.register("persisted@example.com", "Correct1!");

      await Future<void>.delayed(Duration.zero);
      await store.load();

      expect(store.isLoggedIn, isTrue);
      store.logout();
      expect(store.login("persisted@example.com", "Correct1!"), isTrue);
    });
  });
}
