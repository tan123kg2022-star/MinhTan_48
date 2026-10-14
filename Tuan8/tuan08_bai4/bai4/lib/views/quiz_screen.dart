import 'dart:math';
import 'package:flutter/material.dart';
import 'package:bai4/models/vocab.dart';
import 'package:bai4/services/vocab_file_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final VocabFileService fileService = VocabFileService();
  List<Vocab> vocabs = [];
  int currentQuestion = 0;
  int correctCount = 0;
  int wrongCount = 0;
  List<String> currentOptions = [];

  @override
  void initState() {
    super.initState();
    initQuiz();
  }

  void initQuiz() async {
    vocabs = await fileService.loadVocabs();
    if (vocabs.isNotEmpty) {
      generateOptions();
    }
    setState(() {});
  }

  void generateOptions() {
    final correctMeaning = vocabs[currentQuestion].meaning;
    final Set<String> optionsSet = {correctMeaning};
    final random = Random();

    // Lấy thêm các đáp án nhiễu từ danh sách hoặc mặc định
    final fallbackPool = ['Quả cam', 'Con mèo', 'Ngôi nhà', 'Cuốn sách', 'Máy tính', 'Bầu trời'];
    final allMeanings = [...vocabs.map((e) => e.meaning), ...fallbackPool];

    while (optionsSet.length < 4) {
      optionsSet.add(allMeanings[random.nextInt(allMeanings.length)]);
    }

    currentOptions = optionsSet.toList()..shuffle();
  }

  void selectOption(String selected) {
    final correctMeaning = vocabs[currentQuestion].meaning;
    if (selected == correctMeaning) {
      correctCount++;
    } else {
      wrongCount++;
    }

    if (currentQuestion + 1 < vocabs.length) {
      setState(() {
        currentQuestion++;
        generateOptions();
      });
    } else {
      setState(() {});
      showResultDialog();
    }
  }

  void showResultDialog() {
    final total = vocabs.length;
    final ratio = total > 0 ? ((correctCount / total) * 100).toStringAsFixed(1) : '0';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Kết quả kiểm tra'),
        content: Text(
          'Tổng số câu: $total\n'
          'Số câu Đúng: $correctCount\n'
          'Số câu Sai: $wrongCount\n'
          'Tỉ lệ đúng: $correctCount/$total câu ($ratio%)',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Hoàn thành'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kiểm tra từ vựng'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: vocabs.isEmpty
          ? const Center(child: Text('Chưa có dữ liệu từ vựng để kiểm tra!'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Câu hỏi: ${currentQuestion + 1}/${vocabs.length}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Đúng: $correctCount | Sai: $wrongCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Text('Nghĩa của từ dưới đây là gì?'),
                          const SizedBox(height: 10),
                          Text(
                            vocabs[currentQuestion].word,
                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...currentOptions.map(
                    (option) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OutlinedButton(
                        onPressed: () => selectOption(option),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(option, style: const TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}