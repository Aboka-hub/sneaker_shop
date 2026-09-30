import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/models/product_model.dart';

String _normalizeEmail(String email) => email.trim().toLowerCase();

String _hashPassword(String password) =>
    sha256.convert(utf8.encode(password)).toString();

class ShoeColor {
  const ShoeColor(this.name, this.color);

  final String name;
  final Color color;
}

const shoeSizes = ["39", "40", "41", "42", "43", "44"];

const shoeColors = [
  ShoeColor("Чёрный", Color(0xFF222222)),
  ShoeColor("Белый", Color(0xFFF4F4F4)),
  ShoeColor("Красный", Color(0xFFEA6262)),
  ShoeColor("Зелёный", Color(0xFFB1CC63)),
  ShoeColor("Жёлтый", Color(0xFFFFBF5F)),
];

class CartLine {
  CartLine({
    required this.product,
    this.quantity = 1,
    this.size = "42",
    this.colorName = "Чёрный",
  });

  final ProductModel product;
  int quantity;
  final String size;
  final String colorName;

  double get unitPrice => product.priceAfetDiscount ?? product.price;
  double get lineTotal => unitPrice * quantity;

  bool sameVariant(ProductModel product, String size, String colorName) =>
      this.product.id == product.id &&
      this.size == size &&
      this.colorName == colorName;
}

class PaymentCard {
  PaymentCard({
    required this.holder,
    required this.last4,
    required this.expiry,
  });

  final String holder;
  final String last4;
  final String expiry;
}

enum OrderStatus { processing, delivered, returnRequested, returned }

class OrderItem {
  OrderItem({
    required this.product,
    required this.quantity,
    required this.price,
    this.size = "42",
    this.colorName = "Чёрный",
  });

  final ProductModel product;
  final int quantity;
  final double price;
  final String size;
  final String colorName;
}

class ShopOrder {
  ShopOrder({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.total,
    required this.address,
    required this.cardLast4,
    this.status = OrderStatus.processing,
  });

  final String id;
  final DateTime createdAt;
  final List<OrderItem> items;
  final double total;
  final String address;
  final String cardLast4;
  OrderStatus status;
}

class ShopStore extends ChangeNotifier {
  ShopStore._() {
    _seed();
  }

  static final ShopStore instance = ShopStore._();
  static const _prefsKey = "shop_store_v1";

  final List<CartLine> cart = [];
  final List<PaymentCard> cards = [];
  final List<ShopOrder> orders = [];
  final List<String> wishlist = [];
  final List<String> notifyList = [];
  final Map<String, String> _accounts = {};
  int _orderSeq = 1002;
  String userName = "Alex Runner";
  String userEmail = "alex@sneakerhub.com";
  String userPhone = "+7 700 000 00 00";
  String avatarAsset = profileAvatar;
  String? currentUserEmail;

  bool get isLoggedIn => currentUserEmail != null;

