import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import '../../model/additional_details.dart';

class ShowTechSkillsWithExperience extends StatelessWidget {
  const ShowTechSkillsWithExperience({
    Key? key,
    required this.profileDetails,
  }) : super(key: key);

  final AdditionalDetails profileDetails;

  String cleanTechnology(String technology) {
    return technology
        .replaceAll(RegExp(r'^\s*[•◦●\d]+\s*|\.\s*$|\s*$'), '')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    Set<String> uniqueTechnologies = Set();
    uniqueTechnologies.addAll(
        profileDetails.skills.map((skill) => skill['name'] as String).toList());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(LineIcons.code),
            SizedBox(width: 5),
            Text(
              'Technical Skills',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ...profileDetails.skills.map((skill) {
          String formatSkill(Map<String, dynamic> skill) {
            if (skill['year'] == "0" && skill['month'] == "0") {
              return "< 1 Year";
            } else {
              String years =
                  skill['year'] != "0" ? '${skill['year']} years' : '';
              String months = skill['month'] != "0"
                  ? skill['year'] != "0"
                      ? ' & ${skill['month']} Months'
                      : '${skill['month']} Months'
                  : '';
              return '$years$months';
            }
          }

          final result = formatSkill(skill);

          return Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SelectableText(
                    skill['name'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Expanded(
                  child: SelectableText(
                    result,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  profileDetails.projects
                      .expand((project) =>
                          (project['technologies'] as String).split(','))
                      .map((technology) => cleanTechnology(technology))
                      .where((technology) {
                    bool isNewTechnology =
                        !uniqueTechnologies.contains(technology) &&
                            technology.isNotEmpty;
                    if (isNewTechnology) {
                      uniqueTechnologies.add(technology);
                    }
                    return isNewTechnology;
                  }).join(", "),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
