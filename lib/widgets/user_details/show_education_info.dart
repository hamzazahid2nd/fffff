import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class ShowEducationInfo extends StatelessWidget {
  const ShowEducationInfo({super.key, required this.education});

  final List<dynamic> education;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(LineIcons.university),
            SizedBox(width: 5),
            SelectableText(
              'Education',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ...education.map(
          (edu) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                edu['degree'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              SelectableText(
                edu['uni'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 5),
              SelectableText(
                edu['fromTo'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
