import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class ShowCertificationsInfo extends StatelessWidget {
  const ShowCertificationsInfo({super.key, required this.certifications});

  final List<dynamic> certifications;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(LineIcons.certificate),
            SizedBox(width: 5),
            Text(
              'Certifications',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...certifications.map(
          (cert) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cert['name'],
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 3),
            ],
          ),
        ),
      ],
    );
  }
}
