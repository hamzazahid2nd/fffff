import 'dart:convert';
import 'package:augmntx/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/web_view.dart';
import 'package:provider/provider.dart';
import 'package:augmntx/provider/skills_provider.dart';
import '../../provider/auth_provider.dart';
import '../contact/about_us_screen.dart';
import '../contact/contact_us_screen.dart';
import '../contact/corporate_page.dart';
import 'package:augmntx/components/centered_btn_with_icon.dart';
import 'package:augmntx/screens/auth/auth_screen.dart';

class profilePropertiesScreen extends StatefulWidget {
  const profilePropertiesScreen({super.key});
  static const routeName = '/profile_properties_screen.dart';
  @override
  State<profilePropertiesScreen> createState() =>
      _profilePropertiesScreenState();
}

class _profilePropertiesScreenState extends State<profilePropertiesScreen> {
  String userName = 'loading';
  bool isLoggedIn = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserName();
  }

  void getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('userData');
    if (userDataString != null) {
      final userData = jsonDecode(userDataString);
      final String name = userData['name'];
      setState(() {
        userName = name;
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: isLoggedIn
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.center,
                  children: isLoggedIn
                      ? [
                          const CircleAvatar(
                            radius: 40,
                            child: Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            ),
                            backgroundColor: Color.fromRGBO(82, 113, 255, 1),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900),
                                ),
                                Text("Flutter Developer"),
                              ],
                            ),
                          )
                        ]
                      : [
                          Column(
                            children: [
                              Text(
                                "Welcome!",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Please log in to access your profile.",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed(AuthScreen.routeName);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Color.fromRGBO(
                                          82, 113, 255, 1)), // Background color
                                ),
                                child: Text(
                                  "Log In",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
                child: ListView(
              children: [
                ListTextTile('Find dev', () {
                  Provider.of<SkillsProvider>(context, listen: false)
                      .clearSkillList();
                  Navigator.of(context)
                      .pushReplacementNamed(ProfileScreen.routeName);
                }),
                ListTextTile('Remote Jobs', () {
                  Navigator.of(context).pushNamed(
                    WebViewScreen.routeName,
                    arguments: {'url': 'https://augmntx.com/remote-jobs'},
                  );
                }),
                ListTextTile('Apply as Vendor', () {
                  Navigator.of(context).pushNamed(
                    WebViewScreen.routeName,
                    arguments: {'url': 'https://augmntx.com/join'},
                  );
                }),
                ListTextTile('Contact us', () {
                  Navigator.of(context).pushNamed(ContactUsScreen.routeName);
                }),
                ListTextTile('Corporate Information', () {
                  Navigator.of(context).pushNamed(CorporatePage.routeName);
                }),
                ListTextTile('About us', () {
                  Navigator.of(context).pushNamed(AboutUsPage.routeName);
                }),
              ],
            )),
            Visibility(
              visible: isLoggedIn!,
              child: CenteredBtnWithIcon("logout", () {
                auth.logout();
                Navigator.of(context)
                    .pushReplacementNamed(AuthScreen.routeName);
              }, Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}

class ListTextTile extends StatelessWidget {
  String title;
  Function function;
  bool isCentered = false;
  ListTextTile(this.title, this.function);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.navigate_next_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
