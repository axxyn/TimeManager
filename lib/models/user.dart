import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/models/utils.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@freezed
class User with _$User, Identifiable {
  User._();

  factory User({
    @JsonKey(includeIfNull: false)  int? id,
    required String name,
    String? surname
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}