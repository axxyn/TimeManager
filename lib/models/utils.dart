Null toJsonNull(_) => null;

mixin Identifiable {
  int? get id;
  Map<String, dynamic> toJson();
}