import 'package:flutter/material.dart';

enum SnakeSkin {
  classic,
  neon,
  fire;

  Color get bodyColor {
    switch (this) {
      case SnakeSkin.classic:
        return const Color(0xFF4CAF50);
      case SnakeSkin.neon:
        return const Color(0xFF00E5FF);
      case SnakeSkin.fire:
        return const Color(0xFFFF6D00);
    }
  }

  Color get headColor {
    switch (this) {
      case SnakeSkin.classic:
        return const Color(0xFF1B5E20);
      case SnakeSkin.neon:
        return const Color(0xFFFFFFFF);
      case SnakeSkin.fire:
        return const Color(0xFFBF360C);
    }
  }

  Color get bgColor {
    switch (this) {
      case SnakeSkin.classic:
        return const Color(0xFF1B2631);
      case SnakeSkin.neon:
        return const Color(0xFF0D0D1A);
      case SnakeSkin.fire:
        return const Color(0xFF1A0A00);
    }
  }

  Color get foodColor {
    switch (this) {
      case SnakeSkin.classic:
        return const Color(0xFFE53935);
      case SnakeSkin.neon:
        return const Color(0xFFFFEB3B);
      case SnakeSkin.fire:
        return const Color(0xFF29B6F6);
    }
  }

  String get labelKey {
    switch (this) {
      case SnakeSkin.classic:
        return 'skin_classic';
      case SnakeSkin.neon:
        return 'skin_neon';
      case SnakeSkin.fire:
        return 'skin_fire';
    }
  }

  bool get requiresUnlock => this != SnakeSkin.classic;
}
