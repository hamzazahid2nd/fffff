import 'package:flutter/material.dart';

class FilterState extends ChangeNotifier{
  List<String> selectedSkills = [];
  List<String> selectedIndustries = [];

  void clearSkills() {
    selectedSkills.clear();
    notifyListeners();
  }
  void updateSkills(List<String> skills) {
    selectedSkills = List.from(skills);
    notifyListeners();
  }
  void addSkill(String skill){
    selectedSkills.add(skill);
    print(selectedSkills);
    notifyListeners();
  }
  void addIndustry(String industry){
    selectedSkills.add(industry);
    print(selectedIndustries);
    notifyListeners();
  }
  void removeSkill(String skill){
    selectedSkills.remove(skill);
    print(selectedSkills);
    notifyListeners();
  }
  void removeIndustry(String industry){
    selectedIndustries.remove(industry);
    print(selectedIndustries);
    notifyListeners();
  }
}