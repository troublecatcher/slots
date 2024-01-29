import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:slots/features/shared/widgets/back_buttonn.dart';
import 'package:slots/main.dart';
import 'package:slots/router/router.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BackButtonn(isActive: true),
                      Text('SETTINGS',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      border: Border.all(width: 4, color: secondaryColor),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () =>
                              context.router.push(const TermsOfUseRoute()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('TERMS OF USE',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () =>
                              context.router.push(const PrivacyPolicyRoute()),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('PRIVACY POLICY',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
