import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:slots/features/shared/widgets/back_buttonn.dart';
import 'package:slots/main.dart';
import 'package:slots/router/router.dart';

@RoutePage()
class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/landing/bg.png'), fit: BoxFit.cover)),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: BackButtonn(isActive: true),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text('TERMS OF USE',
                      style: Theme.of(context).textTheme.titleLarge),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
