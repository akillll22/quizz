import 'package:flutter/material.dart';
import 'quiz_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final List<Map<String, dynamic>> categories = const [
    {
      'title': 'Pengetahuan Umum',
      'apiId': 9,
      'color': Colors.blue,
    },
    {
      'title': 'Ilmu Komputer',
      'apiId': 18,
      'color': Colors.green,
    },
    {
      'title': 'Matematika',
      'apiId': 19,
      'color': Colors.red,
    },
  ];

  void _showSettingsDialog(BuildContext context, String title, int id) {
    int selectedAmount = 5;
    String selectedDifficulty = 'easy';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Pengaturan Kuis'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<int>(
                    value: selectedAmount,
                    decoration: const InputDecoration(labelText: 'Jumlah Soal'),
                    items: [5, 10, 15]
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text('$e Soal'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedAmount = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedDifficulty,
                    decoration:
                        const InputDecoration(labelText: 'Tingkat Kesulitan'),
                    items: ['easy', 'medium', 'hard']
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedDifficulty = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QuizPage(
                          categoryName: title,
                          categoryId: id,
                          amount: selectedAmount,
                          difficulty: selectedDifficulty,
                        ),
                      ),
                    );
                  },
                  child: const Text('Mulai Kuis'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
                onPressed: () => _showSettingsDialog(
                  context,
                  category['title'],
                  category['apiId'],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: category['color'],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
