import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '/components/show_snackbar.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import '../../components/custom_components.dart';

class ShowProjects extends StatelessWidget {
  final List<dynamic> projects;
  const ShowProjects(this.projects, {super.key});

  void _launchURL(BuildContext context, Uri url) async {
    await launcher.canLaunchUrl(url).then((canUrlLaunch) {
      if (canUrlLaunch) {
        launcher.launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        ShowSnackBar(
          context: context,
          color: Colors.red,
          label: 'Cannot launch URL!',
        ).show();
      }
    });
  }

  Widget technology(String techName, bool isLast) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          techName,
          style: GoogleFonts.quicksand(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        if (!isLast)
          Text(',',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              )),
        if (!isLast) const SizedBox(width: 3),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.settings_outlined),
            SizedBox(width: 5),
            Text(
              'Projects',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ...projects.map((pr) {
          final List<String> technologyList =
              pr['technologies'].toString().split(',');
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SelectableText(
                            pr['title'],
                            style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.grey[900],
                            ),
                          ),
                        ),
                        if (pr['url'].toString().isNotEmpty)
                          CustomComponents.customTextButton(
                            label: 'Open Project URL',
                            width: 110,
                            icon: Icons.open_in_new,
                            iconColor: const Color.fromRGBO(82, 113, 255, 1),
                            iconSize: 15,
                            textStyle: Theme.of(context).textTheme.titleSmall!,
                            onPressed: () async {
                              final url = Uri.parse(pr['url']);
                              _launchURL(context, url);
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (pr['fromTo'].toString().trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SelectableText(
                    '${pr['fromTo']}',
                    style: GoogleFonts.quicksand(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      'Description',
                      style: GoogleFonts.quicksand(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.grey[900],
                      ),
                    ),
                    SelectableText(
                      pr['description'],
                      style: GoogleFonts.quicksand(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (pr['responsibilities'] != "") ...[
                      SelectableText(
                        'Roles & Responsibilities',
                        style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.grey[900],
                        ),
                      ),
                      SelectableText(
                        pr['responsibilities'],
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SelectableText(
                          'Technologies: ',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey[900],
                          ),
                        ),
                        for (int i = 0; i < technologyList.length; i++)
                          technology(
                            technologyList[i],
                            i == technologyList.length - 1,
                          )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SelectableText(
                          'Industry: ',
                          style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey[900],
                          ),
                        ),
                        SelectableText(
                          pr['industry'],
                          style: GoogleFonts.quicksand(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
}
