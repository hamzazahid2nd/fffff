import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SkillsProvider with ChangeNotifier {
  List<String> _allSkills = [];
  List<String> get allSkills {
    return [..._allSkills];
  }

  void clearSkillList() {
    _allSkills.clear();
    isFetchingSkill = false;
    notifyListeners();
  }

  bool isFetchingSkill = false;

  Future<void> fetchAllSkills(String skill) async {
    isFetchingSkill = true;
    final url = 'https://augmntx.com/autocomplete/skill_search?search=$skill';
    final response = await http.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    final List<String> loadedSkills = [];
    for (var skill in responseData) {
      loadedSkills.add(skill);
    }
    _allSkills = loadedSkills;
    notifyListeners();
  }
}
