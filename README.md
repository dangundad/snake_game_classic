# Snake Game Classic

클래식 스네이크 게임 - 방향 스와이프/D-Pad로 뱀을 조종하여 먹이를 먹고 최고 점수에 도전하세요.

## 주요 기능
- 20x20 그리드 기반 클래식 스네이크 게임
- 스와이프 제스처 및 D-Pad 방향 조작
- 벽 모드 (벽 충돌 게임오버) / 일반 모드 (반대편 이동)
- 3종 스킨 시스템 (Classic, Neon, Fire)
- 골든 푸드 보너스 (시간 제한 20점)
- 속도 자동 증가 (먹이 5개마다)
- 최고 기록 저장 및 게임 히스토리
- 진동 피드백
- AdMob 광고 (배너/전면/보상형)

## 기술 스택
- **Framework**: Flutter 3.x / Dart 3.8+
- **State Management**: GetX
- **Local Storage**: Hive_CE
- **UI**: flutter_screenutil, flex_color_scheme, google_fonts
- **Ads**: google_mobile_ads + AppLovin/Pangle/Unity Mediation
- **Analytics**: Firebase Analytics & Crashlytics

## 설치 및 실행
```bash
# 의존성 설치
flutter pub get

# 코드 생성 (Hive 모델)
dart run build_runner build --delete-conflicting-outputs

# 정적 분석
flutter analyze

# 앱 실행
flutter run
```

## 프로젝트 구조
```
lib/
├── main.dart
├── hive_registrar.g.dart
├── app/
│   ├── admob/          # 광고 관리
│   ├── bindings/       # GetX 바인딩
│   ├── controllers/    # 게임/설정/통계 컨트롤러
│   ├── data/           # Enum, Hive 모델
│   ├── pages/          # 화면별 위젯
│   ├── routes/         # 라우팅
│   ├── services/       # Hive, 구매, 평가 서비스
│   ├── theme/          # FlexColorScheme 테마
│   ├── translate/      # 다국어 번역
│   ├── utils/          # 상수
│   └── widgets/        # 공용 위젯
```

## 라이선스
Copyright (c) 2026 DangunDad. All rights reserved.
