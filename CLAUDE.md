# CLAUDE.md - Snake Game Classic

## 프로젝트 개요
클래식 스네이크 게임 앱. 방향 스와이프/D-Pad로 뱀을 조종하여 먹이를 먹고 점수를 올리는 게임.
- **패키지명**: `com.dangundad.snakegameclassic`
- **퍼블리셔**: DangunDad
- **수익 모델**: 완전 무료 + AdMob 광고 (배너 + 전면 + 보상형)

## 기술 스택
- **Flutter** 3.x / Dart 3.8+
- **상태 관리**: GetX (`GetxController`, `.obs`, `Obx()`)
- **로컬 저장**: Hive_CE (`@HiveType` 어댑터)
- **UI**: flutter_screenutil, flex_color_scheme (FlexScheme.tealM3), google_fonts, lucide_icons_flutter
- **광고**: google_mobile_ads + AppLovin/Pangle/Unity 미디에이션
- **기타**: vibration, flutter_animate, firebase_core/analytics/crashlytics, in_app_purchase, in_app_review

## 개발 명령어
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter run
```

## 아키텍처 (프로젝트 구조)
```
lib/
├── main.dart                          # 앱 진입점 (GDPR, AdMob, Hive 초기화)
├── hive_registrar.g.dart              # Hive 어댑터 자동 등록
├── app/
│   ├── admob/
│   │   ├── ads_banner.dart            # 배너 광고 위젯
│   │   ├── ads_helper.dart            # 광고 ID 및 GDPR 동의
│   │   ├── ads_interstitial.dart      # 전면 광고 매니저
│   │   └── ads_rewarded.dart          # 보상형 광고 매니저
│   ├── bindings/
│   │   └── app_binding.dart           # GetX 앱 바인딩
│   ├── controllers/
│   │   ├── game_controller.dart       # 게임 로직 (뱀 이동, 충돌, 점수)
│   │   ├── history_controller.dart    # 게임 기록 관리
│   │   ├── home_controller.dart       # 홈 화면 컨트롤러
│   │   ├── premium_controller.dart    # 프리미엄/구매 컨트롤러
│   │   ├── setting_controller.dart    # 설정 (햅틱, 사운드)
│   │   └── stats_controller.dart      # 통계 컨트롤러
│   ├── data/
│   │   ├── enums/
│   │   │   ├── direction.dart         # 이동 방향 (up, down, left, right)
│   │   │   ├── game_status.dart       # 게임 상태 (idle, playing, paused, over)
│   │   │   └── snake_skin.dart        # 스킨 (classic, neon, fire)
│   │   └── models/
│   │       ├── snake_record.dart      # 게임 기록 모델 (@HiveType)
│   │       └── snake_record.g.dart
│   ├── pages/
│   │   ├── game/
│   │   │   ├── game_page.dart         # 게임 화면
│   │   │   └── widgets/
│   │   │       ├── d_pad.dart         # 방향 패드 위젯
│   │   │       ├── game_board.dart    # 게임 보드 (CustomPainter)
│   │   │       └── result_dialog.dart # 결과 다이얼로그
│   │   ├── history/history_page.dart  # 기록 화면
│   │   ├── home/home_page.dart        # 홈 화면
│   │   ├── premium/                   # 프리미엄 화면
│   │   ├── settings/settings_page.dart
│   │   └── stats/stats_page.dart
│   ├── routes/
│   │   ├── app_pages.dart             # GetPages 정의
│   │   └── app_routes.dart            # 라우트 상수
│   ├── services/
│   │   ├── activity_log_service.dart   # 활동 로그
│   │   ├── app_rating_service.dart     # 앱 평가 서비스
│   │   ├── hive_service.dart           # Hive 데이터 서비스
│   │   └── purchase_service.dart       # 인앱 구매 서비스
│   ├── theme/app_flex_theme.dart       # FlexColorScheme 테마
│   ├── translate/translate.dart        # 다국어 번역
│   ├── utils/app_constants.dart        # 앱 상수
│   └── widgets/confetti_overlay.dart   # 축하 애니메이션
```

## 데이터 모델
### SnakeRecord (HiveType, typeId: 0)
| 필드 | 타입 | 설명 |
|------|------|------|
| score | int | 점수 |
| date | DateTime | 플레이 날짜 |
| mode | String | 게임 모드 (wall/normal) |

## 핵심 게임 로직
- **그리드**: 20x20 셀
- **이동**: Timer 기반 틱, 방향 큐잉 (반대 방향 차단)
- **속도**: 먹이 5개마다 속도 증가 (200ms -> 80ms, -15ms씩)
- **골든 푸드**: 3개 이상 먹은 후 50% 확률로 출현, 5초간 유지, 20점
- **벽 모드**: 벽 충돌 시 게임 오버 / 비활성 시 반대편으로 이동
- **스킨**: classic(기본), neon, fire - 보상형 광고로 해제
- **충돌 판정**: HashSet 기반 O(1) 자기 몸 충돌 체크

## 개발 가이드라인
- GetX `.to` 패턴 사용 (`GameController.to`)
- Hive 키-값 저장: `HiveService.to.getAppData()` / `setAppData()`
- 광고: 게임 오버 시 전면 광고, 스킨 해제 시 보상형 광고
- 진동 피드백: `SettingController.to.hapticEnabled` 체크 후 사용
- 번역: `.tr` 확장 사용, ko 우선 정의
