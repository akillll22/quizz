import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pembuat'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/fotoprofile.jpg'),
                backgroundColor:
                    Colors.grey, // fallback warna jika gambar gagal
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Nama   : Mutawakkil Rohmatillah',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 12),
            Text('NPM    : 2023020100028', style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Text('Prodi  : Teknik Informatika', style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Text('Semester: 4', style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Text(
              'Kampus : Universitas Islam Madura (UIM)',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
