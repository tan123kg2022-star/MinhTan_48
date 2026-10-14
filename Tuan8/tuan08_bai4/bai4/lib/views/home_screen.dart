import 'package:flutter/material.dart';
import 'package:bai4/models/vocab.dart';
import 'package:bai4/services/vocab_file_service.dart';
import 'package:bai4/services/notification_service.dart';
import 'package:bai4/views/learn_screen.dart';
import 'package:bai4/views/quiz_screen.dart';
import 'package:bai4/views/pending_noti_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController wordController = TextEditingController();
  final TextEditingController meaningController = TextEditingController();
  final VocabFileService fileService = VocabFileService();
  final NotificationService notiService = NotificationService();

  List<Vocab> vocabs = [];

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  void loadWords() async {
    vocabs = await fileService.loadVocabs();
    setState(() {});
  }

  void saveAndSchedule() async {
    final word = wordController.text.trim();
    final meaning = meaningController.text.trim();

    if (word.isEmpty || meaning.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ từ và nghĩa!')),
      );
      return;
    }

    // 1. Lưu vào file
    await fileService.addVocab(Vocab(word: word, meaning: meaning));
    loadWords();

    final baseId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // 2. Hiển thị notification báo đã lưu
    await notiService.showInstantNotification(
      id: baseId,
      title: 'Đã lưu từ vựng mới',
      body: 'Đã lưu từ "$word". Hãy ôn tập lại sau 10 phút nhé!',
    );

    // 3. Đặt lịch nhắc sau 10 phút
    await notiService.scheduleAfter10Minutes(
      id: baseId + 1,
      word: word,
      meaning: meaning,
    );

    // 4. Hiển thị SnackBar dưới đáy màn hình
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã lưu "$word" và hẹn nhắc ôn tập sau 10 phút!'),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }

    wordController.clear();
    meaningController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hỗ trợ học Từ Vựng'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'learn') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LearnScreen()));
              } else if (value == 'quiz') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen()));
              } else if (value == 'pending') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PendingNotiScreen()));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'learn', child: Text('📖 Học từ')),
              const PopupMenuItem(value: 'quiz', child: Text('📝 Kiểm tra từ')),
              const PopupMenuItem(value: 'pending', child: Text('⏰ Lịch nhắc')),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.menu_book, color: Colors.white, size: 48),
                  SizedBox(height: 8),
                  Text('Menu Học Từ Vựng', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: const Text('Thêm từ mới'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Học từ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const LearnScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.quiz),
              title: const Text('Kiểm tra từ'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active),
              title: const Text('Lịch nhắc'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PendingNotiScreen()));
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: wordController,
              decoration: InputDecoration(
                labelText: 'Nhập từ tiếng Anh (VD: Apple)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: meaningController,
              decoration: InputDecoration(
                labelText: 'Nhập nghĩa của từ (VD: Quả táo)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: saveAndSchedule,
                icon: const Icon(Icons.alarm_add),
                label: const Text('Lưu và Nhắc học sau 10 phút'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Danh sách từ đã lưu:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: vocabs.isEmpty
                  ? const Center(child: Text('Chưa có từ vựng nào được lưu.'))
                  : ListView.builder(
                      itemCount: vocabs.length,
                      itemBuilder: (context, index) {
                        final v = vocabs[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${index + 1}')),
                            title: Text(v.word, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text(v.meaning),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}