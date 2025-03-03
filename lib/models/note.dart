import 'package:isar/isar.dart';

// This line isar part 'note.g.dart'; is used to generate the file note.g.dart
// then run the command dart run build_runner build
part 'note.g.dart';

@Collection()
class Note {
  Id id = Isar.autoIncrement;
  late String title;
  late String content;
  DateTime? updatedAt;
}