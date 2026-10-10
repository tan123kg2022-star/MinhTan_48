import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(VideoRecorderApp());
}

class VideoRecorderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Recorder & Playback',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ), // Đổi màu Theme thành màu tím theo tài liệu
      home: VideoRecorderHome(),
    );
  }
}

class VideoRecorderHome extends StatefulWidget {
  @override
  _VideoRecorderHomeState createState() => _VideoRecorderHomeState();
}

class _VideoRecorderHomeState extends State<VideoRecorderHome> {
  File? _videoFile;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();

  // Yêu cầu quyền truy cập hệ thống
  Future<void> _requestPermission(Permission permission) async {
    if (await permission.isDenied) {
      await permission.request();
    }
  }

  // Chức năng: Chọn video từ gallery
  Future<void> _pickVideoFromGallery() async {
    await _requestPermission(Permission.photos);
    final XFile? pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _loadVideo(File(pickedFile.path));
    }
  }

  // Chức năng: Quay video từ camera
  Future<void> _recordVideoFromCamera() async {
    await _requestPermission(Permission.camera);
    await _requestPermission(
      Permission.microphone,
    ); // Quay video bắt buộc xin quyền Micro
    final XFile? recordedFile = await _picker.pickVideo(
      source: ImageSource.camera,
    );
    if (recordedFile != null) {
      _loadVideo(File(recordedFile.path));
    }
  }

  // Hàm phụ trợ: Tải và khởi tạo controller để phát video
  void _loadVideo(File videoFile) {
    setState(() {
      _videoFile = videoFile;
      _videoController?.dispose(); // Giải phóng controller cũ trước khi tạo mới
      _videoController = VideoPlayerController.file(_videoFile!)
        ..initialize().then((_) {
          setState(() {}); // Cập nhật lại UI sau khi load xong file
          _videoController!.play(); // Tự động phát khi chọn xong
        });
    });
  }

  @override
  void dispose() {
    _videoController
        ?.dispose(); // Đóng controller khi thoát app để giải phóng RAM
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Recorder & Playback')),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),

            // Khu vực trình chiếu Video
            _videoController != null && _videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : Container(
                    height: 200,
                    child: Center(child: Text('Chưa có video nào được chọn.')),
                  ),
            SizedBox(height: 20),

            // Nút Play / Pause (Chỉ hiện khi đã có video)
            if (_videoController != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _videoController!.value.isPlaying
                            ? _videoController!.pause()
                            : _videoController!.play();
                      });
                    },
                    child: Icon(
                      _videoController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 20),

            // Các nút chức năng chọn file
            ElevatedButton(
              onPressed: _pickVideoFromGallery,
              child: Text('Chọn video từ Gallery'),
            ),
            ElevatedButton(
              onPressed: _recordVideoFromCamera,
              child: Text('Quay video từ Camera'),
            ),
          ],
        ),
      ),
    );
  }
}
