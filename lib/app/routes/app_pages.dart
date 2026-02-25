// ================================================
// DangunDad Flutter App - app_pages.dart Template
// ================================================
// snake_game_classic 移섑솚 ???ъ슜
// mbti_pro ?꾨줈?뺤뀡 ?⑦꽩 湲곕컲 (part ?⑦꽩)
// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:snake_game_classic/app/bindings/app_binding.dart';
import 'package:snake_game_classic/app/controllers/game_controller.dart';
import 'package:snake_game_classic/app/pages/game/game_page.dart';
import 'package:snake_game_classic/app/pages/history/history_page.dart';
import 'package:snake_game_classic/app/pages/home/home_page.dart';
import 'package:snake_game_classic/app/pages/settings/settings_page.dart';
import 'package:snake_game_classic/app/pages/stats/stats_page.dart';
import 'package:snake_game_classic/app/pages/premium/premium_page.dart';
import 'package:snake_game_classic/app/pages/premium/premium_binding.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomePage(),
      binding: AppBinding(),
    ),
    GetPage(
      name: _Paths.GAME,
      page: () => const GamePage(),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<GameController>()) {
          Get.put(GameController(), permanent: true);
        }
      }),
    ),
    GetPage(name: _Paths.SETTINGS, page: () => const SettingsPage()),
    GetPage(name: _Paths.HISTORY, page: () => const HistoryPage()),
    GetPage(name: _Paths.STATS, page: () => const StatsPage()),
    GetPage(
      name: _Paths.PREMIUM,
      page: () => const PremiumPage(),
      binding: PremiumBinding(),
    ),
];
}

