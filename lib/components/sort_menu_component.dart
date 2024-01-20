import 'package:augmntx/components/sortby_component.dart';
import 'package:augmntx/provider/filterstate_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bottom_sheet_component.dart';

class sortMenu extends StatefulWidget {
  List<String> skillsList;
  List<String> industriesList;
  bool skill;
  bool ind;
  bool exp;


  sortMenu(
      this.skillsList, this.industriesList, this.skill, this.ind, this.exp);

  @override
  State<sortMenu> createState() => _sortMenuState();
}

class _sortMenuState extends State<sortMenu> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 450,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  "Filter & Sort",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(Icons.close)),
              ),

              Expanded(
                child: ListView(
                  children: [
                    ExpansionTile(
                      initiallyExpanded: widget.skill,
                      title: Row(
                        children: [
                          Icon(Icons.access_time_rounded,color: Color.fromRGBO(82, 113, 255, 1), size: 15,),
                          SizedBox(width: 5,),
                          Text(
                            "Technologies",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      expandedAlignment: Alignment.centerLeft,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height : 300,
                            child: CustomBottomSheet('Skills',widget.skillsList,false)),
                      ],
                    ),
                    ExpansionTile(
                      initiallyExpanded: widget.ind,
                      title:
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,color: Color.fromRGBO(82, 113, 255, 1), size: 15,),
                          SizedBox(width: 5,),
                          Text(
                            "Industries",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),


                      expandedAlignment: Alignment.centerLeft,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height : 300,
                            child: CustomBottomSheet('Industries',widget.industriesList,false)),
                      ],
                    ),

                    ExpansionTile(
                      initiallyExpanded : widget.exp,
                      title:  Row(
                        children: [
                          Icon(Icons.access_time_rounded,color: Color.fromRGBO(82, 113, 255, 1), size: 15,),
                          SizedBox(width: 5,),
                          Text(
                            "Experience",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      expandedAlignment: Alignment.centerLeft,
                      expandedCrossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: const Color.fromRGBO(82, 113, 255, 1),
                            inactiveTrackColor: Colors.blue.withOpacity(0.2),
                            thumbColor: Colors.white,
                            overlayColor: Colors.blue.withOpacity(0.3),
                            thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                            overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 15.0),
                            trackHeight: 0.1,
                          ),
                          child: RangeSlider(
                            values: RangeValues(0, 50),
                            min: 0,
                            max: 50,
                            divisions: 50,
                            onChanged: (RangeValues values) {
                              if (values.start <= values.end) {
                                // remoteJobProvider.experienceRange = values;
                                // remoteJobProvider.minController.text =
                                //     values.start.toInt().toString();
                                // remoteJobProvider.maxController.text =
                                //     values.end.toInt().toString();
                              }
                            },
                            onChangeEnd: (RangeValues values) {
                              if (values.start <= values.end) {
                                // filterProfilesByExperience();
                              }
                            },
                          ),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'Min',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 35),
                              child: Text(
                                'Max',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                '0',
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 35),
                              child: Text(
                                '50',
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),

                  ],
                ),
              ),
              Consumer<FilterState>(
                builder: (context, filterStateProvider, widget) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                        height: 35,
                        child:ListView.builder(
                            itemCount :filterStateProvider.selectedSkills.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context , index){
                          return FilterWidgetWithCross(filterStateProvider.selectedSkills[index],(){filterStateProvider.removeSkill(filterStateProvider.selectedSkills[index]);});
                        })
                    ),
                  );
                }
              ),
              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(

                        onTap: (){
                          Provider.of<FilterState>(context, listen: false).clearSkills();
                        },
                        child: Container(

                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15  ),
                              child: Text('CLEAR ALL', style: Theme.of(context).textTheme.bodyMedium),)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Color.fromRGBO(82, 113, 255, 1))
                        ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Text('SHOW RESULTS', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color:Color.fromRGBO(82, 113, 255, 1) )),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterWidgetWithCross extends StatelessWidget {
  String title;

  Function func;

  FilterWidgetWithCross(this.title, this.func);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        func();
      },
      child: Container(
        margin: EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
            color: Colors.grey.shade300
        ),
        child:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
              ),
              SizedBox(width: 10,),
              Icon(Icons.close, size: 17,),
            ],
          ),
        ),
      ),
    );
  }
}
