import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<String> _rawHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('quiz_history') ?? [];

    setState(() {
      _rawHistory = data.reversed.toList(); // tampilkan terbaru di atas
    });
  }

  Future<void> _deleteItem(int index) async {
    final prefs = await SharedPreferences.getInstance();

    final realIndex =
        _rawHistory.length - 1 - index; // karena kita balik tampilannya

    _rawHistory.removeAt(index);
    await prefs.setStringList('quiz_history', _rawHistory.reversed.toList());

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Riwayat berhasil dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parsed =
        _rawHistory.map((e) => json.decode(e) as Map<String, dynamic>).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Kuis',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: parsed.isEmpty
          ? const Center(child: Text('Belum ada kuis yang dikerjakan.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: parsed.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = parsed[index];
                final time = DateTime.parse(item['time']).toLocal();

                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    title: Text(
                      item['category'].toString().toUpperCase(),
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${item['score']} dari ${item['total']} soal\n${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _deleteItem(index),
                      tooltip: 'Hapus riwayat ini',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
