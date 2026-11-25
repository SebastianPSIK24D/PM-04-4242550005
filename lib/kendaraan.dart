// Tarif per jam (rupiah) tiap jenis kendaraan.
const int tarifMotor = 2000;
const int tarifMobil = 5000;
const int tarifTruk = 10000;

// Diskon kendaraan berlangganan (50%).
const double diskonMember = 0.5;

const int detikPerJam = 3600;

/// Kendaraan umum: plat, waktu masuk, dan cara menghitung biaya.
abstract class Kendaraan {
  Kendaraan(this.plat, this.waktuMasuk);

  final String plat;
  final DateTime waktuMasuk;

  /// Nama jenis kendaraan, diisi oleh subclass.
  String get jenis;

  /// Tarif per jam, diisi oleh subclass.
  int get tarifPerJam;

  /// Biaya parkir sampai [keluar]: dibulatkan ke atas per jam, minimal 1 jam.
  int biaya(DateTime keluar) {
    final int detik = keluar.difference(waktuMasuk).inSeconds;
    final int jam = (detik / detikPerJam).ceil();
    return (jam < 1 ? 1 : jam) * tarifPerJam;
  }

  @override
  String toString() => '$jenis $plat';
}

class Motor extends Kendaraan {
  Motor(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Motor';

  @override
  int get tarifPerJam => tarifMotor;
}

class Mobil extends Kendaraan {
  Mobil(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Mobil';

  @override
  int get tarifPerJam => tarifMobil;
}

class Truk extends Kendaraan {
  Truk(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Truk';

  @override
  int get tarifPerJam => tarifTruk;
}

/// Mixin memberi diskon pada biaya kendaraan yang memakainya.
mixin Berlangganan on Kendaraan {
  @override
  int biaya(DateTime keluar) {
    return (super.biaya(keluar) * (1 - diskonMember)).round();
  }
}

/// Mobil berlangganan: tarif Mobil, biaya didiskon oleh [Berlangganan].
class MobilMember extends Mobil with Berlangganan {
  MobilMember(super.plat, super.waktuMasuk);

  @override
  String get jenis => 'Mobil (member)';
}
