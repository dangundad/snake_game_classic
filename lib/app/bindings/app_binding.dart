// ================================================
// DangunDad Flutter App - app_binding.dart Template
// ================================================
// snake_game_classic 移섑솚 ???ъ슜
// mbti_pro ?꾨줈?뺤뀡 ?⑦꽩 湲곕컲

import 'package:get/get.dart';
import 'package:snake_game_classic/app/controllers/game_controller.dart';
import 'package:snake_game_classic/app/controllers/home_controller.dart';
import 'package:snake_game_classic/app/controllers/setting_controller.dart';
import 'package:snake_game_classic/app/services/hive_service.dart';
import 'package:snake_game_classic/app/services/activity_log_service.dart';
import 'package:snake_game_classic/app/controllers/history_controller.dart';
import 'package:snake_game_classic/app/controllers/stats_controller.dart';

import 'package:snake_game_classic/app/services/purchase_service.dart';
import 'package:snake_game_classic/app/controllers/premium_controller.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PurchaseService>()) {
      Get.put(PurchaseService(), permanent: true);
    }

    if (!Get.isRegistered<PremiumController>()) {
      Get.lazyPut(() => PremiumController());
    }

    if (!Get.isRegistered<HiveService>()) {
      Get.put(HiveService(), permanent: true);
    }

    if (!Get.isRegistered<SettingController>()) {
      Get.put(SettingController(), permanent: true);
    }

    if (!Get.isRegistered<GameController>()) {
      Get.put(GameController(), permanent: true);
    }

    Get.lazyPut(() => HomeController(), fenix: true);
  
if (!Get.isRegistered<ActivityLogService>()) {
      Get.put(ActivityLogService(), permanent: true);
    }
if (!Get.isRegistered<HistoryController>()) {
      Get.lazyPut(() => HistoryController());
    }
if (!Get.isRegistered<StatsController>()) {
      Get.lazyPut(() => StatsController());
    }}
}

