import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/models/user.dart';
import 'package:time_manager/models/utils.dart';

part 'task_entry.freezed.dart';

part 'task_entry.g.dart';

enum Letters {
  A,
  B,
  C
}

@freezed
class TaskEntry with _$TaskEntry, Identifiable {
  TaskEntry._();

  factory TaskEntry({
    @JsonKey(includeIfNull: false) int? id,
    required int number,
    required Letters letter,
    required User coworker
  }) = _TaskEntry;

  factory TaskEntry.fromJson(Map<String, dynamic> json) => _$TaskEntryFromJson(json);
  @override
  Map<String, dynamic> toJson() => toJson();
}