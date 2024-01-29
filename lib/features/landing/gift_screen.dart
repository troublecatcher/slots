import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slots/features/balance/balance_functions.dart';
import 'package:slots/features/shared/economics.dart';
import 'package:slots/features/shared/widgets/back_buttonn.dart';
import 'package:slots/features/shared/widgets/button.dart';
import 'package:slots/main.dart';

@RoutePage()
class GiftScreen extends StatefulWidget {
  const GiftScreen({Key? key}) : super(key: key);

  @override
  _GiftScreenState createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {
  late Timer _timer;
  int _remainingTime = 0;

  @override
  void initState() {
    super.initState();
    _checkRemainingTime();
    _startTimer();
  }

  Future<void> _checkRemainingTime() async {
    final rewardCooldown =
        locator<SharedPreferences>().getInt('rewardCooldown')!;
    // print('$_remainingTime, $rewardCooldown');
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now < rewardCooldown) {
      setState(() {
        _remainingTime = rewardCooldown - now;
      });
    } else {
      setState(() {
        _remainingTime = 0;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkRemainingTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _setRewardExpirationTime() async {
    final now = DateTime.now();
    final tomorrow = DateTime(
        now.year, now.month, now.day + 1, now.hour, now.minute, now.second);
    final millisecondsSinceEpoch = tomorrow.millisecondsSinceEpoch;

    await locator<SharedPreferences>()
        .setInt('rewardCooldown', millisecondsSinceEpoch);
    _checkRemainingTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/landing/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BackButtonn(isActive: true),
                        Text('DAILY REWARD',
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Image.asset(_remainingTime == 0
                              ? 'assets/gift/chest_opened.png'
                              : 'assets/gift/chest_closed.png'),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  border: Border.all(
                                      width: 4, color: secondaryColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                                child: _remainingTime != 0
                                    ? Text(
                                        'You got your $dailyReward coins daily bonus today. Come back tomorrow!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium)
                                    : Text(
                                        'Every 24 hours you can get your daily reward',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium),
                              ),
                              const SizedBox(height: 10),
                              _remainingTime != 0
                                  ? Button(
                                      child: Text(
                                          'NEXT: ${_formatDuration(Duration(milliseconds: _remainingTime))}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium))
                                  : Button(
                                      callback: (p0) {
                                        updateBalance(dailyReward);
                                        _setRewardExpirationTime();
                                      },
                                      child: Text('GET REWARD',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.remainder(24).toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
