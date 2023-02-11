import 'package:isar/isar.dart';

import 'category.dart';

part 'task.g.dart';

@collection
class Task {
  Id id;
  DateTime? date;
  String title;
  String description;
  bool important;
  bool done;

  final category = IsarLink<Category>();

  Task({
    this.id = Isar.autoIncrement,
    required this.date,
    required this.title,
    this.description = '',
    this.important = false,
    this.done = false,
  });
}