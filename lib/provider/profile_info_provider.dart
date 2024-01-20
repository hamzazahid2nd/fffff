import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../model/additional_details.dart';
import '../model/profile.dart';

class ProfileInfoProvider with ChangeNotifier {
  List<Profile> _profileData = [];
  List<Profile> get profileData {
    return [..._profileData];
  }

  List<Profile> _profileDataBySkills = [];
  List<Profile> get profileDataBySkills {
    return [..._profileDataBySkills];
  }

  bool isFetchingProfileBySkills = false;
  bool isFetchingMoreProfiles = false;

  AdditionalDetails? _profileDetail;
  AdditionalDetails get profileDetails {
    return _profileDetail!;
  }
  Future<List<String>> fetchIndustriesInfo() async {
    final endpointUrl = Uri.parse('https://augmntx.com/autocomplete');

    try {
      final response = await http.get(endpointUrl);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Assuming responseData is a List<String>
        if (responseData is List) {
          return List<String>.from(responseData);
        } else {
          throw FormatException('Unexpected response format');
        }
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  } Future<List<String>> fetchSkillsInfo() async {
    final endpointUrl = Uri.parse('https://augmntx.com/autocomplete/skill_search_all');

    try {
      final response = await http.get(endpointUrl);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Assuming responseData is a List<String>
        if (responseData is List) {
          return List<String>.from(responseData);
        } else {
          throw FormatException('Unexpected response format');
        }
      } else {
        throw Exception('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }
  Future<List<String>> fetchProfileInfo(int limit) async {
    isFetchingMoreProfiles = true;
    final endpointUrl =
        Uri.parse('${ConstantValues.apiLink}profile_list?limit=$limit');
    _profileData.clear();

    try {
      final response = await http.get(endpointUrl);
      if (response.statusCode > 400) {
        isFetchingMoreProfiles = false;
        return [];
      }

      final responseData = json.decode(response.body);
      if (responseData == null) {
        isFetchingMoreProfiles = false;
        return [];
      }

      final profileList = responseData as List<dynamic>;
      final List<Profile> loadedProfiles = [];

      for (var profile in profileList) {
        final userPhoto =
            profile['userPhoto'].toString().contains('noimage.jpg')
                ? profile['userPhoto']
                : 'https://augmntx.com/${profile['userPhoto']}';

        loadedProfiles.add(
          Profile(
            id: profile['id'],
            uniqueId: profile['unique_id'],
            firstName: profile['first_name'],
            lastName: profile['last_name'],
            city: profile['city'],
            bio: profile['bio'],
            experience: profile['experience'],
            country: profile['country'],
            primaryTitle: profile['primary_title'],
            userPhoto: userPhoto,
            industries: List<String>.from(profile['profile_industries']),
            skills: List<String>.from(profile['skills']),
          ),
        );
      }

      _profileData = loadedProfiles;
      isFetchingMoreProfiles = false;
      List<String> allIndustries = _profileData
          .expand((profile) => profile.industries)
          .map((industry) => industry.toString())
          .toSet()
          .toList();

      return allIndustries;
    } catch (_) {
      isFetchingMoreProfiles = false;
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  final List<String> _skillsList = [];
  List<String> get skillList {
    return [..._skillsList];
  }

  void addSkillToSkillList(String skill) {
    if (!_skillsList.contains(skill)) {
      _skillsList.add(skill);
    }
    notifyListeners();
  }

  void removeSkillFromSkillList(String skill) {
    if (_skillsList.contains(skill)) {
      _skillsList.remove(skill);
    }
    notifyListeners();
  }

  Future<void> fetchProfileInfoBySkills() async {
    isFetchingProfileBySkills = true;
    _profileDataBySkills.clear();
    final endpointUrl = Uri.parse('${ConstantValues.apiLink}search');
    try {
      final Map<String, dynamic> requestData = {
        'skills': _skillsList,
        'industries': _selectedIndustries.toList(),
        'experience': [
          _experienceRange.start.toInt(),
          _experienceRange.end.toInt()
        ],
      };

      final response = await http.post(
        endpointUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode > 400) {
        isFetchingProfileBySkills = false;
        return;
      }

      final responseData = json.decode(response.body);

      if (responseData == null) {
        isFetchingProfileBySkills = false;
        return;
      }

      final profileList = responseData as List<dynamic>;

      final List<Profile> loadedProfiles = [];

      for (var profile in profileList) {
        for (var profileMap in profile) {
          const defaultImage = 'https://augmntx.com/assets/img/noimage.jpg';
          String userPhoto = 'https://augmntx.com/${profileMap['userPhoto']}';
          if (userPhoto == 'https://augmntx.com/uploads/' ||
              userPhoto.contains('photo.png')) {
            userPhoto = defaultImage;
          }
          loadedProfiles.add(
            Profile(
              id: profileMap['id'],
              uniqueId: profileMap['unique_id'],
              firstName: profileMap['first_name'],
              lastName: profileMap['last_name'],
              city: profileMap['city'],
              bio: profileMap['bio'],
              experience: profileMap['experience'],
              country: profileMap['country'],
              primaryTitle: profileMap['primary_title'],
              userPhoto: userPhoto,
              industries: List<String>.from(profileMap['profile_industries']),
              skills: List<String>.from(profileMap['skills']),
            ),
          );
        }
      }
      _profileDataBySkills = loadedProfiles;
      isFetchingProfileBySkills = false;
    } catch (_) {
      isFetchingProfileBySkills = false;
      rethrow;
    }
    notifyListeners();
  }

  final Set<String> _selectedIndustries = {};

  Set<String> get selectedIndustries {
    return {..._selectedIndustries};
  }

  void clearSelectedIndustries() {
    _selectedIndustries.clear();
    notifyListeners();
  }

  void toggleIndustrySelection(String industry) {
    if (_selectedIndustries.contains(industry)) {
      _selectedIndustries.remove(industry);
    } else {
      _selectedIndustries.add(industry);
    }
    notifyListeners();
  }

  Future<void> fetchProfileInfoByIndustry(List<String> industries) async {
    isFetchingProfileBySkills = true;
    _profileDataBySkills.clear();
    final endpointUrl = Uri.parse('${ConstantValues.apiLink}search');
    try {
      final Map<String, dynamic> requestData = {
        'skills': _skillsList,
        'industries': industries,
        'experience': [
          _experienceRange.start.toInt(),
          _experienceRange.end.toInt()
        ],
      };

      final response = await http.post(
        endpointUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode > 400) {
        isFetchingProfileBySkills = false;
        return;
      }

      final responseData = json.decode(response.body);

      if (responseData == null) {
        isFetchingProfileBySkills = false;
        return;
      }

      final profileList = responseData as List<dynamic>;

      final List<Profile> loadedProfiles = [];

      for (var profile in profileList) {
        for (var profileMap in profile) {
          const defaultImage = 'https://augmntx.com/assets/img/noimage.jpg';
          String userPhoto = 'https://augmntx.com/${profileMap['userPhoto']}';
          if (userPhoto == 'https://augmntx.com/uploads/' ||
              userPhoto.contains('photo.png')) {
            userPhoto = defaultImage;
          }
          loadedProfiles.add(
            Profile(
              id: profileMap['id'],
              uniqueId: profileMap['unique_id'],
              firstName: profileMap['first_name'],
              lastName: profileMap['last_name'],
              city: profileMap['city'],
              bio: profileMap['bio'],
              experience: profileMap['experience'],
              country: profileMap['country'],
              primaryTitle: profileMap['primary_title'],
              userPhoto: userPhoto,
              industries: List<String>.from(profileMap['profile_industries']),
              skills: List<String>.from(profileMap['skills']),
            ),
          );
        }
      }

      _profileDataBySkills = loadedProfiles;
      isFetchingProfileBySkills = false;
    } catch (_) {
      isFetchingProfileBySkills = false;
      rethrow;
    }
    notifyListeners();
  }

  RangeValues _experienceRange = const RangeValues(0, 60);
  RangeValues get experienceRange => _experienceRange;

  set experienceRange(RangeValues value) {
    _experienceRange = value;
    notifyListeners();
  }

  TextEditingController _minController = TextEditingController(text: '0');
  TextEditingController get minController => _minController;

  set minController(TextEditingController value) {
    _minController = value;
    notifyListeners();
  }

  TextEditingController _maxController = TextEditingController(text: '60');
  TextEditingController get maxController => _maxController;

  set maxController(TextEditingController value) {
    _maxController = value;
    notifyListeners();
  }

  void clearExperancevalues() {
    _experienceRange = const RangeValues(0, 60);
    _minController.text = '0';
    _maxController.text = '60';
    notifyListeners();
  }

  Future<void> fetchProfileInfoByExperience(
      int minExperience, int maxExperience) async {
    isFetchingProfileBySkills = true;
    _profileDataBySkills.clear();
    final endpointUrl = Uri.parse('${ConstantValues.apiLink}search');
    try {
      final Map<String, dynamic> requestData = {
        'skills': _skillsList,
        'industries': _selectedIndustries.toList(),
        'experience': [minExperience, maxExperience],
      };

      final response = await http.post(
        endpointUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode > 400) {
        isFetchingProfileBySkills = false;
        return;
      }

      final responseData = json.decode(response.body);

      if (responseData == null) {
        isFetchingProfileBySkills = false;
        return;
      }

      final profileList = responseData as List<dynamic>;

      final List<Profile> loadedProfiles = [];

      for (var profile in profileList) {
        for (var profileMap in profile) {
          const defaultImage = 'https://augmntx.com/assets/img/noimage.jpg';
          String userPhoto = 'https://augmntx.com/${profileMap['userPhoto']}';
          if (userPhoto == 'https://augmntx.com/uploads/' ||
              userPhoto.contains('photo.png')) {
            userPhoto = defaultImage;
          }
          loadedProfiles.add(
            Profile(
              id: profileMap['id'],
              uniqueId: profileMap['unique_id'],
              firstName: profileMap['first_name'],
              lastName: profileMap['last_name'],
              city: profileMap['city'],
              bio: profileMap['bio'],
              experience: profileMap['experience'],
              country: profileMap['country'],
              primaryTitle: profileMap['primary_title'],
              userPhoto: userPhoto,
              industries: List<String>.from(profileMap['profile_industries']),
              skills: List<String>.from(profileMap['skills']),
            ),
          );
        }
      }

      _profileDataBySkills = loadedProfiles;
      isFetchingProfileBySkills = false;
    } catch (_) {
      isFetchingProfileBySkills = false;
      rethrow;
    }
    notifyListeners();
  }

  Future<void> fetchAdditionalProfileDetails(String uniqueId) async {
    try {
      final endpointUrl =
          Uri.parse('${ConstantValues.apiLink}profile/$uniqueId');

      final response = await http.get(endpointUrl);
      if (response.statusCode > 400) {
        return;
      }
      final responseData = json.decode(response.body);
      if (responseData == null) {
        return;
      }
      final profileDetails = responseData as Map<String, dynamic>;

      _profileDetail = AdditionalDetails(
        city: profileDetails['profile_info']['city'],
        englishLevel: profileDetails['profile_info']['english'],
        availability: profileDetails['profile_info']['comittment'],
        softSkills: profileDetails['profile_info']['soft_skill'] != ""
            ? profileDetails['profile_info']['soft_skill'].toString().split(',')
            : List.empty(),
        education: profileDetails['education'] != null
            ? (profileDetails['education'] as List<dynamic>)
                .map((edu) => {
                      'degree': "${edu['degree']} in ${edu['major']}",
                      'uni': edu['univ'],
                      'fromTo': "${edu['edu_start']} to ${edu['edu_end']}",
                    })
                .toList()
            : List.empty(),
        projects: profileDetails['projects'] != null
            ? (profileDetails['projects'] as List<dynamic>)
                .map(
                  (pr) => {
                    'title': pr['title'],
                    'fromTo': pr['pro_start'] != ""
                        ? '${pr['pro_start']} to ${pr['pro_end'] != "" ? pr['pro_end'] : "Present"}'
                        : "",
                    'description': pr['description'],
                    'technologies': pr['technologies'],
                    'responsibilities': pr['responsibilities'],
                    'industry': pr['industry'],
                    'url': pr['url'],
                  },
                )
                .toList()
            : List.empty(),
        skills: profileDetails['skills'] != null
            ? (profileDetails['skills'] as List<dynamic>)
                .map(
                  (skill) => {
                    'name': skill['name'],
                    'year': skill['year'],
                    'month': skill['month'],
                  },
                )
                .toList()
            : List.empty(),
        workHistory: profileDetails['experience'] != null
            ? (profileDetails['experience'] as List<dynamic>)
                .map((ex) => {
                      'title': ex['title'],
                      'company': ex['company_name'] != ""
                          ? 'at ${ex['company_name']}'
                          : "",
                      'fromTo': (ex['start'] != "" && ex['end'] == "")
                          ? '${ex['start']} to Present'
                          : ex['start'] != ""
                              ? '${ex['start']} to ${ex['end']}'
                              : "",
                      'description': ex['description'] ?? "",
                    })
                .toList()
            : List.empty(),
        certifications: profileDetails['certifications'] ?? List.empty(),
      );
    } catch (_) {
      rethrow;
    }
    notifyListeners();
  }

  Profile getProfileById(String id) {
    if (_skillsList.isNotEmpty) {
      return _profileDataBySkills
          .firstWhere((profile) => profile.uniqueId == id);
    }
    return _profileData.firstWhere((profile) => profile.uniqueId == id);
  }
}
