import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:slots/features/shared/economics.dart';
import 'package:slots/features/shared/game_controller.dart';
import 'package:slots/features/shared/widgets/back_buttonn.dart';
import 'package:slots/features/shared/widgets/button.dart';
import 'package:slots/features/shared/widgets/shake_widget.dart';
import 'package:slots/features/shared/widgets/status_board.dart';

import '../../balance/balance_functions.dart';
import '../../balance/balance_widget.dart';
import '../../shared/game_status.dart';
import '../../shared/widgets/game_title.dart';
import 'pokies_machine.dart';

var ableToRestart = false;
final _pokiesMachineShakeKey = GlobalKey<ShakeWidgetState>();
final _pokiesBalanceShakeKey = GlobalKey<ShakeWidgetState>();
bool showMachine = false;

@RoutePage()
class PokiesScreen extends StatefulWidget {
  const PokiesScreen({super.key});

  @override
  State<PokiesScreen> createState() => _PokiesScreenState();
}

class _PokiesScreenState extends State<PokiesScreen> {
  late SlotMachineController _pokiesController;
  late PokiesController _gameController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    _gameController = PokiesController();
    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 800));
    super.initState();
  }

  @override
  void dispose() {
    _gameController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void onButtonTap() {
    _gameController.increment(_pokiesController);
  }

  void onStart() {
    ableToRestart = false;
    final index = Random().nextInt(100);
    _pokiesController.start(hitRollItemIndex: index < 10 ? index : null);
  }

  Future<void> precacheImages() async {
    for (int index = 0; index < 10; index++) {
      final image = Image.asset('assets/items/$index.png');
      await precacheImage(image.image, context);
    }
    setState(() {
      showMachine = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    precacheImages();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/games/pokies/bg.png'),
                fit: BoxFit.fill)),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: BackButtonn(
                        isActive: _gameController.stopIndex < 4 ? false : true),
                  ),
                  Image.asset(
                    'assets/games/pokies/pokies.png',
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 1.5,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: ShakeWidget(
                      key: _pokiesMachineShakeKey,
                      shakeCount: 3,
                      shakeOffset: 10,
                      shakeDuration: const Duration(milliseconds: 400),
                      child: !showMachine
                          ? const CupertinoActivityIndicator()
                          : PokiesMachine(
                              reelWidth: MediaQuery.of(context).size.width / 16,
                              reelHeight:
                                  MediaQuery.of(context).size.height / 4,
                              rollItems: List.generate(10, (index) {
                                return RollItem(
                                  index: index,
                                  child: Image.asset('assets/items/$index.png'),
                                );
                              }),
                              onCreated: (controller) {
                                _pokiesController = controller;
                              },
                              onFinished: (resultIndexes) async {
                                if (resultIndexes[0] == resultIndexes[1] &&
                                    resultIndexes[1] == resultIndexes[2] &&
                                    resultIndexes[2] == resultIndexes[3]) {
                                  _confettiController.play();
                                  await _gameController.endGame(
                                      GameStatus.win, winReward);
                                } else {
                                  await _gameController.endGame(
                                      GameStatus.lose, gameCost);
                                  _pokiesMachineShakeKey.currentState?.shake();
                                }
                              },
                            ),
                    ),
                  ),
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirection: pi / 2,
                    numberOfParticles: 20,
                    emissionFrequency: 0.5,
                    blastDirectionality: BlastDirectionality.explosive,
                    gravity: 0.3,
                    colors: const [
                      Colors.green,
                      Colors.greenAccent,
                      Colors.lightGreen,
                      Colors.lightGreenAccent
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: StatusBoard(controller: _gameController, widgets: [
                      GetBuilder<PokiesController>(
                        init: _gameController,
                        builder: (_) {
                          if (_.stopIndex < 4) {
                            return Button(
                              callback: (p0) => onButtonTap(),
                              child: Text('STOP',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            );
                          } else {
                            return Button(
                              callback: (p0) {
                                _gameController.startGame();
                                if (isBalanceSufficient()) {
                                  onStart();
                                  _gameController.restart();
                                } else {
                                  _pokiesBalanceShakeKey.currentState!.shake();
                                }
                              },
                              child: Text('SPIN!',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            );
                          }
                        },
                      ),
                    ]),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: BalanceWidget(shakeKey: _pokiesBalanceShakeKey),
                  ),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: GameTitle(gameTitle: 'POKIES'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PokiesController extends GameController {
  int stopIndex = 4;
  void increment(SlotMachineController controller) {
    if (stopIndex < 4) {
      controller.stop(reelIndex: stopIndex);
      stopIndex++;
      update();
    }
  }

  void restart() {
    stopIndex = 0;
    update();
  }
}
