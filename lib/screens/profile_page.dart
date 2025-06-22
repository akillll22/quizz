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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/questions/fotoprofile.jpg'),
                backgroundColor: Colors.grey,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Nama: Mutawakkil Rohmatillah\n'
              'NPM: 2023020100028\n'
              'Prodi: Teknik Informatika\n'
              'Semester: 4\n'
              'Kampus: Universitas Islam Madura (UIM)\n'
              'Alamat: Pakamban Laok, Pragaan, Sumenep\n'
              'Motto: Lebih baik kalah, daripada menyerah\n'
              'Visi Misi: Memajukan peradaban',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
