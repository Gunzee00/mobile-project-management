import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/onprogress_model.dart';
import '../../../services/onprogress_services.dart';

class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  _AddProjectState createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  final TextEditingController projectNameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController feeController = TextEditingController();
  DateTime? _selectedDate;
  bool isLoading = false;

  Future<void> _addProject(BuildContext context) async {
    final String projectName = projectNameController.text;
    final String desc = descController.text;
    final String feeText = feeController.text;

    // Ubah fee menjadi double
    final double? fee = double.tryParse(feeText);

    if (projectName.isEmpty ||
        desc.isEmpty ||
        fee == null ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi semua field dengan benar")),
      );
      return;
    }

    setState(() {
      isLoading = true;
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

      OnProgress newProject = OnProgress(
        id: '',
        projectname: projectName,
        desc: desc,
        fee: fee, // Fee sekarang menggunakan double
        deadline: formattedDate, // Simpan tanggal dalam bentuk string
      );

      await ApiServiceOnProgress.addProject(newProject);

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
        isLoading = false;
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
                    controller: projectNameController,
                    decoration: const InputDecoration(
                      labelText: "Nama Project",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: "Deskripsi",
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
                      onPressed: isLoading ? null : () => _addProject(context),
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
