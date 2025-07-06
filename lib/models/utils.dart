

Null toJsonNull(_) => null;

mixin Identifiable {
  int? get id;
  String get name;
  Map<String, dynamic> toJson();
}