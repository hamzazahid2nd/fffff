import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/profile_info_provider.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({super.key});

  @override
  FilterDrawerState createState() => FilterDrawerState();
}

class FilterDrawerState extends State<FilterDrawer> {
  bool showAllIndustries = false;
  final ProfileInfoProvider _profileInfoProvider = ProfileInfoProvider();
  late Future<List<String>> industriesFuture;
  final ScrollController _scrollController = ScrollController();
  Future<List<String>> fetchIndustries() async {
    return _profileInfoProvider.fetchProfileInfo(1000);
  }

  @override
  void initState() {
    super.initState();
    industriesFuture = fetchIndustries();
  }

  void filterProfilesByExperience() {
    final profileInfo =
        Provider.of<ProfileInfoProvider>(context, listen: false);
    profileInfo.fetchProfileInfoByExperience(
        profileInfo.experienceRange.start.toInt(),
        profileInfo.experienceRange.end.toInt());
  }

  void filterProfilesByExperiencetype() {
    final profileInfo =
        Provider.of<ProfileInfoProvider>(context, listen: false);
    final double minValue =
        double.tryParse(profileInfo.minController.text) ?? 0;
    final double maxValue =
        double.tryParse(profileInfo.maxController.text) ?? 60;

    if (minValue <= maxValue) {
      setState(() {
        profileInfo.experienceRange = RangeValues(minValue, maxValue);
      });

      profileInfo.fetchProfileInfoByExperience(
          minValue.toInt(), maxValue.toInt());

      profileInfo.minController.text = minValue.toInt().toString();
      profileInfo.maxController.text = maxValue.toInt().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ProfileInfoProvider profileInfoProvider =
        Provider.of<ProfileInfoProvider>(context);

    return Drawer(
      backgroundColor: Colors.blueGrey[900],
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Builder(
          builder: (BuildContext builderContext) {
            return Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filters',
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
                                Navigator.pop(builderContext);
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: Text(
                        'Industries',
                        style: GoogleFonts.quicksand(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    FutureBuilder<List<String>>(
                      future: industriesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<String> industries = snapshot.data ?? [];

                          Map<String, int> industryCount = {};
                          for (var profile
                              in _profileInfoProvider.profileData) {
                            for (var industry in profile.industries) {
                              if (industries.contains(industry)) {
                                industryCount[industry] =
                                    (industryCount[industry] ?? 0) + 1;
                              }
                            }
                          }
                          List<String> sortedindustries = industries.toList()
                            ..sort((a, b) => (industryCount[b] ?? 0)
                                .compareTo(industryCount[a] ?? 0));

                          int itemCount =
                              showAllIndustries ? sortedindustries.length : 8;

                          return Column(
                            children: [
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: itemCount,
                                itemExtent: 40,
                                itemBuilder: (context, index) {
                                  String industry = sortedindustries[index];
                                  int profileCount =
                                      industryCount[industry] ?? 0;
                                  return Row(
                                    children: [
                                      Expanded(
                                        child: ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(
                                            '${industry.trim()} ($profileCount)',
                                            style: GoogleFonts.quicksand(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 16),
                                        child: Transform.scale(
                                          scale: 0.9,
                                          child: Checkbox(
                                            checkColor: Colors.white,
                                            activeColor: const Color.fromRGBO(
                                                82, 113, 255, 1),
                                            value: profileInfoProvider
                                                .selectedIndustries
                                                .contains(industry),
                                            onChanged: (bool? value) {
                                              profileInfoProvider
                                                  .toggleIndustrySelection(
                                                      industry);
                                              profileInfoProvider
                                                  .fetchProfileInfoByIndustry(
                                                profileInfoProvider
                                                    .selectedIndustries
                                                    .toList(),
                                              );
                                            },
                                            side: const BorderSide(
                                                color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showAllIndustries = !showAllIndustries;
                                    if (!showAllIndustries) {
                                      _scrollController.jumpTo(0);
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 180.0, bottom: 25, top: 20),
                                  child: Text(
                                    showAllIndustries
                                        ? 'Show Less'
                                        : 'Show More',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        'Years of experience',
                        style: GoogleFonts.quicksand(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color.fromRGBO(82, 113, 255, 1),
                        inactiveTrackColor: Colors.blue.withOpacity(0.2),
                        thumbColor: Colors.white,
                        overlayColor: Colors.blue.withOpacity(0.3),
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 12.0),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 15.0),
                        trackHeight: 0.1,
                      ),
                      child: RangeSlider(
                        values: profileInfoProvider.experienceRange,
                        min: 0,
                        max: 60,
                        divisions: 60,
                        onChanged: (RangeValues values) {
                          if (values.start <= values.end) {
                            profileInfoProvider.experienceRange = values;
                            profileInfoProvider.minController.text =
                                values.start.toInt().toString();
                            profileInfoProvider.maxController.text =
                                values.end.toInt().toString();
                          }
                        },
                        onChangeEnd: (RangeValues values) {
                          if (values.start <= values.end) {
                            filterProfilesByExperience();
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              'Min',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 35),
                            child: Text(
                              'Max',
                              style: GoogleFonts.quicksand(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: TextFormField(
                            controller: profileInfoProvider.minController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                            onChanged: (value) {
                              double startValue = double.parse(value);
                              final double endValue = double.parse(
                                  profileInfoProvider.maxController.text);
                              if (startValue > 60) {
                                startValue = 60.0;
                                profileInfoProvider.minController.text = '60';
                              }

                              if (startValue <= endValue) {
                                setState(() {
                                  profileInfoProvider.experienceRange =
                                      RangeValues(startValue, endValue);
                                });
                                filterProfilesByExperiencetype();
                              }
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding:
                                  EdgeInsets.only(bottom: 13, right: 4),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                final double currentValue = double.parse(
                                    profileInfoProvider.minController.text);
                                if (currentValue < 60) {
                                  setState(() {
                                    profileInfoProvider.minController.text =
                                        (currentValue + 1).toStringAsFixed(0);
                                  });
                                  filterProfilesByExperiencetype();
                                }
                              },
                              icon: const Icon(Icons.keyboard_arrow_up,
                                  size: 20, color: Colors.white),
                            ),
                            IconButton(
                              onPressed: () {
                                final double currentValue = double.parse(
                                    profileInfoProvider.minController.text);
                                if (currentValue > 0) {
                                  setState(() {
                                    profileInfoProvider.minController.text =
                                        (currentValue - 1).toStringAsFixed(0);
                                  });
                                  filterProfilesByExperiencetype();
                                }
                              },
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 20, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 98,
                        ),
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: TextFormField(
                            controller: profileInfoProvider.maxController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(2),
                            ],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20),
                            onChanged: (value) {
                              final double startValue = double.parse(
                                  profileInfoProvider.minController.text);
                              double endValue = double.parse(value);
                              if (endValue > 60) {
                                endValue = 60.0;
                                profileInfoProvider.maxController.text = '60';
                              }

                              if (startValue <= endValue) {
                                setState(() {
                                  profileInfoProvider.experienceRange =
                                      RangeValues(startValue, endValue);
                                });
                                filterProfilesByExperiencetype();
                              }
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.transparent,
                              contentPadding:
                                  EdgeInsets.only(bottom: 13, right: 4),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                final double currentValue = double.parse(
                                    profileInfoProvider.maxController.text);
                                if (currentValue < 60) {
                                  setState(() {
                                    profileInfoProvider.maxController.text =
                                        (currentValue + 1).toStringAsFixed(0);
                                  });
                                  filterProfilesByExperiencetype();
                                }
                              },
                              icon: const Icon(Icons.keyboard_arrow_up,
                                  size: 20, color: Colors.white),
                            ),
                            IconButton(
                              onPressed: () {
                                final double currentValue = double.parse(
                                    profileInfoProvider.maxController.text);
                                if (currentValue > 1) {
                                  setState(() {
                                    profileInfoProvider.maxController.text =
                                        (currentValue - 1).toStringAsFixed(0);
                                  });
                                  filterProfilesByExperiencetype();
                                }
                              },
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  size: 20, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
