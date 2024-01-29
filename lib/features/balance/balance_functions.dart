import 'package:shared_preferences/shared_preferences.dart';
import 'package:slots/features/shared/economics.dart';
import 'package:slots/main.dart';

bool isBalanceSufficient() {
  return locator<SharedPreferences>().getInt('credits')! >= gameCost.abs();
}

Future<void> updateBalance(int value) async {
  var balance = locator<SharedPreferences>().getInt('credits')!;
  balance += value;
  await locator<SharedPreferences>().setInt('credits', balance);
  creditBalance.value = balance;
}
