import 'package:flutter/foundation.dart';

class FilterProvider extends ChangeNotifier{
  String selectedItem;

  FilterProvider(this.selectedItem);
  void setSelectedItem(String item){
    selectedItem = item;
    notifyListeners();
  }
}

class ApplyFilterListProvider{
  List<FilterProvider> fpList = [
    FilterProvider(''),
    FilterProvider(''),
    FilterProvider(''),
    FilterProvider(''),
  ];
  void applyFilters(){
    print(fpList[0].selectedItem);
    print(fpList[1].selectedItem);
    print(fpList[2].selectedItem);
    print(fpList[3].selectedItem);
  }
}