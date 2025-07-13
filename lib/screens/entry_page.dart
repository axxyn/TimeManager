import 'package:flutter/material.dart';
import 'package:time_manager/models/entry.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key, required this.entry});

  final Entry entry;

  @override
  Widget build(BuildContext context) {
    return Text('Entry details');
  }
}
