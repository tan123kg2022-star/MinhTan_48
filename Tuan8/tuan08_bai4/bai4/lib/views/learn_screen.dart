import 'package:flutter/material.dart';
import 'package:bai4/models/vocab.dart';
import 'package:bai4/services/vocab_file_service.dart';
import 'package:bai4/services/notification_service.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final VocabFileService fileService = VocabFileService();
  final NotificationService notiService = NotificationService();
  final TextEditingController answerController = TextEditingController();

  List<Vocab> vocabs = [];
  int currentIndex = 0;
  int correctCount = 0;
  int wrongCount = 0;
  String feedbackMessage = '';
  Color feedbackColor = Colors.black;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    vocabs = await fileService.loadVocabs();
    setState(() {});
  }

  void checkMeaning() async {
    if (vocabs.isEmpty) return;
    final userAnswer = answerController.text.trim().toLowerCase();
    final correctMeaning = vocabs[currentIndex].meaning.trim().toLowerCase();

    if (userAnswer == correctMeaning) {
      correctCount++;
      feedbackMessage = 'Chính xác! ';
      feedbackColor = Colors.green;
    } else {
      wrongCount++;
      feedbackMessage = 'Sai rồi! Đáp án đúng là: ${vocabs[currentIndex].meaning}';
      feedbackColor = Colors.red;

      // Nếu số từ sai là bội số của 3 -> Gửi notification
      if (wrongCount > 0 && wrongCount % 3 == 0) {
        await notiService.showInstantNotification(
          id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
          title: 'Cảnh báo học từ vựng!',
          body: 'Bạn đã trả lời sai $wrongCount lần. Hãy ôn tập kỹ lại danh sách từ nhé!',
        );
      }
    }

    answerController.clear();
    setState(() {
      currentIndex = (currentIndex + 1) % vocabs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Học từ vựng'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: vocabs.isEmpty
          ? const Center(child: Text('Vui lòng thêm từ vựng ở màn hình chính trước!'))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Hai ô thống kê Đúng / Sai ở trên
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const Text('Số câu Đúng', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('$correctCount', style: const TextStyle(fontSize: 22, color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              const Text('Số câu Sai', style: TextStyle(fontWeight: FontWeight.bold)),
                              Text('$wrongCount', style: const TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Text('Từ tiếng Anh:', style: TextStyle(color: Colors.grey)),
                          const SizedBox(height: 8),
                          Text(
                            vocabs[currentIndex].word,
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: answerController,
                    decoration: InputDecoration(
                      labelText: 'Nhập nghĩa tiếng Việt của từ trên',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: checkMeaning,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    ),
                    child: const Text('Check', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  if (feedbackMessage.isNotEmpty)
                    Text(
                      feedbackMessage,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: feedbackColor),
                      textAlign: TextAlign.center,
                    ),
                ],
              ),
            ),
    );
  }
}