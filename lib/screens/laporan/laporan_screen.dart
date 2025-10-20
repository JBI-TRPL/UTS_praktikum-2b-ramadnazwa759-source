import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pos_app/database/database_helper.dart';

class LaporanScreen extends StatelessWidget {
  const LaporanScreen({super.key});

  // Fungsi untuk mengambil data laporan harian
  Future<Map<String, dynamic>> _ambilDataLaporan() async {
  final db = DatabaseHelper.instance;
  final now = DateTime.now();
  final today = DateFormat('yyyy-MM-dd').format(now);

  final transaksiList = await db.getTransactions(); // digunakan untuk ambil semua transaksi didatabasenya

  final transaksiHariIni = transaksiList.where((trx) {
    final tanggal = DateFormat('yyyy-MM-dd').format(trx.transactionDate);
    return tanggal == today;
  }).toList();

  int totalPendapatan = 0;
  for (var trx in transaksiHariIni) {
    totalPendapatan += trx.totalAmount;
  }

  return {
    'totalTransaksi': transaksiHariIni.length,
    'totalPendapatan': totalPendapatan,
  };
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporan Harian')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _ambilDataLaporan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Jumlah Transaksi Hari Ini: ${data['totalTransaksi']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Total Pendapatan Hari Ini: Rp${data['totalPendapatan']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LaporanScreen()),
                    );
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Muat Ulang'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
