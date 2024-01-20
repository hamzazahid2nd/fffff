import 'package:augmntx/components/web_view.dart';
import 'package:augmntx/screens/auth/auth_screen.dart';
import 'package:augmntx/widgets/app/app_drawer.dart';
import 'package:augmntx/widgets/app/footerCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:getwidget/getwidget.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:video_player/video_player.dart';
import '/components/custom_components.dart';
import '/components/loading_animation.dart';
import '/components/video_player.dart';
import '/constants/constants.dart';
import '/handlers/state_handler.dart';
import '/widgets/app/about_card.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});
  static const routeName = '/about-us-screen';

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final _scrollController = ScrollController();

  final List<String> imageList = [
    "https://augmntx.com/assets/img/photos/careers.jpg",
    "https://augmntx.com/assets/img/photos/our-story.jpg",
    "https://augmntx.com/assets/img/photos/why.jpg",
    "https://augmntx.com/assets/img/photos/contact-us.jpg",
  ];

  final List<String> stringList = [
    'Carrers',
    'Our Story',
    'Why AugmntX',
    'Contact Us'
  ];

  final List<String> urlList = [
    'https://augmntx.com/careers',
    'https://augmntx.com/our-story',
    'https://augmntx.com/why',
    'https://augmntx.com/contact-us',
  ];

  int titleindex = 0;

  @override
  void initState() {
    super.initState();
    final appBarState = Provider.of<StateHandler>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!appBarState.isAboutUsScreenScrollingDown) {
          appBarState.setAboutUsScreenAppbarAndScrollState(
            appBarState: false,
            scrollState: true,
          );
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (appBarState.isAboutUsScreenScrollingDown) {
          appBarState.setAboutUsScreenAppbarAndScrollState(
            appBarState: true,
            scrollState: false,
          );
        }
      }
    });
  }
