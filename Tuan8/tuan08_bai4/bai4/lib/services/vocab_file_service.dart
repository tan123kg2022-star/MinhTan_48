import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:bai4/models/vocab.dart';

class VocabFileService {
  Future<File> get _file async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/vocab.txt');
  }

  Future<void> addVocab(Vocab vocab) async {
    final list = await loadVocabs();
    list.add(vocab);
    final file = await _file;
    final data = list.map((e) => e.toFileString()).join("\n");
    await file.writeAsString(data);
  }

  Future<List<Vocab>> loadVocabs() async {
    try {
      final file = await _file;
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      return content
          .split("\n")
          .where((line) => line.trim().isNotEmpty)
          .map((line) => Vocab.fromString(line))
          .toList();
    } catch (e) {
      return [];
    }
  }
}