import 'package:augmntx/widgets/app/app_drawer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import '../../components/show_snackbar.dart';
import '../../handlers/state_handler.dart';
import '../../provider/auth_provider.dart';
import '../auth/auth_screen.dart';
import '/widgets/user_details/show_soft_skills.dart';
import '/widgets/user_details/show_industries.dart';
import '/widgets/user_details/show_projects.dart';
import '../../widgets/user_details/show_certifications_info.dart';
import '../../widgets/user_details/show_education_info.dart';
import '../../widgets/user_details/show_user_info.dart';
import '../../widgets/user_details/show_work_history.dart';
import '../../widgets/user_details/show_tech_skills.dart';
import '../../widgets/user_details/show_tech_skills_with_experience.dart';
import '/provider/profile_info_provider.dart';
import '../../components/custom_components.dart';
import '../../model/profile.dart';
import '../../components/loading_animation.dart';

class ProfileDetailScreen extends StatefulWidget {
  static const routeName = '/profile-detail-screen';
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  final _scrollController = ScrollController();

  List<Widget> space() {
    return [
      const SizedBox(height: 20),
      const Divider(
        color: Colors.grey,
        thickness: 0.5,
      ),
      const SizedBox(height: 20),
    ];
  }

  void _showModal(BuildContext context, String lastName, String name) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (BuildContext context) {
        return Consumer<StateHandler>(
          builder: (context, StateHandler, _) {
            return SingleChildScrollView(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
                height: StateHandler.height,
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom * 0.1),
                child: AuthScreen(
                  hireValue: true,
                  firstName: lastName,
                  lastName: name,
                ),
              ),
            );
          },
        );
      },
    );
  }

  void shareProfile(Profile profile) {
    final text =
        '${profile.firstName} ${profile.lastName} is a ${profile.primaryTitle} based in ${profile.city}, '
        '${profile.country} with over ${profile.experience} years of experience. view ${profile.firstName} '
        '${profile.lastName} profile on AugmntX: ${generateProfileLink(profile)}';
    Share.share(text, subject: 'Profile Details');
  }

  String generateProfileLink(Profile profile) {
    return 'https://augmntx.com/profile/${profile.uniqueId}';
  }

  Hero showUserPhoto(Profile profile) {
    return Hero(
      tag: profile.uniqueId,
      child: Center(
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: CachedNetworkImage(
            imageUrl: profile.userPhoto,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) =>
                CustomComponents.progressiveDotsLoading,
            errorWidget: (context, url, error) => Center(
                child: Image.network(
              "https://augmntx.com/assets/img/noimage.jpg",
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            )),
          ),
        ),
      ),
    );
  }

  String addDashToUrl(String url) {
    String dashedUrl = url.replaceAll(' ', '-');
    return dashedUrl;
  }

  @override
  void initState() {
    final appBarState = Provider.of<StateHandler>(context, listen: false);
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!appBarState.isProfileDetailScrollingDown) {
          appBarState.setProfileDetailScreenAppBarAndScrollState(
            appBarState: false,
            scrollState: true,
          );
        }
      }

      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (appBarState.isProfileDetailScrollingDown) {
          appBarState.setProfileDetailScreenAppBarAndScrollState(
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
    final profileId = ModalRoute.of(context)?.settings.arguments as String;
    final profileData =
        Provider.of<ProfileInfoProvider>(context, listen: false);
    final profile = profileData.getProfileById(profileId);
    final auth = Provider.of<Auth>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Consumer<StateHandler>(
            builder: (context, state, child) => CustomComponents.showAppBar(
              show: state.showProfileDetailScreenAppBar,
              showActionButton: true,
              showLeadingButton: true,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: profileData.fetchAdditionalProfileDetails(profileId),
              builder: (ctx, futureSnapshot) {
                if (futureSnapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingAnimation();
                }
                final profileDetails = profileData.profileDetails;
                return SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      showUserPhoto(profile),
                      const SizedBox(height: 40),
                      ShowUserInfo(profile: profile),
                      const SizedBox(height: 50),
                      ShowTechSkills(
                        skills: profile.skills,
                      ),
                      const SizedBox(height: 50),
                      ShowIndustries(
                        industries: profile.industries,
                      ),
                      const SizedBox(height: 30),
                      ...space(),
                      CustomComponents.customRow(
                        Icons.event_available_outlined,
                        'Availability',
                        profileDetails.availability,
                      ),
                      ...space(),
                      CustomComponents.customRow(
                        Icons.av_timer_outlined,
                        'Total Eperience',
                        profile.experience == "0"
                            ? '< 1 year'
                            : profile.experience == "1"
                                ? "1 year"
                                : '${profile.experience} years',
                      ),
                      ...space(),
                      ShowTechSkillsWithExperience(
                        profileDetails: profileDetails,
                      ),
                      ...space(),
                      ShowProjects(profileDetails.projects),
                      if (profileDetails.workHistory.isNotEmpty &&
                          profileDetails.workHistory[0]['title'] != "") ...[
                        ...space(),
                        ShowWorkHistory(
                          workHistory: profileDetails.workHistory,
                        ),
                      ],
                      if (profileDetails.softSkills.isNotEmpty) ...[
                        ...space(),
                        ShowSoftSkills(
                          softSkills: profileDetails.softSkills,
                        ),
                      ],
                      if (profileDetails.certifications.isNotEmpty) ...[
                        ...space(),
                        ShowCertificationsInfo(
                          certifications: profileDetails.certifications,
                        ),
                      ],
                      ...space(),
                      ShowEducationInfo(
                        education: profileDetails.education,
                      ),
                      ...space(),
                      CustomComponents.customColumn(
                        LineIcons.language,
                        'Language',
                        'English - ${profileDetails.englishLevel}',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        height: 60,
        elevation: 0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton.icon(
                label: Text(
                  'Share',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                icon: const Icon(
                  Icons.share,
                  size: 20,
                  color: Color.fromRGBO(82, 113, 255, 1),
                ),
                onPressed: () {
                  try {
                    shareProfile(profile);
                  } catch (e) {
                    print('Error sharing: $e');
                  }
                }),
            TextButton.icon(
              label: SizedBox(
                width: 50,
                child: Text(
                  'Hire ${profile.lastName} ${profile.firstName}',
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              icon: const Icon(
                LineIcons.sms,
                size: 20,
                color: Color.fromRGBO(82, 113, 255, 1),
              ),
              onPressed: () {
                if (auth.isAuth) {
                  CustomComponents.hireRequest(
                          context, profile.lastName, profile.firstName)
                      .then((statusCode) {
                    if (statusCode == 201) {
                      CustomComponents.hire(
                          context, profile.lastName, profile.firstName);
                    } else {
                      ShowSnackBar(
                          context: context,
                          label: 'Error statusCode: $statusCode',
                          color: Colors.red);
                    }
                  });
                } else {
                  _showModal(context, profile.lastName, profile.firstName);
                }
              },
            ),
            TextButton.icon(
              label: Text(
                'PDF',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              icon: const Icon(
                LineIcons.download,
                size: 20,
                color: Color.fromRGBO(82, 113, 255, 1),
              ),
              onPressed: () {
                final url =
                    'https://augmntx.com/home/profile2pdf/${profile.id}';
                CustomComponents.downloadPDF(
                  context: context,
                  url: url,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
