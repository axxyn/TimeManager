import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/models/user.dart';

part 'taskEntry.freezed.dart';

part 'taskEntry.g.dart';

enum Letters {
  A,
  B,
  C
}

@freezed
class TaskEntry with _$TaskEntry {
  const TaskEntry._();

  const factory TaskEntry({
    int? id,
    required int number,
    required Letters letter,
    required User coworker
  }) = _TaskEntry;

  factory TaskEntry.fromJson(Map<String, dynamic> json) => _$TaskEntryFromJson(json);
}