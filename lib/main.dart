import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slots/features/shared/economics.dart';
import 'package:slots/router/router.dart';
import 'package:slots/theme.dart';

final locator = GetIt.instance;
var creditBalance;
const primaryColor = Color.fromRGBO(95, 2, 47, 1);
const secondaryColor = Color.fromRGBO(19, 165, 61, 1);
const accentColor = Color.fromRGBO(235, 79, 36, 1);

Future<void> main() async {
  await init();
  runApp(MainApp());
}

Future<void> init() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  // locator<SharedPreferences>().clear();
  if (locator<SharedPreferences>().getInt('credits') == null) {
    await locator<SharedPreferences>().setInt('credits', initialBalance);
    await locator<SharedPreferences>()
        .setInt('rewardCooldown', DateTime.now().millisecondsSinceEpoch);
  }
  creditBalance = ValueNotifier<int>(
    locator<SharedPreferences>().getInt('credits')!,
  );
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        ScreenUtil.init(context);
        FlutterNativeSplash.remove();
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: MaterialApp.router(
              theme: theme,
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter.config(),
            ));
      },
    );
  }
}
