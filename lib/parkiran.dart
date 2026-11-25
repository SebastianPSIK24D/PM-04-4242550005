import 'dart:async';

import 'kendaraan.dart';

/// Lama simulasi palang otomatis membuka.
const Duration waktuPalang = Duration(milliseconds: 300);

/// Dilempar saat kendaraan masuk ke parkiran yang sudah penuh.
class ParkirPenuh implements Exception {
  const ParkirPenuh(this.kapasitas);

  final int kapasitas;

  @override
  String toString() => 'Parkiran penuh (kapasitas $kapasitas)';
}

/// Dilempar saat plat yang akan keluar tidak ada di parkiran.
class KendaraanTidakDitemukan implements Exception {
  const KendaraanTidakDitemukan(this.plat);

  final String plat;

  @override
  String toString() => 'Kendaraan $plat tidak ada di parkiran';
}

class Parkiran {
  Parkiran(this.kapasitas);

  final int kapasitas;

  // Data privat hanya diubah lewat masuk() dan keluar().
  final List<Kendaraan> _terparkir = [];
  final StreamController<String> _kejadian =
      StreamController<String>.broadcast();
  int _pendapatan = 0;

  /// Jumlah slot yang masih kosong.
  int get sisa => kapasitas - _terparkir.length;

  /// Total uang yang sudah diterima.
  int get pendapatan => _pendapatan;

  /// Aliran kejadian masuk/keluar untuk layar pos jaga.
  Stream<String> get kejadian => _kejadian.stream;

  /// Memasukkan [kendaraan]. Melempar [ParkirPenuh] jika tidak ada slot.
  Future<void> masuk(Kendaraan kendaraan) async {
    if (sisa <= 0) throw ParkirPenuh(kapasitas);

    // Slot langsung dipesan agar dua kendaraan tidak berebut slot terakhir.
    _terparkir.add(kendaraan);
    await Future<void>.delayed(waktuPalang); // simulasi palang membuka
    _kejadian.add('MASUK $kendaraan (sisa $sisa)');
  }

  /// Mengeluarkan kendaraan berplat [plat] dan mengembalikan biayanya.
  /// [waktuKeluar] bisa diisi untuk simulasi; bawaannya waktu sekarang.
  Future<int> keluar(String plat, {DateTime? waktuKeluar}) async {
    final int indeks = _terparkir.indexWhere((k) => k.plat == plat);
    if (indeks == -1) throw KendaraanTidakDitemukan(plat);

    final Kendaraan kendaraan = _terparkir.removeAt(indeks);
    await Future<void>.delayed(waktuPalang); // simulasi palang membuka

    final int bayar = kendaraan.biaya(waktuKeluar ?? DateTime.now());
    _pendapatan += bayar;
    _kejadian.add('KELUAR $kendaraan bayar Rp$bayar');
    return bayar;
  }

  /// Menutup aliran kejadian setelah semua selesai.
  Future<void> tutup() => _kejadian.close();
}