String videoAssetlink = 'assets/videoclip.mp4';
  @override
  Widget build(BuildContext context) {
    final stringmap = stringList.asMap();
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Consumer<StateHandler>(
            builder: (context, state, child) => CustomComponents.showAppBar(
              show: state.showAboutUsScreenAppbar,
              showActionButton: true,
              showLeadingButton: true,
            ),
          ),
          Expanded(
            child: ListView(
              controller: _scrollController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GradientText(
                            'Developers',
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 28,
                            ),
                            colors: const [
                              Color(0xff343f52),
                              Color(0xffcb507f),
                            ],
                          ),
                          Text(
                            ' for a global',
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 28,
                              color: const Color(0xff343F52),
                            ),
                          )
                        ],
                      ),
                      Text(
                        'community',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 28,
                          color: const Color(0xff343F52),
                        ),
                      ),
                      const Gap(20),
                      Text(
                        "AugmntX's mission is to connect exceptional developers from around the world to top companies.",
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  letterSpacing: 1,
                                  height: 1.5,
                                ),
                      ),
                      const Gap(40),
                      InkWell(
                        onTap: () {
                          String devurl = ConstantValues.join;
                          Navigator.of(context)
                              .pushNamed(WebViewScreen.routeName, arguments: {
                            "url": devurl,
                          });
                        },
                        child: Container(
                          height: 60,
                          width: 160,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                              colors: [Color(0xFF523da3), Color(0xFFd4517c)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Text(
                            'Apply as dev',
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                      const Gap(60),
                      Image.asset(
                        'assets/images/3d6.png',
                        height: 330,
                        width: 330,
                        fit: BoxFit.cover,
                      ),
                      const Gap(40),
                      AboutCard(
                        alignment: CrossAxisAlignment.start,
                        color: const Color(0xfffef3e4),
                        svg: Assets.insurance,
                        subject: '1. People first, Always. Practice empathy',
                      ),
                      const Gap(20),
                      AboutCard(
                        alignment: CrossAxisAlignment.start,
                        color: const Color(0xfffae6e7),
                        svg: Assets.shield,
                        subject: '2. Hope for the best, prepare for the worst',
                      ),
                      const Gap(20),
                      AboutCard(
                        alignment: CrossAxisAlignment.start,
                        color: const Color(0xffeaf3ef),
                        svg: Assets.levels,
                        subject: '3. If you are learning, you can never fail',
                      ),
                      const Gap(20),
                      AboutCard(
                        alignment: CrossAxisAlignment.start,
                        color: const Color(0xffe5f4fd),
                        svg: Assets.analytics,
                        subject:
                            '4. Make a big impact, with as little as possible',
                      ),
                      const Gap(60),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WHY WE STARTED',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const Gap(20),
                          Text(
                            'Software outsourcing is broken.',
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 40,
                              color: const Color(0xff343F52),
                            ),
                          ),
                          const Gap(30),
                          Text(
                            "Outsourcing is full of risks. You may not know your developers, you may have concerns about the quality of the product, you may have communication difficulties when managing your project, and you may feel unsupported in ensuring the project is running smoothly.\n\nAugmntX is here to change this. With our cutting edge platform and an Outsourcing Strategist by your side, AugmntX will ensure that outsourcing is both effective and painless.",
                            style: GoogleFonts.manrope(
                              fontSize: 18,
                              color: MyColors.textColor,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const Gap(40),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AuthScreen(
                                        hireValue: true,
                                      )));
                            },
                            child: Container(
                              height: 60,
                              width: 160,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                color: Color(0xff343f52),
                              ),
                              child: Text(
                                'Hire Your Team',
                                style: GoogleFonts.manrope(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Gap(60),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xfff3fafe),
                  child: Column(
                    children: [
                      const Gap(20),
                      SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: VideoPlayers(
                            videoPlayerController: VideoPlayerController.asset(
                                videoAssetlink),
                            looping: false,
                            autoplay: true),
                      ),
                      const Gap(50),
                      Text(
                        'OUR PROCESS',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const Gap(30),
                      Text(
                        'AugmntX is\npreventative, not\nreactive',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 32,
                          color: const Color(0xff343F52),
                        ),
                      ),
                      const Gap(50),
                      SvgPicture.asset(
                        Assets.checklist,
                        height: 52,
                        width: 52,
                        fit: BoxFit.cover,
                      ),
                      const Gap(20),
                      Text(
                        '1. Biweekly Audits',
                        style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff343f52),
                            height: 1.5),
                      ),
                      const Gap(20),
                      Text(
                          "By default, we'll audit your project every 2 weeks. This audit ensures that best practices are being used at all times. More frequent audits are available upon request.",
                          style: Theme.of(context).textTheme.displaySmall),
                      const Gap(50),
                      SvgPicture.asset(
                        Assets.agenda,
                        height: 52,
                        width: 52,
                        fit: BoxFit.cover,
                      ),
                      const Gap(20),
                      Text(
                        '2. Tailored Strategies',
                        style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff343f52),
                            height: 1.5),
                      ),
                      const Gap(20),
                      Text(
                          "Every project is unique, the development strategy should be equally unique. Based on best practices, we tailor a development strategy specifically for your project.",
                          style: Theme.of(context).textTheme.displaySmall),
                      const Gap(50),
                      SvgPicture.asset(
                        Assets.certificate,
                        height: 52,
                        width: 52,
                        fit: BoxFit.cover,
                      ),
                      const Gap(20),
                      Text(
                        '3. Quality Performance',
                        style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff343f52),
                            height: 1.5),
                      ),
                      const Gap(20),
                      Text(
                          "We work with our partners on a weekly basis to ensure high quality performance. We do this through regular feedback sessions, constant training and workshops. ",
                          style: Theme.of(context).textTheme.displaySmall),
                      const Gap(50),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Gap(30),
                      SizedBox(
                        height: 300,
                        child: Image.network(
                          'https://augmntx.com/assets/img/illustrations/i7.png',
                          fit: BoxFit.fitWidth,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: LoadingAnimation(),
                            );
                          },
                        ),
                      ),
                      const Gap(30),
                      Text(
                        'The Gold Standard in Outsourcing.',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 32,
                          color: const Color(0xff343F52),
                        ),
                      ),
                      const Gap(20),
                      Text(
                        'AugmntX uses a vigorous vetting process, a custom-made project management platform and a strict development process to deliver a seamless and consistent outsourcing experience. We provide outsourcing infrastructure for the modern company.\n\nA Selective Network of Outsourcing Partners.',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.blue,
                        ),
                        title: Text(
                          'Selecting the Top Devs.',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.blue,
                        ),
                        title: Text(
                          'Technical Review.',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.blue,
                        ),
                        title: Text(
                          'Interpersonal Interviews.',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.blue,
                        ),
                        title: Text(
                          'Consistency Check.',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ),
                      const Gap(40),
                      Text(
                        'JOIN OUR COMMUNITY',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const Gap(20),
                      Text(
                        'AugmntX is an trusted community for\n Developers. Join them now & be a part of our\nglobal network.',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 32,
                          color: const Color(0xff343F52),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(30),
                      ListTile(
                        title: Text(
                          '58+',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 48,
                            color: const Color(
                              0xff5271FF,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          'Projects',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                              fontSize: 20,
                              color: MyColors.textColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Gap(20),
                      ListTile(
                        title: Text(
                          '72+',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 48,
                            color: const Color(
                              0xff5271FF,
                            ),
                          ),
                        ),
                        subtitle: Text(
                          'Customers',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                              fontSize: 20,
                              color: MyColors.textColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Gap(20),
                      ListTile(
                        title: Text(
                          '2184+',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 48,
                            color: const Color(0xff5271FF),
                          ),
                        ),
                        subtitle: Text(
                          'Expert Devs',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                              fontSize: 20,
                              color: MyColors.textColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Gap(60),
                    ],
                  ),
                ),
                GFCarousel(
                  pagerSize: 10,
                  height: 300,
                  initialPage: 0,
                  autoPlay: true,
                  autoPlayCurve: Curves.easeIn,
                  autoPlayInterval: const Duration(seconds: 3),
                  activeDotBorder: Border.all(color: MyColors.itemColor),
                  activeIndicator: Colors.white,
                  passiveIndicator: MyColors.itemColor,
                  hasPagination: true,
                  items: imageList.map(
                    (url) {
                      return GestureDetector(
                        onTap: () {
                          /* ---------------------- navigate page to destination ---------------------- */
                          final urlIndex = urlList[titleindex];
                          Navigator.of(context)
                              .pushNamed(WebViewScreen.routeName, arguments: {
                            "url": urlIndex,
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                child: Image.network(url, loadingBuilder:
                                    (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: LoadingAnimation(),
                                  );
                                }),
                              ),
                              const Gap(20),
                              Text(
                                stringmap[titleindex].toString(),
                                style: GoogleFonts.manrope(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xff343f52),
                                    height: 1.5),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ).toList(),
                  onPageChanged: (index) {
                    setState(() {
                      titleindex = index;
                    });
                  },
                ),
                const FooterPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
