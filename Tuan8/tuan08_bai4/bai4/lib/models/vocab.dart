class Vocab {
  String word;
  String meaning;

  Vocab({required this.word, required this.meaning});

  String toFileString() => "${word.trim()}|${meaning.trim()}";

  static Vocab fromString(String line) {
    final parts = line.split("|");
    return Vocab(word: parts[0], meaning: parts.length > 1 ? parts[1] : "");
  }
}
