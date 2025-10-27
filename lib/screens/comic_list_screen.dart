// lib/screens/comic_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/comic_provider.dart';
import 'comic_form_screen.dart';
import 'comic_detail_screen.dart';

class ComicListScreen extends StatelessWidget {
  const ComicListScreen({super.key});

  String _validateImageUrl(String? url) {
    if (url == null || url.isEmpty || !url.startsWith('http')) {
      return 'https://upload.wikimedia.org/wikipedia/commons/6/65/No-Image-Placeholder.svg';
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final comicProv = context.watch<ComicProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FA),
      appBar: AppBar(
        title: const Text(
          '📚 Comic Book',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFB6C1),
        elevation: 4,
      ),
      body: comicProv.items.isEmpty
          ? const Center(
              child: Text(
                'ยังไม่มีข้อมูลการ์ตูน\nกดปุ่ม ➕ เพื่อเพิ่มรายการใหม่',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: comicProv.items.length,
              itemBuilder: (context, index) {
                final comic = comicProv.items[index];
                final imageUrl = _validateImageUrl(comic.imageUrl);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ComicDetailScreen(comic: comic),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 200,
                              color: const Color(0xFFFFE5EC),
                              child: const Center(
                                child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(comic.title,
                                  style: const TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('${comic.author} • ${comic.genre}',
                                  style: const TextStyle(color: Colors.black54)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.info_outline, color: Colors.blueAccent),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ComicDetailScreen(comic: comic),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit_rounded, color: Colors.pinkAccent),
                                    tooltip: 'แก้ไขข้อมูล',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ComicFormScreen(comic: comic),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                    tooltip: 'ลบข้อมูล',
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text('ยืนยันการลบ'),
                                          content: Text('คุณต้องการลบ "${comic.title}" หรือไม่?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('ยกเลิก'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text('ลบ'),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        
                                        await context.read<ComicProvider>().deleteComic(comic.id!);
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('ลบ "${comic.title}" สำเร็จ'),
                                            backgroundColor: Colors.redAccent,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFB2EBF2),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ComicFormScreen()),
          );
        },
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}


