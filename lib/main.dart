// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/comic_provider.dart';
import 'screens/comic_list_screen.dart';

void main() {
  runApp(const ComicApp());
}

class ComicApp extends StatelessWidget {
  const ComicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ComicProvider()..loadComics(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Comic Book App',
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFFFFB6C1), // 💗 ชมพูพาสเทล
          fontFamily: 'Kanit',
          useMaterial3: true,
        ),
        home: const ComicListScreen(),
      ),
    );
  }
}


