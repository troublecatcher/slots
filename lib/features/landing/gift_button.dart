import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:slots/router/router.dart';

class GiftButton extends StatelessWidget {
  const GiftButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.router.push(const GiftRoute()),
      child: SvgPicture.asset('assets/landing/gift.svg'),
    );
  }
}
