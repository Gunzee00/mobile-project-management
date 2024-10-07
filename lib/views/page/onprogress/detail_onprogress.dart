import 'package:flutter/material.dart';

import '../../../models/onprogress_model.dart';
 
class ProjectDetailDialog extends StatelessWidget {
  final OnProgress project;

  const ProjectDetailDialog({Key? key, required this.project})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(project.projectname),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Deskripsi: ${project.desc}"),
          Text("Fee: ${project.fee}"),
          Text("Deadline: ${project.deadline}"), // Tampilkan string deadline
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Tutup"),
        ),
      ],
    );
  }
}

void showProjectDetail(BuildContext context, OnProgress project) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ProjectDetailDialog(project: project);
    },
  );
}
