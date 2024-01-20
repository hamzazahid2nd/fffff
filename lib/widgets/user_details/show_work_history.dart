import 'package:flutter/material.dart';

class ShowWorkHistory extends StatelessWidget {
  const ShowWorkHistory({super.key, required this.workHistory});

  final List<dynamic> workHistory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.work_outline_outlined),
            SizedBox(width: 5),
            SelectableText(
              'Work History',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ...workHistory.map(
          (work) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                '${work['title']} ${work['company']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (work['fromTo'] != "")
                SelectableText(
                  '${work['fromTo']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              if (work['description'] != "") ...[
                const SizedBox(height: 5),
                SelectableText(
                  'Description',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.grey[900],
                  ),
                ),
                SelectableText(
                  work['description'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