  void _seed() {
    cart
      ..clear()
      ..addAll([
        CartLine(product: demoPopularProducts[0], size: "42", colorName: "Чёрный"),
        CartLine(product: demoPopularProducts[1], size: "41", colorName: "Белый"),
        CartLine(
          product: demoPopularProducts[2],
          quantity: 2,
          size: "43",
          colorName: "Красный",
        ),
      ]);
    cards
      ..clear()
      ..add(PaymentCard(holder: "Alex Runner", last4: "4242", expiry: "12/28"));
    orders
      ..clear()
      ..add(
        ShopOrder(
          id: "SH-1001",
          createdAt: DateTime.now().subtract(const Duration(days: 6)),
          items: [
            OrderItem(
              product: demoPopularProducts[0],
              quantity: 1,
              price: demoPopularProducts[0].priceAfetDiscount ??
                  demoPopularProducts[0].price,
              size: "42",
              colorName: "Чёрный",
            ),
          ],
          total: demoPopularProducts[0].priceAfetDiscount ??
              demoPopularProducts[0].price,
          address: "Alex Runner, +7 700 000 00 00, Абая 10, Алматы",
          cardLast4: "4242",
          status: OrderStatus.delivered,
        ),
      );
    wishlist
      ..clear()
      ..add(demoPopularProducts[0].id);
    notifyList.clear();
    _accounts.clear();
    currentUserEmail = null;
    _orderSeq = 1002;
    userName = "Alex Runner";
    userEmail = "alex@sneakerhub.com";
    userPhone = "+7 700 000 00 00";
    avatarAsset = profileAvatar;
  }

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null) {
        await _persist();
        return;
      }
      final data = jsonDecode(raw) as Map<String, dynamic>;
      userName = data["userName"] as String? ?? userName;
      userEmail = data["userEmail"] as String? ?? userEmail;
      userPhone = data["userPhone"] as String? ?? userPhone;
      final savedAvatar = data["avatarAsset"] as String?;
      if (savedAvatar != null && profileAvatars.contains(savedAvatar)) {
        avatarAsset = savedAvatar;
      }
      _orderSeq = data["orderSeq"] as int? ?? _orderSeq;
      currentUserEmail = data["currentUserEmail"] as String?;
      _accounts
        ..clear()
        ..addAll({
          for (final entry in ((data["accounts"] as Map?) ?? const {}).entries)
            entry.key as String: entry.value as String,
        });

      cart
        ..clear()
        ..addAll(_readCart(data["cart"]));
      cards
        ..clear()
        ..addAll(_readCards(data["cards"]));
      orders
        ..clear()
        ..addAll(_readOrders(data["orders"]));
      wishlist
        ..clear()
        ..addAll([
          for (final id in (data["wishlist"] as List?) ?? const [])
            if (productById(id as String) != null) id,
        ]);
      notifyList
        ..clear()
        ..addAll([
          for (final id in (data["notifyList"] as List?) ?? const [])
            if (productById(id as String) != null) id,
        ]);
      notifyListeners();
    } catch (_) {}
  }

  List<CartLine> _readCart(Object? raw) {
    final lines = <CartLine>[];
    for (final item in (raw as List?) ?? const []) {
      final map = item as Map<String, dynamic>;
      final product = productById(map["id"] as String? ?? "");
      if (product == null) continue;
      lines.add(CartLine(
        product: product,
        quantity: map["quantity"] as int? ?? 1,
        size: map["size"] as String? ?? "42",
        colorName: map["color"] as String? ?? "Чёрный",
      ));
    }
    return lines;
  }

  List<PaymentCard> _readCards(Object? raw) {
    return [
      for (final item in (raw as List?) ?? const [])
        PaymentCard(
          holder: (item as Map)["holder"] as String? ?? "",
          last4: item["last4"] as String? ?? "",
          expiry: item["expiry"] as String? ?? "",
        ),
    ];
  }

  List<ShopOrder> _readOrders(Object? raw) {
    final result = <ShopOrder>[];
    for (final item in (raw as List?) ?? const []) {
      final map = item as Map<String, dynamic>;
      final items = <OrderItem>[];
      for (final line in (map["items"] as List?) ?? const []) {
        final row = line as Map<String, dynamic>;
        final product = productById(row["id"] as String? ?? "");
        if (product == null) continue;
        items.add(OrderItem(
          product: product,
          quantity: row["quantity"] as int? ?? 1,
          price: (row["price"] as num?)?.toDouble() ?? 0,
          size: row["size"] as String? ?? "42",
          colorName: row["color"] as String? ?? "Чёрный",
        ));
      }
      if (items.isEmpty) continue;
      result.add(ShopOrder(
        id: map["id"] as String? ?? "",
        createdAt: DateTime.tryParse(map["createdAt"] as String? ?? "") ??
            DateTime.now(),
        items: items,
        total: (map["total"] as num?)?.toDouble() ?? 0,
        address: map["address"] as String? ?? "",
        cardLast4: map["cardLast4"] as String? ?? "",
        status: OrderStatus.values.firstWhere(
          (status) => status.name == map["status"],
          orElse: () => OrderStatus.processing,
        ),
      ));
    }
    return result;
  }

  Map<String, dynamic> _toJson() => {
        "userName": userName,
        "userEmail": userEmail,
        "userPhone": userPhone,
        "avatarAsset": avatarAsset,
        "orderSeq": _orderSeq,
        "currentUserEmail": currentUserEmail,
        "accounts": _accounts,
        "wishlist": wishlist,
        "notifyList": notifyList,
        "cart": [
          for (final line in cart)
            {
              "id": line.product.id,
              "quantity": line.quantity,
              "size": line.size,
              "color": line.colorName,
            },
        ],
        "cards": [
          for (final card in cards)
            {
              "holder": card.holder,
              "last4": card.last4,
              "expiry": card.expiry,
            },
        ],
        "orders": [
          for (final order in orders)
            {
              "id": order.id,
              "createdAt": order.createdAt.toIso8601String(),
              "total": order.total,
              "address": order.address,
              "cardLast4": order.cardLast4,
              "status": order.status.name,
              "items": [
                for (final item in order.items)
                  {
                    "id": item.product.id,
                    "quantity": item.quantity,
                    "price": item.price,
                    "size": item.size,
                    "color": item.colorName,
                  },
              ],
            },
        ],
      };

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(_toJson()));
    } catch (_) {}
  }

  void _changed() {
    notifyListeners();
    _persist();
  }

  bool accountExists(String email) =>
      _accounts.containsKey(_normalizeEmail(email));

  bool register(String email, String password) {
    final normalized = _normalizeEmail(email);
    if (_accounts.containsKey(normalized)) return false;
    _accounts[normalized] = _hashPassword(password);
    currentUserEmail = normalized;
    userEmail = normalized;
    final localPart = normalized.split("@").first;
    if (localPart.isNotEmpty) {
      userName = localPart[0].toUpperCase() + localPart.substring(1);
    }
    _changed();
    return true;
  }

  bool login(String email, String password) {
    final normalized = _normalizeEmail(email);
    final storedHash = _accounts[normalized];
    if (storedHash == null || storedHash != _hashPassword(password)) {
      return false;
    }
    currentUserEmail = normalized;
    userEmail = normalized;
    _changed();
    return true;
  }

  void logout() {
    currentUserEmail = null;
    _changed();
  }

  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    userName = name;
    userEmail = email;
    userPhone = phone;
    _changed();
  }

  void updateAvatar(String asset) {
    if (!profileAvatars.contains(asset)) return;
    avatarAsset = asset;
    _changed();
  }

  int get cartCount => cart.fold(0, (sum, line) => sum + line.quantity);

  double get cartTotal => cart.fold(0, (sum, line) => sum + line.lineTotal);

  bool isInWishlist(ProductModel product) => wishlist.contains(product.id);

  void toggleWishlist(ProductModel product) {
    if (isInWishlist(product)) {
      wishlist.remove(product.id);
    } else {
      wishlist.add(product.id);
    }
    _changed();
  }

  bool isNotifyRequested(ProductModel product) =>
      notifyList.contains(product.id);

  void toggleNotify(ProductModel product) {
    if (isNotifyRequested(product)) {
      notifyList.remove(product.id);
    } else {
      notifyList.add(product.id);
    }
    _changed();
  }

  void changeQuantity(int index, int delta) {
    final next = cart[index].quantity + delta;
    if (next < 1) return;
    cart[index].quantity = next;
    _changed();
  }

  void removeFromCart(int index) {
    cart.removeAt(index);
    _changed();
  }

  void addToCart(
    ProductModel product, {
    String size = "42",
    String colorName = "Чёрный",
    int quantity = 1,
  }) {
    final index =
        cart.indexWhere((line) => line.sameVariant(product, size, colorName));
    if (index >= 0) {
      cart[index].quantity += quantity;
    } else {
      cart.add(CartLine(
        product: product,
        quantity: quantity,
        size: size,
        colorName: colorName,
      ));
    }
    _changed();
  }

  void addCard(PaymentCard card) {
    cards.add(card);
    _changed();
  }

  ShopOrder placeOrder({
    required String address,
    required PaymentCard card,
    double? chargedTotal,
  }) {
    final order = ShopOrder(
      id: "SH-$_orderSeq",
      createdAt: DateTime.now(),
      items: [
        for (final line in cart)
          OrderItem(
            product: line.product,
            quantity: line.quantity,
            price: line.unitPrice,
            size: line.size,
            colorName: line.colorName,
          ),
      ],
      total: chargedTotal ?? cartTotal,
      address: address,
      cardLast4: card.last4,
    );
    _orderSeq++;
    orders.insert(0, order);
    cart.clear();
    _changed();
    return order;
  }

  ShopOrder? orderById(String id) {
    for (final order in orders) {
      if (order.id == id) return order;
    }
    return null;
  }

  void requestReturn(ShopOrder order) {
    order.status = OrderStatus.returnRequested;
    _changed();
  }

  List<ShopOrder> get returnableOrders => orders
      .where((order) =>
          order.status == OrderStatus.delivered ||
          order.status == OrderStatus.returnRequested ||
          order.status == OrderStatus.returned)
      .toList();
}

String orderStatusLabel(OrderStatus status) {
  switch (status) {
    case OrderStatus.processing:
      return "Processing";
    case OrderStatus.delivered:
      return "Delivered";
    case OrderStatus.returnRequested:
      return "Return requested";
    case OrderStatus.returned:
      return "Returned";
  }
}
