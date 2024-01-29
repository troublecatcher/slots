import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:slots/features/shared/economics.dart';
import 'package:slots/features/shared/game_controller.dart';
import 'package:slots/features/shared/game_status.dart';
import 'package:slots/main.dart';

class StatusBoard extends StatelessWidget {
  final List<Widget> widgets;
  final GameController controller;

  const StatusBoard(
      {super.key, required this.widgets, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border.all(width: 4, color: secondaryColor),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: FittedBox(
        child: Column(
          children: [
            GetBuilder<GameController>(
              init: controller,
              builder: (_) {
                return Text(controller.gameStatus.title,
                    style: Theme.of(context).textTheme.titleSmall);
              },
            ),
            SizedBox(height: 10.h),
            GetBuilder<GameController>(
              init: controller,
              builder: (_) {
                if (controller.gameStatus == GameStatus.inProgress) {
                  return const CupertinoActivityIndicator(color: Colors.white);
                } else if (controller.gameStatus == GameStatus.initial) {
                  return Text(gameCost.abs().toString(),
                      style: Theme.of(context).textTheme.titleMedium);
                } else {
                  return Text(controller.balanceResult.toString(),
                      style: Theme.of(context).textTheme.titleMedium);
                }
              },
            ),
            SizedBox(height: 10.h),
            ...widgets,
          ],
        ),
      ),
    );
  }
}
