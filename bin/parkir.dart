import 'package:pm_tugas_04_4242550005/kendaraan.dart';

void main() {
  final DateTime sekarang = DateTime.now();
  // Simulasi: kendaraan sudah masuk 2,5 jam lalu (dihitung 3 jam).
  final DateTime masuk = sekarang.subtract(
    const Duration(hours: 2, minutes: 30),
  );

  // Satu List berisi berbagai jenis kendaraan (polimorfisme).
  final List<Kendaraan> daftar = [
    Motor('BK 1234 AB', masuk),
    Mobil('BK 88 UN', masuk),
    MobilMember('BK 7 MIPA', masuk),
  ];

  for (final k in daftar) {
    print('$k: Rp${k.tarifPerJam}/jam, bayar Rp${k.biaya(sekarang)}');
  }
}
