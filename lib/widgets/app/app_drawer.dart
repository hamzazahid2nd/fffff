import 'dart:convert';
import 'package:augmntx/provider/skills_provider.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/web_view.dart';
import '/screens/contact/about_us_screen.dart';
import '/screens/contact/contact_us_screen.dart';
import '/screens/contact/corporate_page.dart';
import '/screens/profile/profile_screen.dart';
import '../../screens/auth/auth_screen.dart';
import '/provider/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final prefsFuture = SharedPreferences.getInstance();
    return FutureBuilder(
        future: prefsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final prefs = snapshot.data as SharedPreferences;
            final userData = prefs.getString('userData');
            final userName =
                userData != null ? json.decode(userData)['name'] : '';
           final firstName = userName.split(' ')[0];
            return Drawer(
              backgroundColor: Colors.blueGrey[900],
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 50),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'AugmntX',
                              style: GoogleFonts.quicksand(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.06),
                                shape: const OvalBorder(),
                              ),
                              alignment: Alignment.topCenter,
                              child: IconButton(
                                onPressed: () {
                                  Scaffold.of(context).closeDrawer();
                                },
                                icon: const Icon(
                                  FeatherIcons.x,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                     if (userName?.isNotEmpty == true)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              'Hi, $firstName',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                      TextButton(
                        onPressed: () {
                          Provider.of<SkillsProvider>(context, listen: false)
                              .clearSkillList();
                          Navigator.of(context)
                              .pushReplacementNamed(ProfileScreen.routeName);
                          Scaffold.of(context).closeDrawer();
                        },
                        child: Text(
                          'Find dev',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            WebViewScreen.routeName,
                            arguments: {
                              'url': 'https://augmntx.com/remote-jobs'
                            },
                          );
                          Scaffold.of(context).closeDrawer();
                        },
                        child: Text(
                          'Remote Jobs',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            WebViewScreen.routeName,
                            arguments: {'url': 'https://augmntx.com/join'},
                          );
                          Scaffold.of(context).closeDrawer();
                        },
                        child: Text(
                          'Apply as Vendor',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(ContactUsScreen.routeName);
                          Scaffold.of(context).closeDrawer();
                        },
                        child: Text(
                          'Contact us',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(CorporatePage.routeName);
                          Scaffold.of(context).closeDrawer();
                        },
                        child: Text(
                          'Corporate Information',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(AboutUsPage.routeName);
                          Scaffold.of(context).closeDrawer();
                        },
                        child: Text(
                          'About us',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setBool('skipAuthentication', false);

                          if (auth.isAuth) {
                            auth.logout();
                            Navigator.of(context)
                                .pushReplacementNamed(AuthScreen.routeName);
                            Scaffold.of(context).closeDrawer();
                          } else {
                            Navigator.of(context).pushNamed(
                              AuthScreen.routeName,
                              arguments: {
                                "Pushed": true,
                              },
                            );
                          }
                          Scaffold.of(context).closeDrawer();
                        },
                        child: Text(
                          auth.isAuth ? 'Logout' : 'Login',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }
}
