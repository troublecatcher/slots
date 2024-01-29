import 'package:get/get.dart';
import 'package:slots/features/balance/balance_functions.dart';

import 'game_status.dart';

class GameController extends GetxController {
  GameStatus gameStatus = GameStatus.initial;
  int balanceResult = 0;
  void startGame() {
    gameStatus = GameStatus.inProgress;
    balanceResult = 0;
  }

  Future<void> endGame(GameStatus result, int balanceUpdate) async {
    gameStatus = result;
    balanceResult += balanceUpdate;
    await updateBalance(balanceResult);
    Future.delayed(const Duration(milliseconds: 700), () => update());
  }
}
