import 'package:augmntx/widgets/app/app_drawer.dart';
import 'package:augmntx/widgets/app/footerCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '/components/custom_components.dart';
import '/constants/constants.dart';
import '/screens/contact/corporate_page.dart';
import '../../handlers/state_handler.dart';

class ContactUsScreen extends StatefulWidget {
  static const routeName = '/contact-us-screen';
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    final appBarState = Provider.of<StateHandler>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!appBarState.isContactUsScreenScrollingDown) {
          appBarState.setContactUsScreenAppbarAndScrollState(
            appBarState: false,
            scrollState: true,
          );
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (appBarState.isContactUsScreenScrollingDown) {
          appBarState.setContactUsScreenAppbarAndScrollState(
            appBarState: true,
            scrollState: false,
          );
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<StateHandler>(
              builder: (context, state, child) => CustomComponents.showAppBar(
                show: state.showContactUsScreenAppbar,
                showActionButton: true,
                showLeadingButton: true,
              ),
            ),
            const Gap(40),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact AugmntX',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff11049a),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    'We appreciate your interest in augmntX. Please select from the option below ',
                    style: Theme.of(context)
                        .textTheme
                        .displaySmall
                        ?.copyWith(letterSpacing: 1),
                  ),
                  const Gap(20),
                  const Text(
                    'General Inquiries',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff11049a),
                    ),
                  ),
                  const Gap(20),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () =>
                                CustomComponents.sendEmailToAugmntx(
                                  'cr@augmntx.com',
                                ),
                            child: const Text(
                              'cr@augmntx.com',
                              style: TextStyle(
                                  color: Color(0xff0B0080), fontSize: 19),
                            )),
                        TextButton(
                          onPressed: () =>
                              CustomComponents.contactAugmntxThroughSMS(
                            '+91 982 004 5154',
                          ),
                          child: const Text(
                            '(+91) 982 004 5154',
                            style: TextStyle(
                              color: Color(0xff0B0080),
                            ),
                          ),
                        ),
                        const Gap(10),
                        Text(
                          'Corporate Information',
                          style: TextStyle(
                              color: MyColors.textColor,
                              fontSize: 19,
                              fontWeight: FontWeight.w700),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(CorporatePage.routeName);
                          },
                          child: const Text(
                            'Visit Page',
                            style: TextStyle(
                              color: Color(0xff0B0080),
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Gap(30),
            const FooterPage(),
          ],
        ),
      ),
    );
  }
}
