import 'package:isar/isar.dart';
import 'package:welldone/models/task.dart';

part 'category.g.dart';

@collection
class Category {
  Id id;
  int icon;
  String title;
  String description;
  int color;

  @Backlink(to: 'category')
  final tasks = IsarLinks<Task>();

  Category({
    this.id = Isar.autoIncrement,
    required this.icon,
    required this.title,
    this.description = '',
    required this.color
  });
}