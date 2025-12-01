class Hewan {
  String nama;
  double berat;

  Hewan(this.nama, this.berat);

  String makan(double porsi) {
    berat += porsi; 
    return "$nama makan sebanyak $porsi gram."; 
  }
}

class Kucing extends Hewan {
  String warnaBulu;
  String pesan = "";

  Kucing(String nama, double berat, this.warnaBulu) : super(nama, berat);

  @override
  String makan(double porsi) {
    pesan = "Kucing $nama berwarna $warnaBulu yang sedang makan sebanyak $porsi gram.";
    super.makan(porsi);
    return pesan; 
  }
}