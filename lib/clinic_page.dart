import 'package:flutter/material.dart';
import 'data/clinic_examine.dart';
import 'main.dart';

class ExaminationListPage extends StatelessWidget {
  final ClinicExamine examine;

  const ExaminationListPage({Key? key, required this.examine})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(examine.title)),
      body: ListView.builder(
        itemCount: examine.children.length,
        itemBuilder: (context, index) {
          final item = examine.children[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(item.title),
              subtitle:
                  item.description.isNotEmpty ? Text(item.description) : null,
              trailing:
                  item.children.isNotEmpty
                      ? const Icon(Icons.chevron_right)
                      : null,
              onTap: () {
                if (item.children.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExaminationListPage(examine: item),
                    ),
                  );
                } else {
                  // Show details for leaf node
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: Text(item.title),
                          content: Text(item.description),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('关闭'),
                            ),
                          ],
                        ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
