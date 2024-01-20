import 'package:augmntx/components/bottom_sheet_component.dart';
import 'package:augmntx/components/filters_selectable_dropdown.dart';
import 'package:augmntx/components/sort_menu_component.dart';
import 'package:augmntx/components/sort_title_component.dart';
import 'package:augmntx/components/sortby_component.dart';
import 'package:augmntx/provider/filter_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../contact/contact_us_screen.dart';
import '/components/custom_components.dart';
import '/components/custom_search_field.dart';
import '/handlers/state_handler.dart';
import '/provider/skills_provider.dart';
import '../../widgets/app/app_drawer.dart';
import '../../components/loading_animation.dart';
import '/provider/profile_info_provider.dart';
import '../../widgets/app/profile_card.dart';
import '../../widgets/app/filter_drawer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  static const routeName = '/profile-screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _skillTextController = TextEditingController();
  final _scrollController = ScrollController();
  int _profileLimit = 10;

  late Future<void> _futureProfileData;
  List<String> industriesList = [];
  List<String> skillsList = [];
  bool isSorted = false;
  final filterListProvider = ApplyFilterListProvider();
  @override
  void initState() {
    super.initState();
    _initializeProfileData();
    _initializeScrollListener();
    _initialiseIndustriesList();
    _initialiseSkillsList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _skillTextController.dispose();
    super.dispose();
  }

  void _initialiseIndustriesList() async {
    industriesList =
        await Provider.of<ProfileInfoProvider>(context, listen: false)
            .fetchIndustriesInfo();
    print(industriesList);
    setState(() {
      industriesList;
    });
  }

  void _initialiseSkillsList() async {
    skillsList = await Provider.of<ProfileInfoProvider>(context, listen: false)
        .fetchSkillsInfo();
    print(skillsList);
    setState(() {
      skillsList;
    });
  }

  void _initializeScrollListener() {
    final appBarState = Provider.of<StateHandler>(context, listen: false);
    _scrollController.addListener(() {
      final isScrollingDown = _scrollController.position.userScrollDirection ==
          ScrollDirection.reverse;
      final isScrollingUp = _scrollController.position.userScrollDirection ==
          ScrollDirection.forward;

      if (isScrollingDown && !appBarState.isProfileScreenScrollingDown) {
        appBarState.setProfileScreenAppBarAndScrollState(
            appBarState: false, scrollState: true);
      }

      if (isScrollingUp && appBarState.isProfileScreenScrollingDown) {
        appBarState.setProfileScreenAppBarAndScrollState(
            appBarState: true, scrollState: false);
      }

      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final info = Provider.of<ProfileInfoProvider>(context, listen: false);
        if (info.skillList.isEmpty) {
          _profileLimit += 10;
        }
        getProfileData();
      }
    });
  }

  void _initializeProfileData() {
    _futureProfileData = getProfileData();
  }

  Future<void> getProfileData() {
    return Provider.of<ProfileInfoProvider>(context, listen: false)
        .fetchProfileInfo(_profileLimit);
  }

  Future<void> getProfileDataBySkills() {
    return Provider.of<ProfileInfoProvider>(context, listen: false)
        .fetchProfileInfoBySkills();
  }

  @override
  Widget build(BuildContext context) {
    final profileInfo = Provider.of<ProfileInfoProvider>(context);
    final profileData = profileInfo.skillList.isNotEmpty
        ? profileInfo.profileDataBySkills
        : profileInfo.profileData;

    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: const FilterDrawer(),
      body: Column(
        children: [
          Consumer<StateHandler>(
            builder: (context, state, child) =>
                _appBarAndSearchBarWidget(state, profileInfo),
          ),
          Expanded(
            child: Stack(
              children: [
                FutureBuilder(
                  future: _futureProfileData,
                  builder: (ctx, futureSnapshots) {
                    if (futureSnapshots.connectionState ==
                            ConnectionState.waiting ||
                        profileInfo.isFetchingProfileBySkills) {
                      return const LoadingAnimation();
                    }

                    if (futureSnapshots.connectionState ==
                            ConnectionState.done &&
                        profileData.isEmpty) {
                      return _buildNoResultsWidget();
                    }
                    return ListView.builder(
                      padding: EdgeInsets.only(
                        top: profileInfo.skillList.isNotEmpty ? 0 : 15,
                      ),
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: profileInfo.skillList.isNotEmpty
                          ? profileData.length
                          : profileData.length + 1,
                      itemBuilder: (ctx, index) {
                        if (index == profileData.length &&
                            profileInfo.skillList.isEmpty) {
                          return ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CustomComponents.progressiveDotsLoading,
                              ],
                            ),
                          );
                        } else {
                          final profile = profileData[index];
                          return ProfileCard(
                            id: profile.id,
                            uniqueId: profile.uniqueId,
                            name: profile.firstName,
                            lastName: profile.lastName,
                            image: profile.userPhoto,
                            experience: profile.experience,
                            designation: profile.primaryTitle,
                            description: profile.bio,
                            industries: profile.industries,
                            techSkills: profile.skills,
                          );
                        }
                      },
                    );
                  },
                ),
                Consumer<SkillsProvider>(
                  builder: (ctx, skillProvider, _) {
                    if (skillProvider.allSkills.isEmpty ||
                        !skillProvider.isFetchingSkill) {
                      return Container();
                    }
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      elevation: 5,
                      color: Colors.white,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 10,
                        ),
                        itemCount: skillProvider.allSkills.length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) => GestureDetector(
                          onTap: () {
                            profileInfo.addSkillToSkillList(
                                skillProvider.allSkills[index]);
                            getProfileDataBySkills();
                            _skillTextController.clear();
                            skillProvider.clearSkillList();
                          },
                          child: Text(
                            skillProvider.allSkills[index],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container searchedSkillContainer(
    String skill,
    ProfileInfoProvider profileInfo, {
    bool isFirstItem = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: isFirstItem
          ? const EdgeInsets.only(left: 20)
          : const EdgeInsets.only(left: 10),
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: const Color.fromRGBO(82, 113, 255, 1),
      ),
      child: Row(
        children: [
          Text(
            skill,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 5),
          InkWell(
            onTap: () {
              profileInfo.removeSkillFromSkillList(skill);
              if (profileInfo.skillList.isEmpty) {
                profileInfo.clearSelectedIndustries();
                profileInfo.clearExperancevalues();
              }
              getProfileDataBySkills();
            },
            child: const Icon(
              Icons.cancel_rounded,
              color: Colors.white,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }

  Column _appBarAndSearchBarWidget(
    StateHandler state,
    ProfileInfoProvider profileInfo,
  ) {
    final skillProvider = Provider.of<SkillsProvider>(context);
    final bool showFilterBar = profileInfo.skillList.isNotEmpty;
    return Column(
      children: [
        CustomComponents.showAppBar(
          show: state.showProfileScreenAppBar,
          showActionButton: true,
          showLeadingButton: false,
        ),
        const SizedBox(height: 10),
        if (state.showProfileScreenAppBar)
          CustomSearchField(
            hintText: 'Search for skills',
            controller: _skillTextController,
            onChanged: (skill) {
              if (skill.trim().isEmpty) {
                skillProvider.clearSkillList();
                return;
              }
              skillProvider.fetchAllSkills(skill);
            },
            onFieldSubmitted: (skill) {
              if (skill.trim().isEmpty) {
                return;
              }
              profileInfo.addSkillToSkillList(skill);
              getProfileDataBySkills();
              _skillTextController.clear();
              skillProvider.clearSkillList();
            },
            onTapOutside: (_) {
              FocusManager.instance.primaryFocus!.unfocus();
            },
          ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            height: 30,
            // color: Colors.red,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                filterClicker('Sort', () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
                      ),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return sortMenu(skillsList, industriesList,false,false,false);
                      });
                }, false),
                filterClicker('Skills', () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        // return CustomBottomSheet('Skills', skillsList, true);
                        return sortMenu(skillsList, industriesList,true,false,false);

                      });
                }, true),
                filterClicker('Industries', () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        // return CustomBottomSheet(
                        //     'Industries', industriesList, true);
                        return sortMenu(skillsList, industriesList,false,true,false);

                      });
                }, true),
                filterClicker('Experience', () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        // return Container(
                        //   height: 200,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(28.0),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text('Adjust Experience',
                        //             style: Theme.of(context)
                        //                 .textTheme
                        //                 .bodyLarge
                        //                 ?.copyWith(fontSize: 24)),
                        //         SizedBox(
                        //           height: 40,
                        //         ),
                        //         SliderTheme(
                        //           data: SliderTheme.of(context).copyWith(
                        //             activeTrackColor:
                        //                 const Color.fromRGBO(82, 113, 255, 1),
                        //             inactiveTrackColor:
                        //                 Colors.blue.withOpacity(0.2),
                        //             thumbColor: Colors.white,
                        //             overlayColor: Colors.blue.withOpacity(0.3),
                        //             thumbShape: const RoundSliderThumbShape(
                        //                 enabledThumbRadius: 12.0),
                        //             overlayShape: const RoundSliderOverlayShape(
                        //                 overlayRadius: 15.0),
                        //             trackHeight: 0.1,
                        //           ),
                        //           child: RangeSlider(
                        //             values: const RangeValues(0, 60),
                        //             min: 0,
                        //             max: 60,
                        //             divisions: 60,
                        //             onChanged: (RangeValues values) {},
                        //             onChangeEnd: (RangeValues values) {},
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // );
                        return sortMenu(skillsList, industriesList,false,false,true);

                      });
                }, true),

                // FilterTextDropDown(filterListProvider.fpList[0] ,'Skills', skillsList, 80),
                // FilterTextDropDown(
                //     filterListProvider.fpList[1],
                //     'Min Experience',
                //     List.generate(51, (index) => index.toString()).toList(),
                //     50),
                // FilterTextDropDown(
                //     filterListProvider.fpList[2],
                //     'Max Experience',
                //     List.generate(51, (index) => index.toString())
                //         .reversed
                //         .toList(),
                //     50),
                // FilterTextDropDown(
                //     filterListProvider.fpList[3],
                //     'Industries', industriesList, 120),
              ],
            ),
          ),
        ),
        if (showFilterBar) ...[
          const SizedBox(height: 10),
          Material(
            color: Colors.transparent,
            child: SizedBox(
              height: 30,
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: profileInfo.skillList.length,
                      itemBuilder: (ctx, index) => searchedSkillContainer(
                        profileInfo.skillList[index],
                        profileInfo,
                        isFirstItem: index == 0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20, left: 5),
                      child: Builder(builder: (ctx) {
                        return GestureDetector(
                          onTap: () {
                            Scaffold.of(ctx).openEndDrawer();
                            profileInfo.fetchProfileInfoByIndustry(
                                profileInfo.selectedIndustries.toList());
                          },
                          child: const Icon(
                            Icons.filter_list,
                            color: Colors.black,
                            size: 30,
                          ),
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildNoResultsWidget() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: const EdgeInsets.only(top: 25, left: 15, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No results based on your filter',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 25),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Remove filters to get results or ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text: 'Connect with our Expert team',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(82, 113, 255, 1),
                      fontFamily: 'quicksand',
                      height: 1.6,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.of(context)
                            .pushNamed(ContactUsScreen.routeName);
                        Scaffold.of(context).closeDrawer();
                      },
                  ),
                  TextSpan(
                    text: ' to find the profile for you',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class sortBtn extends StatelessWidget {
  bool isSorted;
  Function function;

  sortBtn(this.isSorted, this.function);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: AnimatedContainer(
            duration: Duration(milliseconds: 400),
            decoration: BoxDecoration(
                color:
                    !isSorted ? Colors.white : Color.fromRGBO(82, 113, 255, 1),
                borderRadius: BorderRadius.circular(5),
                border: !isSorted
                    ? Border.all(width: 1, color: Colors.grey.shade500)
                    : Border.all(width: 1, color: Colors.transparent)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Text(
                    'Sort',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              !isSorted ? Colors.grey.shade500 : Colors.white,
                        ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Icon(
                    Icons.sort,
                    size: 15,
                    color: !isSorted ? Colors.grey.shade500 : Colors.white,
                  )
                ],
              ),
            )),
      ),
    );
  }
}

class filterClicker extends StatelessWidget {
  String title;
  Function function;
  bool others;

  filterClicker(this.title, this.function, this.others);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.grey.shade600)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: others
                    ? [
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                        ),
                      ]
                    : [
                        Text(
                          title,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey.shade600,
                                  ),
                        ),
                        SizedBox(
                          width: 13,
                        ),
                        Icon(
                          Icons.sort,
                          size: 15,
                        )
                      ],
              ),
            )),
      ),
    );
  }
}
