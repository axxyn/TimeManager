import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/repositories/repository.dart';

part 'task.freezed.dart';

part 'task.g.dart';

@freezed
class Task with _$Task, Mappable {
  Task._();

  factory Task({
    int? id,
    required String name,
    required int duration
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toMap() => toJson();
  fromMap(Map<String, dynamic> map) => _$TaskFromJson(map);
}