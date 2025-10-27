// lib/screens/comic_form_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/comic_book.dart';
import '../providers/comic_provider.dart';

class ComicFormScreen extends StatefulWidget {
  final ComicBook? comic;
  const ComicFormScreen({super.key, this.comic});

  @override
  State<ComicFormScreen> createState() => _ComicFormScreenState();
}

class _ComicFormScreenState extends State<ComicFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _authorCtrl = TextEditingController();
  final _genreCtrl = TextEditingController();
  final _yearCtrl = TextEditingController();
  final _summaryCtrl = TextEditingController();
  final _imageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.comic != null) {
      _titleCtrl.text = widget.comic!.title;
      _authorCtrl.text = widget.comic!.author;
      _genreCtrl.text = widget.comic!.genre;
      _yearCtrl.text = widget.comic!.year.toString();
      _summaryCtrl.text = widget.comic!.summary ?? '';
      _imageCtrl.text = widget.comic!.imageUrl ?? '';
    }
  }

  Widget _thaiField(
    String label,
    TextEditingController ctrl, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFFFF7FA),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFFB6C1), width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      inputFormatters: [
        // ✅ อนุญาต / : และ _ เพื่อให้พิมพ์ URL ได้
        FilteringTextInputFormatter.allow(
          RegExp(r'[ก-๙a-zA-Z0-9\s.,!?()"\-/:_]+'),
        ),
      ],

      validator: (v) => (v == null || v.isEmpty) ? 'กรอก$label' : null,
      maxLines: maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.comic != null;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FA),
      appBar: AppBar(
        title: Text(
          isEdit ? 'แก้ไขข้อมูลการ์ตูน' : 'เพิ่มการ์ตูนใหม่',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFFB6C1),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _thaiField('ชื่อเรื่อง', _titleCtrl),
              const SizedBox(height: 12),
              _thaiField('ผู้แต่ง', _authorCtrl),
              const SizedBox(height: 12),
              _thaiField('ประเภท', _genreCtrl),
              const SizedBox(height: 12),
              _thaiField('ปีที่พิมพ์', _yearCtrl),
              const SizedBox(height: 12),
              _thaiField('เรื่องย่อ', _summaryCtrl, maxLines: 3),
              const SizedBox(height: 12),
              _thaiField('ลิงก์รูปภาพ', _imageCtrl),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: Icon(
                  isEdit ? Icons.edit : Icons.save,
                  color: Colors.white,
                ),
                label: Text(
                  isEdit ? 'บันทึกการแก้ไข' : 'บันทึกข้อมูล',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB2EBF2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final comic = ComicBook(
                      id: widget.comic?.id,
                      title: _titleCtrl.text,
                      author: _authorCtrl.text,
                      genre: _genreCtrl.text,
                      year: int.tryParse(_yearCtrl.text) ?? 0,
                      price: 0,
                      rating: 0,
                      summary: _summaryCtrl.text,
                      imageUrl: _imageCtrl.text,
                    );

                    if (isEdit) {
                      await context.read<ComicProvider>().updateComic(comic);
                    } else {
                      await context.read<ComicProvider>().addComic(comic);
                    }
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isEdit
                              ? 'อัปเดตข้อมูลสำเร็จ! 💖'
                              : 'บันทึกข้อมูลสำเร็จ! 💖',
                        ),
                        backgroundColor: Colors.pinkAccent.shade100,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
