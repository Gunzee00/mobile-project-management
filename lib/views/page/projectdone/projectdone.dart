import 'package:flutter/material.dart';
import 'package:project_management/models/projectdone_model.dart';
import 'package:project_management/services/projectdone_services.dart';
import 'package:project_management/views/page/projectdone/add_project_done.dart';
import 'package:project_management/views/page/projectdone/detail_projectdone.dart';
import 'package:intl/intl.dart';

class ProjectDonePage extends StatefulWidget {
  const ProjectDonePage({super.key});

  @override
  State<ProjectDonePage> createState() => _ProjectDonePageState();
}

class _ProjectDonePageState extends State<ProjectDonePage> {
  List<ProjectDone> projectdone = [];
  bool isLoading = true;

  // Tambahkan formatter untuk format mata uang
  final _currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp');

  Future<void> fetchProjectDone() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiServiceProjectDone.fetchProjectDone();
      setState(() {
        projectdone = result;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching projectdone: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Method untuk menghitung total fee dari semua project
  double getTotalFee() {
    return projectdone.fold(0.0, (total, project) => total + project.fee);
  }

  // Method untuk menghapus proyek
  Future<void> deleteProjectDone(String id, int index) async {
    try {
      final deletedProject = projectdone[index];
      setState(() {
        projectdone.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Project berhasil dihapus"),
          action: SnackBarAction(
            label: "Urungkan",
            onPressed: () {
              setState(() {
                projectdone.insert(index, deletedProject);
              });
            },
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 3));

      if (!projectdone.contains(deletedProject)) {
        await ApiServiceProjectDone.deleteProjectDone(id);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus project: $e")),
      );
    }
  }

  // Method untuk menyegarkan data saat tarik ke atas
  Future<void> _onRefresh() async {
    await fetchProjectDone();
  }

  @override
  void initState() {
    super.initState();
    fetchProjectDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              color: const Color.fromARGB(
                  255, 59, 36, 163), // Atur background saat loading
              child: const Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              )),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: Container(
                color: const Color.fromARGB(255, 59, 36, 163),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: projectdone.length,
                        itemBuilder: (context, index) {
                          final project = projectdone[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Dismissible(
                              key: Key(project.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              onDismissed: (direction) {
                                deleteProjectDone(project.id, index);
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  title: Text(
                                    project.nama_projek,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    _currencyFormatter.format(project.fee),
                                  ),
                                  onTap: () {
                                    // Navigasi ke Detail Project
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => DetailProjectDone(project: project),
                                    //   ),
                                    // );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Menampilkan total fee di bagian bawah
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Fee",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            _currencyFormatter.format(getTotalFee()),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                bottom: 80.0, left: 310), // Menambahkan padding ke bawah
            child: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddProjectDone()),
                );

                if (result == true) {
                  fetchProjectDone();
                }
              },
              child: const Icon(Icons.add),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
