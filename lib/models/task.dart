import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/models/utils.dart';

part 'task.freezed.dart';

part 'task.g.dart';

@freezed
abstract class Task with _$Task, Identifiable {
  Task._();

  factory Task({
    int? id,
    required String name,
    required int duration
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}