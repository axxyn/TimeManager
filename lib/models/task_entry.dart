import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/models/user.dart';
import 'package:time_manager/repositories/repository.dart';

part 'task_entry.freezed.dart';

part 'task_entry.g.dart';

enum Letters {
  A,
  B,
  C
}

@freezed
class TaskEntry with _$TaskEntry, Mappable  {
  TaskEntry._();

  factory TaskEntry({
    int? id,
    required int number,
    required Letters letter,
    required User coworker
  }) = _TaskEntry;

  factory TaskEntry.fromJson(Map<String, dynamic> json) => _$TaskEntryFromJson(json);

  Map<String, dynamic> toMap() => toJson();
  fromMap(Map<String, dynamic> map) => _$TaskEntryFromJson(map);
}