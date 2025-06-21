import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizPage extends StatefulWidget {
  final String category;
  const QuizPage({super.key, required this.category});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<dynamic> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final path = 'assets/questions/${widget.category}.json';
    final data = await rootBundle.loadString(path);
    final decoded = json.decode(data);
    setState(() {
      _questions = decoded;
      _isLoading = false;
    });
  }

  void _answer(String selected) {
    final correct = _questions[_currentIndex]['answer'];
    if (selected == correct) {
      _score++;
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _showResult();
    }
  }

  Future<void> _saveResult() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList('quiz_history') ?? [];

    final now = DateTime.now().toIso8601String();
    final newData = json.encode({
      'category': widget.category,
      'score': _score,
      'total': _questions.length,
      'time': now,
    });

    print('MENYIMPAN RIWAYAT: $newData');

    existing.add(newData);
    await prefs.setStringList('quiz_history', existing);
  }

  void _showResult() async {
    await _saveResult();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Kuis Selesai'),
        content: Text('Skor kamu: $_score / ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Kembali'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final current = _questions[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuis'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Soal ${_currentIndex + 1} dari ${_questions.length}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Text(
              current['question'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...(current['options'] as List<dynamic>).map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => _answer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: Text(option),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
