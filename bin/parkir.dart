import 'package:pm_tugas_04_4242550005/kendaraan.dart';
import 'package:pm_tugas_04_4242550005/parkiran.dart';

Future<void> main() async {
  final DateTime sekarang = DateTime.now();
  // Simulasi semua kendaraan masuk 2,5 jam lalu (dihitung 3 jam)
  final DateTime masuk = sekarang.subtract(
    const Duration(hours: 2, minutes: 30),
  );

  final Parkiran parkiran = Parkiran(3);
  parkiran.kejadian.listen(print); // layar pos jaga

  // Polimorfisme satu list berisi berbagai jenis kendaraan.
  final List<Kendaraan> antrean = [
    Motor('BK 1234 AB', masuk),
    Mobil('BK 88 UN', masuk),
    MobilMember('BK 7 MIPA', masuk),
    Truk('BK 9999 XY', masuk), // kapasitas sudah penuh, akan ditolak
  ];

  final List<Kendaraan> diparkir = [];
  for (final k in antrean) {
    try {
      await parkiran.masuk(k);
      diparkir.add(k);
    } on ParkirPenuh catch (e) {
      print('Ditolak: $e');
    }
  }

  for (final k in diparkir) {
    await parkiran.keluar(k.plat, waktuKeluar: sekarang);
  }

  print('Pendapatan: Rp${parkiran.pendapatan}');
  await parkiran.tutup();
}
