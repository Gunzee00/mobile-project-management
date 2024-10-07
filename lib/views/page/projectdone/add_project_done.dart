import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_management/models/projectdone_model.dart';
import 'package:project_management/services/projectdone_services.dart';

class AddProjectDone extends StatefulWidget {
  const AddProjectDone({super.key});

  @override
  State<AddProjectDone> createState() => _AddProjectDoneState();
}

class _AddProjectDoneState extends State<AddProjectDone> {
  final TextEditingController namaProjekController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  DateTime? _selectedDate;
  bool isLoading = false;

  Future<void> _addProjectDone(BuildContext context) async {
    final String namaProjek = namaProjekController.text;
    final String fee = feeController.text;

    // Validasi input
    if (namaProjek.isEmpty || fee.isEmpty || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi semua field")),
      );
      return;
    }

    // Validasi fee harus berupa angka
    if (double.tryParse(fee) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fee harus berupa angka")),
      );
      return;
    }

    setState(() {
      isLoading = true; // Set loading state di sini
    });

    // Tampilkan loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Format tanggal ke string
      final String formattedDate =
          DateFormat('yyyy-MM-dd').format(_selectedDate!);

      // Konversi fee dari String ke double
      double parsedFee = double.parse(fee);

      ProjectDone newProject = ProjectDone(
        id: '',
        nama_projek: namaProjek,
        fee: parsedFee, // Ganti fee menjadi parsedFee
        tanggal: formattedDate, // Simpan tanggal dalam bentuk string
      );

      await ApiServiceProjectDone.addProjectDone(newProject);

      Navigator.of(context).pop(); // Tutup dialog loading

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Project berhasil ditambahkan")),
      );

      // Kirim sinyal ke Homepage bahwa data telah di-update
      Navigator.of(context).pop(true);
    } catch (e) {
      Navigator.of(context).pop(); // Tutup dialog loading

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menambahkan project: $e")),
      );
    } finally {
      setState(() {
        isLoading = false; // Pastikan loading state di-reset
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 59, 36, 163),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 8.0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tambah Project",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: namaProjekController,
                    decoration: const InputDecoration(
                      labelText: "Nama Project",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: feeController,
                    decoration: const InputDecoration(
                      labelText: "Fee",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Deadline",
                        border: OutlineInputBorder(),
                      ),
                      child: Text(
                        _selectedDate == null
                            ? "Pilih Tanggal"
                            : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed:
                          isLoading ? null : () => _addProjectDone(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
                              "Tambah",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
