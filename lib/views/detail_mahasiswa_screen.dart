import 'package:flutter/material.dart';
import '../models/Mahasiswa.dart';

class DetailMahasiswaScreen extends StatelessWidget {
  final Mahasiswa mahasiswa;

  DetailMahasiswaScreen({required this.mahasiswa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Mahasiswa'),
        backgroundColor: Colors.blueAccent, // Warna background app bar
        elevation: 0, // Menghilangkan shadow
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailCard('Nomor', mahasiswa.id.toString()),
            _buildDetailCard('Nama', mahasiswa.nama),
            _buildDetailCard('TTL', mahasiswa.ttl),
            _buildDetailCard('Jenis Kelamin', mahasiswa.jenisKelamin),
            _buildDetailCard('Alamat', mahasiswa.alamat),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Colors.blueAccent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 0,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent, // Text color for title
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black87, // Text color for subtitle
          ),
        ),
        tileColor: Colors.grey[50], // Background color for ListTile
      ),
    );
  }
}
