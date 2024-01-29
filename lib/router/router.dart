import 'package:auto_route/auto_route.dart';

import '../features/landing/main_screen.dart';
import '../features/games/pokies/pokies_screen.dart';
import '../features/games/roulette/roulette_screen.dart';
import '../features/games/slot/slot_screen.dart';
import '../features/landing/gift_screen.dart';
import '../features/settings/privacy_policy_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/settings/terms_of_use_screen.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: MainRoute.page, initial: true),
        AutoRoute(page: SlotRoute.page),
        AutoRoute(page: PokiesRoute.page),
        AutoRoute(page: RouletteRoute.page),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: TermsOfUseRoute.page),
        AutoRoute(page: PrivacyPolicyRoute.page),
        AutoRoute(page: GiftRoute.page),
      ];
}
