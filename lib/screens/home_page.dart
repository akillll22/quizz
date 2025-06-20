import 'package:flutter/material.dart';
import 'quiz_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'title': 'Pengetahuan Umum',
      'color': Colors.blue,
    },
    {
      'title': 'Bahasa Indonesia',
      'color': Colors.green,
    },
    {
      'title': 'Matematika',
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Kategori Kuis'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            color: category['color'].withOpacity(0.1),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: Icon(Icons.quiz, color: category['color']),
              title: Text(
                category['title'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: category['color'],
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  String fileName = category['title']
                      .toString()
                      .toLowerCase()
                      .replaceAll(' ', '_');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizPage(category: fileName),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: category['color'],
                ),
                child: const Text('Mulai'),
              ),
            ),
          );
        },
      ),
    );
  }
}
