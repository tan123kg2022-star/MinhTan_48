import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';
import '../services/file_services.dart';
import '../services/notification_service.dart';

class ScreenTodo extends StatefulWidget {
  const ScreenTodo({super.key});

  @override
  State<ScreenTodo> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<ScreenTodo> {
  final TextEditingController controller = TextEditingController();
  final FileService fileService = FileService();
  final NotificationService notificationService = NotificationService();

  List<Todo> todos = [];
  DateTime? selectedTime;

  final List<Color> colors = [
    const Color(0xFFFFCDD2),
    const Color(0xFFC8E6C9),
    const Color(0xFFBBDEFB),
    const Color(0xFFFFF9C4),
    const Color(0xFFE1BEE7),
  ];

  @override
  void initState() {
    super.initState();
    loadData();
    // Khởi tạo notification service
    notificationService.init();
  }

  void loadData() async {
    todos = await fileService.loadTodos();
    setState(() {});
  }

  void addTodo() async {
    if (controller.text.trim().isEmpty || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên việc và chọn thời gian!')),
      );
      return;
    }

    final todoTitle = controller.text.trim();
    final todoTime = selectedTime!;

    // 1. Lưu vào danh sách và ghi vào file todo.txt
    final todo = Todo(title: todoTitle, time: todoTime);
    todos.add(todo);
    await fileService.saveTodos(todos);

    // Tạo ID duy nhất cho thông báo dựa trên thời gian hiện tại
    final notiId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // 2. Yêu cầu 1: Hiển thị notification đã thêm lịch cho công việc ngay lập tức
    await notificationService.showSimpleNotification(
      id: notiId,
      title: 'Đã thêm lịch công việc',
      body: 'Công việc "$todoTitle" đã được lưu và lên lịch nhắc nhở!',
    );

    // 3. Yêu cầu 2: Thiết lập lịch cho công việc theo thời gian đã chọn
    if (todoTime.isAfter(DateTime.now())) {
      await notificationService.scheduleNotificationAtDate(
        id: notiId + 1,
        title: 'Nhắc nhở công việc',
        body: 'Đã đến giờ thực hiện: $todoTitle!',
        scheduledDate: todoTime,
      );
    }

    controller.clear();
    selectedTime = null;
    setState(() {});
  }

  void pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  String formatTime(DateTime time) {
    return DateFormat("dd/MM/yyyy HH:mm").format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Todo App",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: "Tên công việc",
                labelStyle: const TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1E88E5), width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedTime == null
                        ? "Chưa chọn thời gian"
                        : formatTime(selectedTime!),
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
                OutlinedButton(
                  onPressed: pickDateTime,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2196F3), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: const Text(
                    "Chọn thời gian",
                    style: TextStyle(color: Color(0xFF2196F3), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: addTodo,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E88E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                elevation: 1,
              ),
              child: const Text("Lưu", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: todos.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = todos[index];
                  final Color bgColor = colors[index % colors.length];

                  return Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.assignment_turned_in,
                            size: 24,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatTime(item.time),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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