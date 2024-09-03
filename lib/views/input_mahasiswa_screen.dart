import 'package:flutter/material.dart';
import '../database/database_helpers.dart';
import '../models/Mahasiswa.dart';

class InputMahasiswaScreen extends StatefulWidget {
  final Mahasiswa? mahasiswa;

  InputMahasiswaScreen({this.mahasiswa});

  @override
  _InputMahasiswaScreenState createState() => _InputMahasiswaScreenState();
}

class _InputMahasiswaScreenState extends State<InputMahasiswaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _ttlController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    if (widget.mahasiswa != null) {
      _namaController.text = widget.mahasiswa!.nama;
      _ttlController.text = widget.mahasiswa!.ttl;
      _alamatController.text = widget.mahasiswa!.alamat;
      _nomorController.text = widget.mahasiswa!.id.toString();
      _selectedDate = DateTime.tryParse(widget.mahasiswa!.ttl);
      _selectedGender = widget.mahasiswa!.jenisKelamin;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _ttlController.text = "${picked.toLocal()}".split(' ')[0]; // Format date to yyyy-mm-dd
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mahasiswa == null ? 'Input Data Mahasiswa' : 'Update Data Mahasiswa'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(
                      controller: _nomorController,
                      label: 'Nomor',
                      hint: 'Masukkan NIM',
                      icon: Icons.numbers,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    _buildTextField(
                      controller: _namaController,
                      label: 'Nama',
                      hint: 'Masukkan nama',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: _buildTextField(
                          controller: _ttlController,
                          label: 'TTL',
                          hint: '',
                          icon: Icons.calendar_today,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'TTL tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: InputDecoration(
                          labelText: 'Jenis Kelamin',
                          prefixIcon: Icon(Icons.person_outline, color: Colors.blueAccent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                        ),
                        items: [
                          DropdownMenuItem(value: 'Laki-Laki', child: Text('Laki-Laki')),
                          DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Jenis Kelamin tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    _buildTextField(
                      controller: _alamatController,
                      label: 'Alamat',
                      hint: 'Masukkan alamat',
                      icon: Icons.home,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final newMahasiswa = Mahasiswa(
                            id: widget.mahasiswa == null ? int.tryParse(_nomorController.text) : widget.mahasiswa!.id,
                            nama: _namaController.text,
                            ttl: _ttlController.text,
                            jenisKelamin: _selectedGender ?? '',
                            alamat: _alamatController.text,
                          );

                          try {
                            if (widget.mahasiswa == null) {
                              await DatabaseHelper().insertMahasiswa(newMahasiswa);
                            } else {
                              await DatabaseHelper().updateMahasiswa(newMahasiswa);
                            }
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(e.toString()),
                              ),
                            );
                          }
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 15, horizontal: 24.0)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        )),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.blueAccent.withOpacity(0.8);
                            }
                            return null;
                          },
                        ),
                      ),
                      child: Text(
                        widget.mahasiswa == null ? 'Simpan' : 'Update',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        ),
        validator: validator,
      ),
    );
  }
}
