// lib/screens/comic_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/comic_book.dart';

class ComicDetailScreen extends StatelessWidget {
  final ComicBook comic;
  const ComicDetailScreen({super.key, required this.comic});

  // ✅ ฟังก์ชันตรวจสอบและแก้ลิงก์ภาพอัตโนมัติ
  String _validateImageUrl(String? url) {
    if (url == null || url.isEmpty) {
      return 'https://upload.wikimedia.org/wikipedia/commons/6/65/No-Image-Placeholder.svg';
    }

    // ถ้าเผลอพิมพ์เป็น httpsimg2 หรือ httpimg2 ให้เติม https:// ให้อัตโนมัติ
    if (url.startsWith('httpsimg2') || url.startsWith('httpimg2')) {
      return url.replaceFirst('https', 'https://');
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _validateImageUrl(comic.imageUrl);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: Colors.grey.shade200),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imageUrl,
                    width: 220,
                    height: 320,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 220,
                      height: 320,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  comic.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  comic.author,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0x33FFF0F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    comic.summary ?? 'ไม่มีเรื่องย่อ',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}





