import 'package:pm_tugas_04_4242550005/kendaraan.dart';
import 'package:pm_tugas_04_4242550005/parkiran.dart';

Future<void> main() async {
  final Parkiran parkiran = Parkiran(2);
  parkiran.kejadian.listen(print); // layar pos jaga

  final Motor motor = Motor(
    'BK 1234 AB',
    DateTime.now().subtract(const Duration(hours: 2, minutes: 30)),
  );

  await parkiran.masuk(motor);
  await parkiran.keluar(motor.plat);
  print('Pendapatan: Rp${parkiran.pendapatan}');
  await parkiran.tutup();
}
