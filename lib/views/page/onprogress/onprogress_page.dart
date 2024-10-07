import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/onprogress_model.dart';
import '../../../services/onprogress_services.dart';
import 'add_project_onprogress.dart';
import 'detail_onprogress.dart';

class OnprogressPage extends StatefulWidget {
  const OnprogressPage({super.key});

  @override
  State<OnprogressPage> createState() => _OnprogressPageState();
}

class _OnprogressPageState extends State<OnprogressPage> {
  List<OnProgress> onprogress = [];
  bool isLoading = true;

  // Tambahkan formatter untuk format mata uang
  final _currencyFormatter = NumberFormat.currency(locale: 'id', symbol: 'Rp');

  Future<void> fetchProject() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await ApiServiceOnProgress.fetchProject();
      setState(() {
        onprogress = result;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching onprogress: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Method untuk menghitung total fee dari semua project
  double getTotalFee() {
    return onprogress.fold(0.0, (total, project) => total + project.fee);
  }

  // Method untuk menghapus proyek
  Future<void> deleteProject(String id, int index) async {
    try {
      final deletedProject = onprogress[index];
      setState(() {
        onprogress.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Project berhasil dihapus"),
          action: SnackBarAction(
            label: "Urungkan",
            onPressed: () {
              setState(() {
                onprogress.insert(index, deletedProject);
              });
            },
          ),
        ),
      );

      await Future.delayed(const Duration(seconds: 3));

      if (!onprogress.contains(deletedProject)) {
        await ApiServiceOnProgress.deleteProject(id);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal menghapus project: $e")),
      );
    }
  }

  // Method untuk menyegarkan data saat tarik ke atas
  Future<void> _onRefresh() async {
    await fetchProject();
  }

  @override
  void initState() {
    super.initState();
    fetchProject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              color: const Color.fromARGB(
                  255, 59, 36, 163), // Background saat loading
              child: const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: Container(
                      color: const Color.fromARGB(255, 59, 36, 163),
                      child: ListView.builder(
                        itemCount: onprogress.length,
                        itemBuilder: (context, index) {
                          final project = onprogress[index];
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
                                deleteProject(project.id, index);
                              },
                              child: Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  title: Text(
                                    project.projectname,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  subtitle: Text(
                                    _currencyFormatter.format(project
                                        .fee), // Format fee sebagai mata uang
                                  ),
                                  onTap: () {
                                    showProjectDetail(context, project);
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Bagian untuk menampilkan total fee di bottom
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
                  MaterialPageRoute(builder: (context) => const AddProject()),
                );

                if (result == true) {
                  fetchProject();
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
