import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sneaker_shop/components/Banner/M/banner_m_style_1.dart';
import 'package:sneaker_shop/components/Banner/M/banner_m_style_2.dart';
import 'package:sneaker_shop/components/Banner/M/banner_m_style_3.dart';
import 'package:sneaker_shop/components/Banner/M/banner_m_style_4.dart';
import 'package:sneaker_shop/components/dot_indicators.dart';

import '../../../../constants.dart';
import 'package:sneaker_shop/l10n/l10n.dart';
import 'package:sneaker_shop/route/route_constants.dart';

class OffersCarousel extends StatefulWidget {
  const OffersCarousel({
    super.key,
  });

  @override
  State<OffersCarousel> createState() => _OffersCarouselState();
}

class _OffersCarouselState extends State<OffersCarousel> {
  int _selectedIndex = 0;
  late PageController _pageController;
  late Timer _timer;

  List<Widget> _offers(BuildContext context) => [
        BannerMStyle1(
          text: tr(context, "New drops with \nFree shipping"),
          press: () => _open(context, "Air Jordan 4 Retro"),
        ),
        BannerMStyle2(
          title: tr(context, "Jordan \nweek"),
          subtitle: tr(context, "Retro collection"),
          discountParcent: 50,
          press: () => _open(context, "Air Jordan 1 Red & Black"),
        ),
        BannerMStyle3(
          title: tr(context, "Grab \nyour pair"),
          discountParcent: 50,
          press: () => _open(context, "Future Rider Neon Pack"),
        ),
        BannerMStyle4(
          title: tr(context, "RUNNING \nSALE"),
          subtitle: tr(context, "SPECIAL OFFER"),
          discountParcent: 80,
          press: () => _open(context, "Off White Court Sneakers"),
        ),
      ];

  void _open(BuildContext context, String title) {
    Navigator.pushNamed(
      context,
      productDetailsScreenRoute,
      arguments: title,
    );
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_selectedIndex < 3) {
        _selectedIndex++;
      } else {
        _selectedIndex = 0;
      }

      _pageController.animateToPage(
        _selectedIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final offers = _offers(context);
    return AspectRatio(
      aspectRatio: 1.87,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: offers.length,
            onPageChanged: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            itemBuilder: (context, index) => offers[index],
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: SizedBox(
                height: 16,
                child: Row(
                  children: List.generate(
                    offers.length,
                    (index) {
                      return Padding(
                        padding:
                            const EdgeInsets.only(left: defaultPadding / 4),
                        child: DotIndicator(
                          isActive: index == _selectedIndex,
                          activeColor: Colors.white70,
                          inActiveColor: Colors.white54,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
