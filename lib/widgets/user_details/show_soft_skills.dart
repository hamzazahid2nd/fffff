import 'package:flutter/material.dart';

class ShowSoftSkills extends StatelessWidget {
  final List<dynamic> softSkills;

  const ShowSoftSkills({super.key, required this.softSkills});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle_outline),
              SizedBox(width: 5),
              Text(
                'Soft Skills',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: softSkills.map((skill) {
              return SkillPill(skill: skill);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class SkillPill extends StatelessWidget {
  final String skill;

  const SkillPill({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color.fromRGBO(211, 211, 211, 1),
        ),
      ),
      child: SelectableText(
        skill,
        style: const TextStyle(
          fontSize: 13.0,
          color: Colors.black,
        ),
      ),
    );
  }
}
