import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cihuy/models/todo_models.dart';


class BarangService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('barang_unik');

  Future<List<BarangUnik>> getBarang() async {
    final snapshot = await _ref.get();
    return snapshot.docs
        .map((doc) => BarangUnik.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> addBarang(BarangUnik barang) async {
    await _ref.add(barang.toMap());
  }

  Future<void> updateBarang(BarangUnik barang) async {
    await _ref.doc(barang.id).update(barang.toMap());
  }

  Future<void> deleteBarang(String id) async {
    await _ref.doc(id).delete();
  }
}
