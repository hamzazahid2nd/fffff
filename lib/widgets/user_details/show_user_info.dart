import 'package:flutter/material.dart';

import '../../model/profile.dart';

class ShowUserInfo extends StatelessWidget {
  const ShowUserInfo({super.key, required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Wrap(
                children: [
                  Transform.translate(
                    offset: const Offset(0, -4), 
                    child: SelectableText(
                      '${profile.lastName} ${profile.firstName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SelectableText(
                    profile.uniqueId,
                    style: const TextStyle(
                      fontWeight: FontWeight.w100,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Active',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SelectableText(
          '${profile.primaryTitle} in ${profile.city}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 10),
        SelectableText(
          profile.bio,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
