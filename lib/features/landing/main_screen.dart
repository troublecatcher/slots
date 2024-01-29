import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:slots/features/landing/game_widget.dart';
import 'package:slots/router/router.dart';
import 'package:slots/theme.dart';

import 'gift_button.dart';
import 'settings_button.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SettingsButton(),
                          GiftButton(),
                          // ElevatedButton(
                          //     onPressed: () => context.router.push(const SlotRoute()),
                          //     child: Text('123'))
                        ],
                      ),
                      Text('CHOOSE A GAME',
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GameWidget(
                        gameName: 'SLOT MACHINE',
                        gameImagePath: 'assets/games/slot/preview.png',
                        callback: (p0) =>
                            context.router.push(const SlotRoute()),
                      ),
                      GameWidget(
                        gameName: 'POKIES',
                        gameImagePath: 'assets/games/pokies/preview.png',
                        callback: (p0) =>
                            context.router.push(const PokiesRoute()),
                      ),
                      GameWidget(
                        gameName: 'ROULETTE',
                        gameImagePath: 'assets/games/roulette/frame.png',
                        callback: (p0) =>
                            context.router.push(const RouletteRoute()),
                      ),
                    ],
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
