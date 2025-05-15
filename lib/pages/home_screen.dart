import 'package:firebase_cihuy/models/todo_models.dart';
import 'package:firebase_cihuy/services/firebase_services.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BarangService _barangService = BarangService();
  List<BarangUnik> daftarBarang = [];

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchBarang();
  }

  Future<void> fetchBarang() async {
    final data = await _barangService.getBarang();
    setState(() => daftarBarang = data);
  }

  void tambahBarang() async {
    final barang = BarangUnik(
      id: '',
      nama: _namaController.text,
      deskripsi: _deskripsiController.text,
      harga: int.tryParse(_hargaController.text) ?? 0,
    );
    await _barangService.addBarang(barang);
    _namaController.clear();
    _deskripsiController.clear();
    _hargaController.clear();
    fetchBarang();
  }

  void hapusBarang(String id) async {
    await _barangService.deleteBarang(id);
    fetchBarang();
  }

  void editBarang(BarangUnik barang) {
    _namaController.text = barang.nama;
    _deskripsiController.text = barang.deskripsi;
    _hargaController.text = barang.harga.toString();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Barang'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _namaController, decoration: const InputDecoration(labelText: 'Nama')),
            TextField(controller: _deskripsiController, decoration: const InputDecoration(labelText: 'Deskripsi')),
            TextField(controller: _hargaController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Harga')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final update = BarangUnik(
                id: barang.id,
                nama: _namaController.text,
                deskripsi: _deskripsiController.text,
                harga: int.tryParse(_hargaController.text) ?? 0,
              );
              await _barangService.updateBarang(update);
              Navigator.pop(context);
              fetchBarang();
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barang Unik & Ekstrem')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(controller: _namaController, decoration: const InputDecoration(labelText: 'Nama')),
                TextField(controller: _deskripsiController, decoration: const InputDecoration(labelText: 'Deskripsi')),
                TextField(controller: _hargaController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Harga')),
                ElevatedButton(onPressed: tambahBarang, child: const Text('Tambah')),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: daftarBarang.length,
              itemBuilder: (_, index) {
                final barang = daftarBarang[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(barang.nama),
                    subtitle: Text('${barang.deskripsi}\nRp ${barang.harga}'),
                    isThreeLine: true,
                    trailing: Wrap(
                      children: [
                        IconButton(icon: const Icon(Icons.edit), onPressed: () => editBarang(barang)),
                        IconButton(icon: const Icon(Icons.delete), onPressed: () => hapusBarang(barang.id)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
