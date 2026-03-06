# Snake Game Classic - TODO

## 구현 완료 기능
- [x] 20x20 그리드 기반 스네이크 게임 엔진
- [x] 스와이프 제스처 방향 제어
- [x] D-Pad 위젯 방향 제어
- [x] 반대 방향 입력 차단
- [x] 벽 모드 / 일반 모드 (토글)
- [x] 먹이 섭취 시 뱀 성장 + 점수 증가
- [x] 골든 푸드 (50% 확률, 5초 제한, 20점)
- [x] 속도 자동 증가 (먹이 5개마다 -15ms)
- [x] 자기 몸 충돌 판정 (HashSet O(1))
- [x] 3종 스킨 시스템 (Classic, Neon, Fire)
- [x] 보상형 광고로 스킨 해제
- [x] 최고 기록 저장 (Hive)
- [x] 게임 기록 히스토리 (SnakeRecord HiveType)
- [x] 일시정지/재개
- [x] 게임 오버 결과 다이얼로그
- [x] 신기록 달성 시 Confetti 애니메이션
- [x] 진동 피드백 (먹이/골든푸드/게임오버)
- [x] 배너/전면/보상형 광고 통합
- [x] 설정 (햅틱, 사운드)
- [x] 다국어 번역 (ko)
- [x] FlexColorScheme 테마
- [x] Firebase Analytics/Crashlytics
- [x] 인앱 구매 서비스
- [x] 앱 평가 서비스

## 출시 전 남은 작업
- [ ] 앱 아이콘 디자인 및 적용 (`dart run flutter_launcher_icons`)
- [ ] 스플래시 화면 디자인 및 적용 (`dart run flutter_native_splash:create`)
- [ ] Google Play Console 앱 등록
- [ ] Apple App Store Connect 앱 등록
- [ ] AdMob 광고 단위 ID 실제 값으로 교체
- [ ] Firebase 프로젝트 연동 (google-services.json / GoogleService-Info.plist)
- [ ] 개인정보처리방침 URL 생성
- [ ] 스토어 스크린샷 및 그래픽 이미지 제작
- [ ] 릴리스 빌드 테스트
- [ ] 실기기 테스트 (다양한 해상도)
- [ ] 백그라운드 진입/복귀 시 타이머 처리 검증
- [ ] ProGuard 규칙 확인
