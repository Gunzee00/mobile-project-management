import 'dart:convert';

// Fungsi untuk mengonversi dari JSON ke objek OnProgress
OnProgress projectFromJson(String str) => OnProgress.fromJson(json.decode(str));

// Fungsi untuk mengonversi dari objek OnProgress ke JSON
String projectToJson(OnProgress data) => json.encode(data.toJson());

class OnProgress {
  String id;
  String projectname;
  String desc;
  double fee; // Ganti ke double jika ingin melakukan perhitungan
  String deadline;

  OnProgress({
    required this.id,
    required this.projectname,
    required this.desc,
    required this.fee,
    required this.deadline,
  });

  // Konstruktor untuk mengonversi dari JSON
  factory OnProgress.fromJson(Map<String, dynamic> json) => OnProgress(
        id: json["id"],
        projectname: json["projectname"],
        desc: json["desc"],
        fee: double.tryParse(json["fee"].toString()) ?? 0.0, // Pastikan fee adalah double
        deadline: json["deadline"],
      );

  // Konstruktor untuk mengonversi ke JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "projectname": projectname,
        "desc": desc,
        "fee": fee.toString(), // Konversi kembali ke string saat mengonversi ke JSON
        "deadline": deadline,
      };
}
