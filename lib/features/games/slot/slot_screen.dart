import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:slots/features/balance/balance_widget.dart';
import 'package:slots/features/shared/economics.dart';
import 'package:slots/features/shared/widgets/back_buttonn.dart';
import 'package:slots/features/shared/widgets/button.dart';
import 'package:slots/features/shared/game_controller.dart';
import 'package:slots/features/shared/widgets/game_title.dart';
import 'package:slots/features/shared/widgets/shake_widget.dart';
import 'package:slots/features/shared/widgets/status_board.dart';
import 'package:slots/features/shared/game_status.dart';

import '../../balance/balance_functions.dart';
import 'slot_machine.dart';

final _slotMachineShakeKey = GlobalKey<ShakeWidgetState>();
final _slotBalanceShakeKey = GlobalKey<ShakeWidgetState>();
bool showMachine = false;

@RoutePage()
class SlotScreen extends StatefulWidget {
  const SlotScreen({super.key});

  @override
  State<SlotScreen> createState() => _SlotScreenState();
}

class _SlotScreenState extends State<SlotScreen> {
  late SlotMachineController _slotsController;
  late SlotController _gameController;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _gameController = SlotController();
    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 800));
  }

  @override
  void dispose() {
    _gameController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void onButtonTap({required int index}) {
    _slotsController.stop(reelIndex: index);
  }

  void onStart() {
    if (_gameController.ableToRestart) {
      _gameController.startGame();
      _gameController.changeStatus();
      final index = Random().nextInt(100);
      _slotsController.start(hitRollItemIndex: index < 10 ? index : null);
      Future.delayed(const Duration(milliseconds: 1000), () {
        _slotsController.stop(reelIndex: 0);
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        _slotsController.stop(reelIndex: 1);
      });
      Future.delayed(const Duration(milliseconds: 2000), () {
        _slotsController.stop(reelIndex: 2);
      });
    }
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
                image: AssetImage('assets/games/slot/bg.png'),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: BackButtonn(isActive: _gameController.ableToRestart),
                ),
                Image.asset(
                  'assets/games/slot/slot.png',
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 1.5,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: ShakeWidget(
                    key: _slotMachineShakeKey,
                    shakeCount: 3,
                    shakeOffset: 10,
                    shakeDuration: const Duration(milliseconds: 400),
                    child: !showMachine
                        ? const CupertinoActivityIndicator()
                        : SlotMachine(
                            reelWidth: MediaQuery.of(context).size.width / 8,
                            reelHeight: MediaQuery.of(context).size.height / 3,
                            rollItems: List.generate(10, (index) {
                              return RollItem(
                                index: index,
                                child: Image.asset('assets/items/$index.png'),
                              );
                            }),
                            onCreated: (controller) {
                              _slotsController = controller;
                            },
                            onFinished: (resultIndexes) async {
                              if (resultIndexes[0] == resultIndexes[1] &&
                                  resultIndexes[1] == resultIndexes[2]) {
                                await Future.delayed(
                                    const Duration(milliseconds: 300));
                                _confettiController.play();
                                await _gameController.endGame(
                                    GameStatus.win, winReward);
                              } else {
                                await Future.delayed(
                                    const Duration(milliseconds: 300));
                                _slotMachineShakeKey.currentState?.shake();
                                await _gameController.endGame(
                                    GameStatus.lose, gameCost);
                              }
                              _gameController.changeStatus();
                            },
                          ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: StatusBoard(controller: _gameController, widgets: [
                    GetBuilder<SlotController>(
                      init: _gameController,
                      builder: (_) {
                        if (!_gameController.ableToRestart) {
                          return Button(
                              child: Text('SPIN!',
                                  style:
                                      Theme.of(context).textTheme.titleMedium));
                        } else {
                          return Button(
                              callback: (p0) {
                                if (isBalanceSufficient()) {
                                  onStart();
                                } else {
                                  _slotBalanceShakeKey.currentState!.shake();
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
                  alignment: Alignment.bottomCenter,
                  child: BalanceWidget(shakeKey: _slotBalanceShakeKey),
                ),
                const Align(
                  alignment: Alignment.topCenter,
                  child: GameTitle(gameTitle: 'SLOT'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SlotController extends GameController {
  bool ableToRestart = true;
  void changeStatus() {
    ableToRestart = !ableToRestart;
    update();
  }
}
