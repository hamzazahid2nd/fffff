import 'package:flutter/material.dart';

class ShowIndustries extends StatelessWidget {
  final List<dynamic> industries;

  const ShowIndustries({super.key, required this.industries});

  Widget industry(String industryName, bool isLast) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            industryName,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.underline,
            ),
          ),
          if (!isLast)
            const Text(',',
                style: TextStyle(fontSize: 16, color: Colors.black)),
          if (!isLast) const SizedBox(width: 3),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        const Text(
          'Industries : ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        for (int i = 0; i < industries.length; i++)
          industry(industries[i], i == industries.length - 1),
      ],
    );
  }
}
