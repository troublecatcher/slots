import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:kbspinningwheel/kbspinningwheel.dart';
import 'package:slots/features/shared/game_controller.dart';
import 'package:slots/features/shared/widgets/button.dart';
import 'package:slots/features/shared/widgets/status_board.dart';
import 'package:slots/main.dart';

import '../../balance/balance_functions.dart';
import '../../balance/balance_widget.dart';
import '../../shared/widgets/back_buttonn.dart';
import '../../shared/widgets/game_title.dart';
import '../../shared/widgets/shake_widget.dart';
import '../../shared/economics.dart';
import '../../shared/game_status.dart';

final _rouletteBalanceShakeKey = GlobalKey<ShakeWidgetState>();

@RoutePage()
class RouletteScreen extends StatefulWidget {
  const RouletteScreen({super.key});

  @override
  State<RouletteScreen> createState() => _RouletteScreenState();
}

class _RouletteScreenState extends State<RouletteScreen> {
  final _dividerController = StreamController<int>();
  final _wheelNotifier = StreamController<double>();
  late RouletteController _gameController;

  @override
  void initState() {
    super.initState();

    _gameController = RouletteController();
  }

  @override
  void dispose() {
    _dividerController.close();
    _wheelNotifier.close();
    _gameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> multiplierWidgets = generateLegenda();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/games/roulette/bg.png'),
                fit: BoxFit.cover)),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Stack(children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: GetBuilder<RouletteController>(
                    init: _gameController,
                    builder: (_) {
                      return BackButtonn(isActive: !_.spinning);
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/games/roulette/frame.png',
                    scale: 0.15.sp,
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: SpinningWheel(
                      image: Image.asset(
                        'assets/games/roulette/roulette1.png',
                        scale: 0.1.sp,
                      ),
                      width: 310,
                      height: 310,
                      initialSpinAngle: _generateRandomAngle(),
                      spinResistance: 0.6,
                      canInteractWhileSpinning: false,
                      dividers: 14,
                      onUpdate: (_) {
                        _dividerController.add(_);
                      },
                      onEnd: (index) async {
                        _dividerController.add(index);
                        _gameController.toggleSpin();
                        await _gameController.setNewGiftIndex(index);
                      },
                      shouldStartOrStop: _wheelNotifier.stream,
                      stopSpin: true,
                    )),
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 220,
                  top: MediaQuery.of(context).size.height / 2 - 10,
                  child: Transform.rotate(
                    angle: -pi / 10,
                    child: SvgPicture.asset(
                      'assets/games/roulette/arrow.svg',
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...multiplierWidgets,
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: StatusBoard(controller: _gameController, widgets: [
                    GetBuilder<RouletteController>(
                      init: _gameController,
                      builder: (_) {
                        if (_gameController.gameStatus ==
                            GameStatus.inProgress) {
                          return Button(
                              child: Text('SPIN!',
                                  style:
                                      Theme.of(context).textTheme.titleMedium));
                        } else {
                          return Button(
                              callback: (p0) {
                                if (!_gameController.spinning) {
                                  if (isBalanceSufficient()) {
                                    updateBalance(gameCost);
                                    _gameController.startGame();
                                    _wheelNotifier.sink
                                        .add(_generateRandomVelocity());
                                    _gameController.toggleSpin();
                                  } else {
                                    _rouletteBalanceShakeKey.currentState!
                                        .shake();
                                  }
                                }
                              },
                              child: Text('SPIN!',
                                  style:
                                      Theme.of(context).textTheme.titleMedium));
                        }
                      },
                    )
                  ]),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: BalanceWidget(shakeKey: _rouletteBalanceShakeKey),
                ),
                const Align(
                  alignment: Alignment.topCenter,
                  child: GameTitle(gameTitle: 'ROULETTE'),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> generateLegenda() {
    List<Widget> multiplierWidgets = [];
    for (var gift in Gifts.values) {
      if (gift.isMultiplier) {
        multiplierWidgets.add(
          FittedBox(
            child: Container(
              width: 100,
              padding: const EdgeInsets.only(right: 10, left: 10),
              margin: const EdgeInsets.only(bottom: 4, top: 4),
              decoration: const BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    gift.imagePath!,
                    height: 25,
                    width: 25,
                  ),
                  Text('X${gift.value}',
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ),
        );
      }
    }
    return multiplierWidgets;
  }

  double _generateRandomAngle() => Random().nextDouble() * pi * 2;
  double _generateRandomVelocity() => (Random().nextDouble() * 6000) + 6000;
}

class RouletteController extends GameController {
  int giftIndex = -1;
  bool spinning = false;
  void toggleSpin() {
    spinning = !spinning;
    update();
  }

  Future<void> setNewGiftIndex(index) async {
    giftIndex = index;

    var a = Gifts.values[giftIndex - 1];
    if (!a.isMultiplier) {
      if (a.value != 0) {
        await endGame(GameStatus.win, a.value);
      } else {
        await endGame(GameStatus.lose, 0);
      }
    } else {
      await endGame(
          GameStatus.win,
          int.parse(
              (a.value * gameCost.abs()).toString().replaceAll('.0', '')));
    }

    update();
  }
}
