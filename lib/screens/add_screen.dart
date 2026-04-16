import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddInmateScreen extends StatefulWidget {
  const AddInmateScreen({super.key});

  @override
  State<AddInmateScreen> createState() => _AddInmateScreenState();
}

class _AddInmateScreenState extends State<AddInmateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _umurController = TextEditingController();
  final _kasusController = TextEditingController();

  String _jenisKelamin = 'Laki-laki';
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref('narapidana');
  bool _isLoading = false;

  void _simpanData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _dbRef.push().set({
          'nama': _namaController.text,
          'jenis_kelamin': _jenisKelamin,
          'umur': _umurController.text,
          'kasus': _kasusController.text,
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data berhasil ditambahkan!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Narapidana')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _jenisKelamin,
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
                items: ['Laki-laki', 'Perempuan'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _jenisKelamin = newValue!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _umurController,
                decoration: const InputDecoration(labelText: 'Umur'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Umur tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kasusController,
                decoration: const InputDecoration(labelText: 'Kasus'),
                validator: (value) =>
                    value!.isEmpty ? 'Kasus tidak boleh kosong' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _simpanData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'SIMPAN DATA',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
