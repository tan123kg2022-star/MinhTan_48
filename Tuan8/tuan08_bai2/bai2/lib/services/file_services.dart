import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:bai2/models/todo.dart'; // Import đúng tên package

class FileService {
  Future<String> get _path async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _file async {
    final path = await _path;
    return File('$path/todo.txt');
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final file = await _file;
    final String data = todos.map((e) => e.toFileString()).join("\n");
    await file.writeAsString(data);
  }

  Future<List<Todo>> loadTodos() async {
    try {
      final file = await _file;
      final content = await file.readAsString();

      return content
          .split("\n")
          .where((e) => e.trim().isNotEmpty)
          .map((e) => Todo.fromString(e))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
