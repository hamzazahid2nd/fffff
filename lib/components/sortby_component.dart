import 'package:augmntx/components/sort_title_component.dart';
import 'package:flutter/material.dart';
class SortType extends StatefulWidget {
  const SortType({super.key});

  @override
  State<SortType> createState() => _SortTypeState();
}

class _SortTypeState extends State<SortType> {
  SelectedSort selectedSort = SelectedSort.none;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        SortTitle(selectedSort == SelectedSort.expInc, (){
          setState(() {
            selectedSort = SelectedSort.expInc;
          });
        }, 'Experience', 'Increasing Order', Icons.arrow_upward_rounded),
        SortTitle(selectedSort == SelectedSort.expDec, (){
          setState(() {
            selectedSort = SelectedSort.expDec;
          });
        },'Experience', 'Decreasing Order',Icons.arrow_downward_rounded),
        SortTitle(selectedSort == SelectedSort.profileRatInc, (){
          setState(() {
            selectedSort = SelectedSort.profileRatInc;
          });
        },'Profile Ratings', 'Increasing Order',Icons.star),
      ],
    );
  }
}

enum SelectedSort{
  none,
  expInc,
  expDec,
  profileRatInc,
}