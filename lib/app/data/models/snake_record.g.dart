// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snake_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SnakeRecordAdapter extends TypeAdapter<SnakeRecord> {
  @override
  final typeId = 0;

  @override
  SnakeRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SnakeRecord(
      score: (fields[0] as num).toInt(),
      date: fields[1] as DateTime,
      mode: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SnakeRecord obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.score)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.mode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SnakeRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
