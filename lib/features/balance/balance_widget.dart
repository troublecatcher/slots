import 'package:flutter/material.dart';

import '../../main.dart';
import '../shared/widgets/shake_widget.dart';

class BalanceWidget extends StatelessWidget {
  final GlobalKey<ShakeWidgetState> shakeKey;
  const BalanceWidget({super.key, required this.shakeKey});

  @override
  Widget build(BuildContext context) {
    return ShakeWidget(
      key: shakeKey,
      shakeCount: 3,
      shakeOffset: 10,
      shakeDuration: const Duration(milliseconds: 400),
      child: ValueListenableBuilder<int>(
        valueListenable: creditBalance,
        builder: (context, value, child) {
          return FittedBox(
            child: Container(
              padding: const EdgeInsets.only(right: 30, left: 30),
              decoration: const BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Text('BALANCE',
                      style: Theme.of(context).textTheme.titleSmall),
                  Text(value.toString(),
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
