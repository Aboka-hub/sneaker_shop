import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sneaker_shop/constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/models/shop_store.dart';
import 'package:sneaker_shop/route/screen_export.dart';

import 'components/profile_card.dart';
import 'components/profile_menu_item_list_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListenableBuilder(
            listenable: ShopStore.instance,
            builder: (context, _) {
              final store = ShopStore.instance;
              return ProfileCard(
                name: store.userName,
                email: store.userEmail,
                imageSrc: store.avatarAsset,
                press: () {
                  Navigator.pushNamed(context, userInfoScreenRoute);
                },
              );
            },
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            child: Text(
              tr(context, "Account"),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ProfileMenuListTile(
            text: tr(context, "Orders"),
            svgSrc: "assets/icons/Order.svg",
            press: () {
              Navigator.pushNamed(context, ordersScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: tr(context, "My Cart"),
            svgSrc: "assets/icons/Bag.svg",
            press: () {
              Navigator.pushNamed(context, cartScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: tr(context, "Payment cards"),
            svgSrc: "assets/icons/card.svg",
            press: () {
              Navigator.pushNamed(context, cardsScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: tr(context, "Wishlist"),
            svgSrc: "assets/icons/Wishlist.svg",
            press: () {
              Navigator.pushNamed(context, bookmarkScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: tr(context, "Returns"),
            svgSrc: "assets/icons/Return.svg",
            press: () {
              Navigator.pushNamed(context, returnsScreenRoute);
            },
          ),
          const SizedBox(height: defaultPadding),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: Text(
              tr(context, "Shop"),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ProfileMenuListTile(
            text: tr(context, "Browse sneakers"),
            svgSrc: "assets/icons/Category.svg",
            press: () {
              Navigator.pushNamed(context, discoverScreenRoute);
            },
          ),
          ProfileMenuListTile(
            text: tr(context, "Search"),
            svgSrc: "assets/icons/Search.svg",
            press: () {
              Navigator.pushNamed(context, searchScreenRoute);
            },
            isShowDivider: false,
          ),
          const SizedBox(height: defaultPadding),

          ListTile(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                logInScreenRoute,
                (route) => false,
              );
            },
            minLeadingWidth: 24,
            leading: SvgPicture.asset(
              "assets/icons/Logout.svg",
              height: 24,
              width: 24,
              colorFilter: const ColorFilter.mode(
                errorColor,
                BlendMode.srcIn,
              ),
            ),
            title: Text(
              tr(context, "Log Out"),
              style: TextStyle(color: errorColor, fontSize: 14, height: 1),
            ),
          )
        ],
      ),
    );
  }
}
