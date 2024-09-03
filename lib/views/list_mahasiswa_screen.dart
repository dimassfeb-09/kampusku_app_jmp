import 'package:flutter/material.dart';
import '../database/database_helpers.dart';
import '../models/Mahasiswa.dart';
import 'detail_mahasiswa_screen.dart';
import 'input_mahasiswa_screen.dart';

class ListMahasiswaScreen extends StatefulWidget {
  @override
  _ListMahasiswaScreenState createState() => _ListMahasiswaScreenState();
}

class _ListMahasiswaScreenState extends State<ListMahasiswaScreen> {
  late Future<List<Mahasiswa>> _mahasiswaList;

  @override
  void initState() {
    super.initState();
    _refreshMahasiswaList();
  }

  void _refreshMahasiswaList() {
    setState(() {
      _mahasiswaList = DatabaseHelper().getMahasiswaList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Mahasiswa'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: FutureBuilder<List<Mahasiswa>>(
        future: _mahasiswaList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data mahasiswa'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final mahasiswa = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      mahasiswa.nama.isNotEmpty ? mahasiswa.nama : 'Tidak ada nama',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(
                      mahasiswa.ttl.isNotEmpty ? mahasiswa.ttl : 'Tidak ada TTL',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    trailing: Icon(Icons.more_vert, color: Colors.blueAccent),
                    onTap: () {
                      _showDialog(context, mahasiswa);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showDialog(BuildContext context, Mahasiswa mahasiswa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pilihan'),
        content: Text('Apa yang ingin Anda lakukan dengan data mahasiswa ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailMahasiswaScreen(mahasiswa: mahasiswa),
                ),
              );
            },
            child: Text('Lihat Data'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InputMahasiswaScreen(mahasiswa: mahasiswa),
                ),
              ).then((_) => _refreshMahasiswaList());
            },
            child: Text('Update Data'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _confirmDelete(context, mahasiswa);
            },
            child: Text('Hapus Data'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, Mahasiswa mahasiswa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus data mahasiswa ini?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              DatabaseHelper().deleteMahasiswa(mahasiswa.id!);
              _refreshMahasiswaList();
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Batal'),
          ),
        ],
      ),
    );
  }
}
