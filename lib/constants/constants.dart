import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyIcons {
  static const apple = 'assets/images/apple.png';
  static const google = 'assets/images/google.png';
  static const augmntx = 'assets/images/augmntx-appbar.png';
}

class MyThemes {
  static final textTheme = TextTheme(
    titleLarge: GoogleFonts.quicksand(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: GoogleFonts.quicksand(
      fontSize: 12,
      color: const Color.fromRGBO(82, 113, 255, 1),
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.quicksand(
      fontSize: 16,
      color: const Color.fromARGB(255, 29, 68, 57),
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: GoogleFonts.quicksand(
      fontSize: 14,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: GoogleFonts.quicksand(
      fontSize: 12,
      color: Colors.grey[700],
      fontWeight: FontWeight.w500,
    ),
    labelSmall: GoogleFonts.quicksand(
      fontSize: 12,
      color: Colors.white,
    ),
    labelLarge: GoogleFonts.quicksand(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    displayLarge: GoogleFonts.quicksand(
      fontSize: 25,
      color: MyColors.titleLargeColor,
      fontWeight: FontWeight.bold,
    ),
    displayMedium: GoogleFonts.quicksand(
      fontSize: 20,
      color: MyColors.textColor,
      fontWeight: FontWeight.w700,
    ),
    displaySmall: GoogleFonts.quicksand(
      fontSize: 20,
      color: MyColors.textColor,
      fontWeight: FontWeight.w500,
    ),
  );
}

class MyColors {
  static Color titleLargeColor = const Color(0xff11049a);
  static Color textColor = const Color(0xff60697B);
  static Color itemColor = const Color(0xffD3D3D3);
}

class Textstyle {
  static TextStyle displayLarge = GoogleFonts.quicksand(
    color: MyColors.titleLargeColor,
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );
  static TextStyle displayMedium = GoogleFonts.quicksand(
    color: MyColors.textColor,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static TextStyle displaySmall = GoogleFonts.quicksand(
    color: MyColors.textColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static TextStyle titleMedium = GoogleFonts.quicksand(
    color: Colors.white,
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );
  static TextStyle titleSmall = GoogleFonts.quicksand(
    color: MyColors.itemColor,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}



InputDecoration otpInput = const InputDecoration(
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blue, width: 2.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
  ),
);

class ConstantValues {
  static const String testing = 'https://repo.ashwinsrivastava.com/api/';
  static const String pushing = 'https://augmntx.com/api/';
  static const String apiLink = pushing;
  static const String join = "https://augmntx.com/join";

}
class Assets {
  static const String insurance = 'assets/svg/insurance.svg';
  static const String shield = 'assets/svg/shield.svg';
  static const String levels = 'assets/svg/levels.svg';
  static const String analytics = 'assets/svg/analytics.svg';
  static const String checklist = 'assets/svg/check-list.svg';
  static const String agenda = 'assets/svg/agenda.svg';
  static const String certificate = 'assets/svg/certificate.svg';
}
