// ================================================
// DangunDad Flutter App - translate.dart Template
// ================================================
// mbti_pro 프로덕션 패턴 기반
// 개발 시 한국어(ko)만 정의, 다국어는 추후 추가

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Languages extends Translations {
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ko'),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      // Common
      'settings': 'Settings',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'share': 'Share',
      'reset': 'Reset',
      'done': 'Done',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
      'error': 'Error',
      'success': 'Success',
      'loading': 'Loading...',
      'no_data': 'No data',

      // Settings
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'about': 'About',
      'version': 'Version',
      'rate_app': 'Rate App',
      'privacy_policy': 'Privacy Policy',
      'remove_ads': 'Remove Ads',

      // Feedback
      'send_feedback': 'Send Feedback',
      'more_apps': 'More Apps',

      // App-specific
      'app_name': 'Snake Game',
      'home_subtitle': 'Eat food, grow longer, don\'t hit yourself!',
      'home_play': 'Play',
      'home_best_score': 'Best Score',
      'home_wall_mode': 'Wall Mode',
      'home_wall_mode_on': 'ON – Wall kills you',
      'home_wall_mode_off': 'OFF – Wrap around',
      'home_skin': 'Snake Skin',
      'skin_classic': 'Classic',
      'skin_neon': 'Neon',
      'skin_fire': 'Fire',
      'skin_locked': 'Watch ad to unlock',
      's_unlocked': '{skin} unlocked!',
      'game_score': 'Score',
      'game_best': 'Best',
      'game_paused': 'Paused',
      'game_resume': 'Resume',
      'game_over': 'Game Over',
      'game_new_best': 'New Best!',
      'home': 'Home',
      'play_again': 'Play Again',
    },
    'ko': {
      // 공통
      'settings': '설정',
      'save': '저장',
      'cancel': '취소',
      'delete': '삭제',
      'edit': '편집',
      'share': '공유',
      'reset': '초기화',
      'done': '완료',
      'ok': '확인',
      'yes': '예',
      'no': '아니오',
      'error': '오류',
      'success': '성공',
      'loading': '로딩 중...',
      'no_data': '데이터 없음',

      // 설정
      'dark_mode': '다크 모드',
      'language': '언어',
      'about': '앱 정보',
      'version': '버전',
      'rate_app': '앱 평가',
      'privacy_policy': '개인정보처리방침',
      'remove_ads': '광고 제거',

      // 피드백
      'send_feedback': '피드백 보내기',
      'more_apps': '더 많은 앱',

      // 앱별
      'app_name': '스네이크 게임',
      'home_subtitle': '먹이를 먹고, 길어지고, 자신을 피하세요!',
      'home_play': '게임 시작',
      'home_best_score': '최고 점수',
      'home_wall_mode': '벽 모드',
      'home_wall_mode_on': 'ON – 벽에 닿으면 게임 오버',
      'home_wall_mode_off': 'OFF – 반대편으로 통과',
      'home_skin': '스킨 선택',
      'skin_classic': '클래식',
      'skin_neon': '네온',
      'skin_fire': '파이어',
      'skin_locked': '광고 시청으로 해제',
      's_unlocked': '{skin} 해제됨!',
      'game_score': '점수',
      'game_best': '최고',
      'game_paused': '일시정지',
      'game_resume': '재개',
      'game_over': '게임 오버',
      'game_new_best': '신기록!',
      'home': '홈',
      'play_again': '다시 하기',
    },
  };
}
