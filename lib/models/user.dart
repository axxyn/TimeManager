import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:time_manager/repositories/repository.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@freezed
class User with _$User, Mappable {
  User._();

  factory User({
    int? id,
    required String name,
    String? surname
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toMap() => toJson();
  fromMap(Map<String, dynamic> map) => _$UserFromJson(map);
}