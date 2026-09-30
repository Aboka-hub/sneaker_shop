import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../constants.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    required this.name,
    required this.email,
    required this.imageSrc,
    this.proLableText = "Pro",
    this.isPro = false,
    this.press,
    this.isShowHi = true,
    this.isShowArrow = true,
  });

  final String name, email, imageSrc;
  final String proLableText;
  final bool isPro, isShowHi, isShowArrow;
  final VoidCallback? press;

  ImageProvider? get _avatar {
    if (imageSrc.startsWith("assets/")) return AssetImage(imageSrc);
    if (imageSrc.startsWith("http")) return NetworkImage(imageSrc);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: primaryColor.withOpacity(0.15),
        backgroundImage: _avatar,
        child: imageSrc.isEmpty
            ? const Icon(Icons.person, color: primaryColor, size: 28)
            : null,
      ),
      title: Row(
        children: [
          Text(
            isShowHi ? "Hi, $name" : name,
            style: const TextStyle(fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: defaultPadding / 2),
          if (isPro)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2, vertical: defaultPadding / 4),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius:
                    BorderRadius.all(Radius.circular(defaultBorderRadious)),
              ),
              child: Text(
                proLableText,
                style: const TextStyle(
                  fontFamily: grandisExtendedFont,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  letterSpacing: 0.7,
                  height: 1,
                ),
              ),
            ),
        ],
      ),
      subtitle: Text(email),
      trailing: isShowArrow
          ? SvgPicture.asset(
              "assets/icons/miniRight.svg",
              color: Theme.of(context).iconTheme.color!.withOpacity(0.4),
            )
          : null,
    );
  }
}
