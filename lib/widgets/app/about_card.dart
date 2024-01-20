import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gap/gap.dart';

// ignore: must_be_immutable
class AboutCard extends StatelessWidget {
  AboutCard({
    super.key,
    required this.color,
    required this.svg,
    required this.subject,
    required this.alignment,
  });

  Color color;
  String subject;
  String svg;
  CrossAxisAlignment alignment = CrossAxisAlignment.start;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      height: 212,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: alignment,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svg,
            height: 52,
            width: 52,
            fit: BoxFit.contain,
          ),
          const Gap(20),
          Text(
            subject,
            style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xff343f52),
                height: 1.5),
          ),
        ],
      ),
    );
  }
}
