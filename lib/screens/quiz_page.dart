import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class QuizPage extends StatefulWidget {
  final String categoryName;
  final int categoryId;
  final int amount;
  final String difficulty;

  const QuizPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
    this.amount = 5,
    this.difficulty = 'easy',
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final url = Uri.parse(
      'https://opentdb.com/api.php?amount=${widget.amount}&category=${widget.categoryId}&difficulty=${widget.difficulty}&type=multiple',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['response_code'] != 0 || data['results'].isEmpty) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Soal Tidak Ditemukan'),
                content: const Text(
                    'Tidak ada soal untuk kategori atau tingkat kesulitan ini.\nCoba pengaturan lain.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
          return;
        }

        final List<Map<String, dynamic>> fetchedQuestions = [];

        for (var item in data['results']) {
          final options = [
            ...item['incorrect_answers'],
            item['correct_answer']
          ];
          options.shuffle(Random());

          fetchedQuestions.add({
            'question': Uri.decodeFull(item['question']),
            'options': options.map((e) => Uri.decodeFull(e)).toList(),
            'answer': Uri.decodeFull(item['correct_answer']),
          });
        }

        setState(() {
          _questions = fetchedQuestions;
          _isLoading = false;
        });
      } else {
        throw Exception('Status bukan 200');
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Koneksi Gagal'),
            content: const Text(
              'Gagal menghubungi API. Pastikan koneksi internet aktif dan coba lagi.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _answer(String selected) {
    final correct = _questions[_currentIndex]['answer'];
    if (selected == correct) _score++;

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
      'category': widget.categoryName,
      'score': _score,
      'total': _questions.length,
      'time': now,
    });

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
          ),
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
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.categoryName} (${widget.difficulty}) - ${widget.amount} soal',
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearPercentIndicator(
              lineHeight: 10.0,
              percent: progress,
              progressColor: Colors.deepPurple,
              backgroundColor: Colors.grey[300],
              barRadius: const Radius.circular(8),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Soal ${_currentIndex + 1}/${_questions.length}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Skor: $_score',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  current['question'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ...(current['options'] as List<String>).map(
              (option) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.deepPurple, width: 1.2),
                  ),
                  child: ListTile(
                    title: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    onTap: () => _answer(option),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
