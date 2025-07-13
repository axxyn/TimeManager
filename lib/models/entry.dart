import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/models/utils.dart';

part 'entry.freezed.dart';

part 'entry.g.dart';

@freezed
@JsonSerializable()
class Entry with _$Entry, Identifiable {
  Entry({this.id, required this.task, required this.coworker, DateTime? dateTime, this.note}) : timestamp = dateTime != null ? dateTime.millisecondsSinceEpoch : DateTime.now().millisecondsSinceEpoch;

  @override
  final int? id;
  @override
  final int task;
  @override
  final int coworker;
  @override
  int timestamp;
  @override
  final String? note;

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EntryToJson(this);

  DateTime get timestampDateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);
}