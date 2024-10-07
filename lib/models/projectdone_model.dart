class ProjectDone {
  String id;
  String nama_projek;
  double fee; // Pastikan ini adalah double
  String tanggal;

  ProjectDone({
    required this.id,
    required this.nama_projek,
    required this.fee,
    required this.tanggal,
  });

  factory ProjectDone.fromJson(Map<String, dynamic> json) => ProjectDone(
        id: json["id"],
        nama_projek: json["nama_projek"],
        fee: (json["fee"] is int)
            ? json["fee"].toDouble()
            : json["fee"], // Ubah ke double jika int
        tanggal: json["tanggal"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama_projek": nama_projek,
        "fee": fee,
        "tanggal": tanggal,
      };
}
