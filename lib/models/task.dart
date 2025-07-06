import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/models/utils.dart';

part 'task.freezed.dart';

part 'task.g.dart';

@freezed
class Task with _$Task, Identifiable {
  Task._();

  factory Task({
    @JsonKey(includeIfNull: false) int? id,
    required String name,
    required int duration
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  @override
  Map<String, dynamic> toJson() => toJson();
}