import 'dart:async';
import 'package:augmntx/components/web_view.dart';
import 'package:augmntx/provider/filter_provider.dart';
import 'package:augmntx/provider/filterstate_provider.dart';
import 'package:augmntx/screens/profile/profile_properties_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/provider/skills_provider.dart';
import '/screens/contact/about_us_screen.dart';
import '/screens/contact/contact_us_screen.dart';
import '/screens/contact/corporate_page.dart';
import '/handlers/state_handler.dart';
import '/constants/constants.dart';
import 'components/loading_animation.dart';
import 'provider/auth_provider.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/profile/profile_detail_screen.dart';
import 'provider/profile_info_provider.dart';
import 'screens/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool skipAuthentication = prefs.getBool('skipAuthentication') ?? false;
  runApp(
    MainApp(
      skipAuthentication: skipAuthentication,
    ),
  );
}

class MainApp extends StatelessWidget {
  MainApp({required this.skipAuthentication});
  final bool skipAuthentication;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProfileInfoProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (context) => StateHandler(),
        ),
        ChangeNotifierProvider(
          create: (context) => SkillsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => FilterState(),
        ),
        ChangeNotifierProvider(
          create: (context) => FilterProvider(''),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, authData, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.grey,
            ),
            textTheme: MyThemes.textTheme,
          ),
          home: (authData.isAuth || skipAuthentication)
              ? const ProfileScreen()
              : FutureBuilder(
                  future: authData.tryAutoLogin(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const LoadingAnimation();
                    } else {
                      if (skipAuthentication) {
                        return const ProfileScreen();
                      } else {
                        return AuthScreen();
                      }
                    }
                  },
                ),
          routes: {
            ProfileScreen.routeName: (context) => const ProfileScreen(),
            ProfileDetailScreen.routeName: (context) =>
                const ProfileDetailScreen(),
            AuthScreen.routeName: (context) => AuthScreen(),
            ContactUsScreen.routeName: (context) => const ContactUsScreen(),
            CorporatePage.routeName: (context) => const CorporatePage(),
            AboutUsPage.routeName: (context) => const AboutUsPage(),
            WebViewScreen.routeName: (context) => const WebViewScreen(),
            profilePropertiesScreen.routeName: (context) => const profilePropertiesScreen(),
          },
        ),
      ),
    );
  }
}
