import 'package:augmntx/widgets/app/app_drawer.dart';
import 'package:augmntx/widgets/app/footerCard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '/components/custom_components.dart';
import '/constants/constants.dart';
import '/handlers/state_handler.dart';

class CorporatePage extends StatefulWidget {
  const CorporatePage({super.key});
  static const routeName = '/corporate-page';

  @override
  State<CorporatePage> createState() => _CorporatePageState();
}

class _CorporatePageState extends State<CorporatePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    final appBarState = Provider.of<StateHandler>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!appBarState.isCorporateScreenScrollingDown) {
          appBarState.setCorporateScreenAppbarAndScrollState(
            appBarState: false,
            scrollState: true,
          );
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (appBarState.isCorporateScreenScrollingDown) {
          appBarState.setCorporateScreenAppbarAndScrollState(
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
          children: [
            Consumer<StateHandler>(
              builder: (context, state, child) => CustomComponents.showAppBar(
                show: state.showCorporateScreenAppbar,
                showActionButton: true,
                showLeadingButton: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Corporate Information',
                    style: Textstyle.displayLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'AugmntX',
                    style: Textstyle.displayMedium,
                  ),
                  Text(
                    'Labor omnia vincit',
                    style: Textstyle.displaySmall,
                  ),
                  Text(
                    'Matching high talent with the best companies worldwide.',
                    style: Textstyle.displaySmall,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Registered Address',
                    style: Textstyle.displayMedium,
                  ),
                  Text(
                    'No 34, Marudamalai Kuounder Layout, Ramakrishna Puram, Sakthi Road, Ganapathy post, Coimbatore - 641006',
                    style: Textstyle.displaySmall,
                  ),
                  Text(
                    'Business Hours, Monday to Friday - 9:00 am to 5:00 pm',
                    style: Textstyle.displaySmall,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Goods & Service Tax Number',
                    style: Textstyle.displayMedium,
                  ),
                  Text(
                    'AugmntX is a product of SuperLabs.',
                    style: Textstyle.displaySmall,
                  ),
                  Text(
                    'GSTIN : 33AEJFS9410F1Z2',
                    style: Textstyle.displaySmall,
                  ),
                  Text(
                    'PAN : AEJFS9410F',
                    style: Textstyle.displaySmall,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Banking Information',
                    style: Textstyle.displayMedium,
                  ),
                  Text(
                    'Bank: Yes Bank',
                    style: Textstyle.displaySmall,
                  ),
                  Text(
                    'Account Name: SuperLabs',
                    style: Textstyle.displaySmall,
                  ),
                  Text(
                    'Account Number: 073063300000892',
                    style: Textstyle.displaySmall,
                  ),
                  Text(
                    'Account Type: Current Account',
                    style: Textstyle.displaySmall,
                  ),
                  Text(
                    'IFSC Code: YESB0000036',
                    style: Textstyle.displaySmall,
                  ),
                  Text(
                    'Branch: Avanashi Road',
                    style: Textstyle.displaySmall,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Departmental Contact',
                    style: Textstyle.displayMedium,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Vendors',
                    style: Textstyle.displayMedium,
                  ),
                  Text(
                    'For collaborations & work opportunities with AugmntX.',
                    style: Textstyle.displaySmall,
                  ),
                  InkWell(
                    onTap: () => CustomComponents.sendEmailToAugmntx(
                      'vendor@augmntx.com',
                    ),
                    child: Text(
                      'vendor@augmntx.com',
                      style: GoogleFonts.quicksand(
                          color: const Color(0xff0B0080),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Sales',
                    style: Textstyle.displayMedium,
                  ),
                  Text(
                    'For sales inquires, or to know more about our services.',
                    style: Textstyle.displaySmall,
                  ),
                  InkWell(
                    onTap: () => CustomComponents.sendEmailToAugmntx(
                        'sales@augmntx.com'),
                    child: Text(
                      'sales@augmntx.com',
                      style: GoogleFonts.quicksand(
                        color: const Color(0xff0B0080),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Careers',
                    style: Textstyle.displayMedium,
                  ),
                  Text(
                    'Be a part of the team that builds the future of hiring.',
                    style: Textstyle.displaySmall,
                  ),
                  InkWell(
                    onTap: () =>
                        CustomComponents.sendEmailToAugmntx('hr@augmntx.com'),
                    child: Text(
                      'hr@augmntx.com',
                      style: GoogleFonts.quicksand(
                        color: const Color(0xff0B0080),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Press',
                    style: Textstyle.displayMedium,
                  ),
                  Text(
                    'Public relations',
                    style: Textstyle.displaySmall,
                  ),
                  InkWell(
                    onTap: () =>
                        CustomComponents.sendEmailToAugmntx('pr@augmntx.com'),
                    child: Text(
                      'pr@augmntx.com',
                      style: GoogleFonts.quicksand(
                        color: const Color(0xff0B0080),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Grievance & complaints',
                    style: Textstyle.displayMedium,
                  ),
                  Text(
                    "If you're unhappy with any of AugmntX's services",
                    style: Textstyle.displaySmall,
                  ),
                  InkWell(
                    onTap: () => CustomComponents.sendEmailToAugmntx(
                        'grievance@augmntx.com'),
                    child: Text(
                      'grievance@augmntx.com',
                      style: GoogleFonts.quicksand(
                        color: const Color(0xff0B0080),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'General inquires',
                    style: Textstyle.displayMedium,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              "If you have any other queries please reach us at: ",
                          style: Textstyle.displaySmall,
                        ),
                        TextSpan(
                          text: '637-490-9636',
                          style: GoogleFonts.quicksand(
                            color: const Color(0xff0B0080),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () =>
                                CustomComponents.contactAugmntxThroughSMS(
                                    '637 490 9636'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Monday to Friday: 10:00 AM to 6:00 PM.',
                    style: Textstyle.displaySmall,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const FooterPage(),
          ],
        ),
      ),
    );
  }
}
