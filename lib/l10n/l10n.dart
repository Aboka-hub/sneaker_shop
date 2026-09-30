import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class L10n extends ChangeNotifier {
  L10n._();

  static final L10n instance = L10n._();

  String code = "ru";

  static L10n of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<LocaleScope>();
    return scope?.notifier ?? instance;
  }

  String t(String key) => code == "en" ? key : (_ru[key] ?? key);

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      code = prefs.getString("app_lang") ?? "ru";
      notifyListeners();
    } catch (_) {}
  }

  Future<void> toggle() async {
    code = code == "ru" ? "en" : "ru";
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("app_lang", code);
    } catch (_) {}
  }
}

class LocaleScope extends InheritedNotifier<L10n> {
  const LocaleScope({
    required L10n super.notifier,
    required super.child,
  });
}

String tr(BuildContext context, String key) => L10n.of(context).t(key);

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    final code = L10n.of(context).code;
    return TextButton(
      onPressed: L10n.instance.toggle,
      child: Text(
        code == "ru" ? "EN" : "RU",
        style: const TextStyle(fontWeight: FontWeight.w800),
      ),
    );
  }
}

const _ru = {
  "Shop": "Магазин",
  "Discover": "Каталог",
  "Bookmark": "Избранное",
  "Cart": "Корзина",
  "Profile": "Профиль",
  "Categories": "Категории",
  "All Sneakers": "Все кроссовки",
  "On Sale": "Скидки",
  "Discounted pairs": "Пары со скидкой",
  "Under \$100": "До \$100",
  "New this week": "Новинки недели",
  "Men's": "Мужские",
  "Women’s": "Женские",
  "Kids": "Детские",
  "Popular sneakers": "Популярные кроссовки",
  "Flash sale": "Быстрая распродажа",
  "Best sellers": "Хиты продаж",
  "Most popular": "Самые популярные",
  "Sneaker categories": "Категории кроссовок",
  "Sneakers": "Кроссовки",
  "All sneakers": "Все кроссовки",
  "New arrivals": "Новинки",
  "Lifestyle": "На каждый день",
  "Retro": "Ретро",
  "High tops": "Высокие",
  "Sport": "Спорт",
  "Running": "Бег",
  "Basketball": "Баскетбол",
  "Football boots": "Футбол",
  "Boys": "Мальчики",
  "Girls": "Девочки",
  "First steps": "Первые шаги",
  "Search sneakers": "Поиск кроссовок",
  "Nike, Puma, running…": "Nike, Puma, бег…",
  "All brands": "Все бренды",
  "All sizes": "Все размеры",
  "Nothing found": "Ничего не найдено",
  "No products in category": "В категории «{name}» пока нет кроссовок",
  "Wishlist": "Избранное",
  "Tap the heart on a sneaker": "Нажмите сердечко на кроссовке",
  "Your cart is empty": "Корзина пуста",
  "Checkout": "Оформить",
  "Total price": "Итого",
  "Place order": "Оформить заказ",
  "Total": "Итого",
  "Delivery": "Доставка",
  "Full name": "Имя",
  "Phone": "Телефон",
  "Address": "Адрес",
  "Payment card": "Карта",
  "Manage": "Изменить",
  "No cards yet": "Карт пока нет",
  "Add a payment card first": "Сначала добавьте карту",
  "Order placed": "Заказ оформлен",
  "Required": "Заполните поле",
  "Enter a valid card": "Введите корректный номер карты",
  "Payment cards": "Карты оплаты",
  "No saved cards": "Сохранённых карт нет",
  "Add a card": "Новая карта",
  "Name on card": "Имя на карте",
  "Card number": "Номер карты",
  "Expiry MM/YY": "Срок ММ/ГГ",
  "Save card": "Сохранить карту",
  "Orders": "Заказы",
  "No orders yet": "Заказов пока нет",
  "Card": "Карта",
  "Order": "Заказ",
  "Order not found": "Заказ не найден",
  "Date": "Дата",
  "Items": "Состав",
  "Payment": "Оплата",
  "Returns": "Возвраты",
  "Delivered orders will appear here": "Здесь появятся доставленные заказы",
  "Return requested": "Возврат запрошен",
  "Request return": "Запросить возврат",
  "Processing": "В обработке",
  "Delivered": "Доставлен",
  "Returned": "Возвращён",
  "Account": "Аккаунт",
  "My Cart": "Корзина",
  "Browse sneakers": "Смотреть кроссовки",
  "Search": "Поиск",
  "Log Out": "Выйти",
  "Settings": "Настройки",
  "Language": "Язык",
  "Change password": "Сменить пароль",
  "Current password": "Текущий пароль",
  "New password": "Новый пароль",
  "Confirm new password": "Повторите новый пароль",
  "Passwords don't match": "Пароли не совпадают",
  "Current password is incorrect": "Текущий пароль указан неверно",
  "Password changed": "Пароль изменён",
  "My profile": "Мой профиль",
  "Personal details": "Личные данные",
  "Email": "Почта",
  "Save": "Сохранить",
  "Profile updated": "Профиль сохранён",
  "Add to cart": "В корзину",
  "Size": "Размер",
  "Color": "Цвет",
  "Notify when product back to stock.": "Сообщить, когда товар появится.",
  "Product Details": "О товаре",
  "Shipping Information": "Доставка",
  "You may also like": "Похожие кроссовки",
  "Size guide": "Таблица размеров",
  "Check stores": "Магазины рядом",
  "Continue shopping": "Продолжить покупки",
  "Find something...": "Найти кроссовки...",
  "Brands": "Бренды",
  "Welcome back!": "С возвращением!",
  "Log in with your data that you intered during your registration.":
      "Войди с почтой и паролем, которые указал при регистрации.",
  "Let's get started!": "Начнём!",
  "Please enter your valid data in order to create an account.":
      "Укажи почту и пароль, чтобы создать аккаунт.",
  "I agree with the": "Я согласен с",
  " Terms of service ": " условиями использования ",
  "& privacy policy.": "и политикой конфиденциальности.",
  "Password recovery is not connected yet":
      "Восстановление пароля пока не подключено",
  "Store pickup search is not connected yet":
      "Поиск магазинов пока не подключен",
  "Email is required": "Укажи почту",
  "Enter a valid email address": "Введи корректную почту",
  "Password is required": "Укажи пароль",
  "Password must be at least 8 characters":
      "Пароль должен быть не короче 8 символов",
  "Password needs a special character":
      "В пароле нужен хотя бы один спецсимвол",
  "Invalid email or password": "Неверная почта или пароль",
  "An account with this email already exists":
      "Аккаунт с такой почтой уже существует",
  "Please agree to the terms to continue":
      "Нужно принять условия использования",
  "Shop now": "Смотреть",
  "Forgot password": "Забыли пароль",
  "Log in": "Войти",
  "Don't have an account?": "Нет аккаунта?",
  "Sign up": "Регистрация",
  "Continue": "Продолжить",
  "Do you have an account?": "Уже есть аккаунт?",
  "Email address": "Почта",
  "Password": "Пароль",
  "Skip": "Пропустить",
  "Find the sneakers \nyou’ve been hunting":
      "Найди кроссовки,\nкоторые искал",
  "Nike, Puma, Off White and more — the whole drop in one place, sorted by model and size.":
      "Nike, Puma, Off White и другие — вся коллекция в одном месте, по модели и размеру.",
  "Pick your size \nand your pair": "Выбери размер\nи свою пару",
  "Add sneakers to the cart or save them to your wishlist so you don’t miss a restock.":
      "Добавь кроссовки в корзину или в избранное, чтобы не пропустить новую поставку.",
  "Fast & secure \npayment": "Быстрая и безопасная\nоплата",
  "There are many payment options available for your ease.":
      "Несколько способов оплаты, чтобы оформить заказ было проще.",
  "Package tracking": "Отслеживание заказа",
  "Sneaker Hub packs your order and lets you follow the delivery step by step.":
      "Sneaker Hub собирает заказ, и ты видишь доставку шаг за шагом.",
  "Nearby stores": "Магазины рядом",
  "Check which store nearby has your size in stock and pick the pair up the same day.":
      "Проверь, где рядом есть твой размер, и забери пару в тот же день.",
  "New \nsneakers": "Новые\nкроссовки",
  "SPECIAL OFFER": "СПЕЦПРЕДЛОЖЕНИЕ",
  "Running \nweek": "Неделя\nбега",
  "50% Off": "Скидка 50%",
  "SNEAKERS": "КРОССОВКИ",
  "New drops with \nFree shipping": "Новинки с\nбесплатной доставкой",
  "Jordan \nweek": "Неделя\nJordan",
  "Retro collection": "Ретро-коллекция",
  "Grab \nyour pair": "Забери\nсвою пару",
  "RUNNING \nSALE": "СКИДКА\nНА БЕГ",
  "Super Flash Sale \n50% Off": "Большая распродажа\nскидка 50%",
  "{title} by {brand}. Pick a size and a color, then add the pair to your cart.":
      "{title} от {brand}. Выбери размер и цвет и добавь пару в корзину.",
  "Leather or textile upper, rubber sole, lace-up fit.":
      "Верх из кожи или текстиля, резиновая подошва, шнуровка.",
  "City delivery takes 1–2 days, nationwide 3–7 days. Free shipping from \$150.":
      "По городу 1–2 дня, по стране 3–7 дней. Бесплатно от \$150.",
  "EU {size}": "EU {size}",
  "Featured": "Как в каталоге",
  "Cheaper": "Дешевле",
  "More expensive": "Дороже",
  "On sale": "Со скидкой",
  "Promo code": "Промокод",
  "Apply": "Применить",
  "Promo applied": "Промокод применён",
  "Invalid promo code": "Такого промокода нет",
  "Subtotal": "Товары",
  "Shipping": "Доставка",
  "Free": "Бесплатно",
  "Discount": "Скидка",
  "Choose photo": "Выбрать фото",
};
