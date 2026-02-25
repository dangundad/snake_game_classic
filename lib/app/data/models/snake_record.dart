import 'package:hive_ce/hive_ce.dart';

part 'snake_record.g.dart';

@HiveType(typeId: 0)
class SnakeRecord extends HiveObject {
  @HiveField(0)
  int score;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  String mode;

  SnakeRecord({
    required this.score,
    required this.date,
    required this.mode,
  });
}
