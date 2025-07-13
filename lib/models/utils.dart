Null toJsonNull(_) => null;

mixin Identifiable {
  int? get id;
  Map<String, dynamic> toJson();
}

enum EntryArea {
  A,
  B,
  C
}