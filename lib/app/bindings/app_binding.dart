// ================================================
// DangunDad Flutter App - app_binding.dart Template
// ================================================
// snake_game_classic 치환 후 사용
// mbti_pro 프로덕션 패턴 기반

import 'package:get/get.dart';

import 'package:snake_game_classic/app/controllers/game_controller.dart';
import 'package:snake_game_classic/app/controllers/home_controller.dart';
import 'package:snake_game_classic/app/controllers/setting_controller.dart';
import 'package:snake_game_classic/app/services/hive_service.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
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
  }
}
