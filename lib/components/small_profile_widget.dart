import 'package:flutter/material.dart';
import 'package:augmntx/model/DummyProfile.dart';

class SmallProfileWidget extends StatefulWidget {
  DummyProfile dummyProfile;

  SmallProfileWidget(this.dummyProfile);

  @override
  State<SmallProfileWidget> createState() => _SmallProfileWidgetState();
}

class _SmallProfileWidgetState extends State<SmallProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 200,
      width: 120,
      decoration: BoxDecoration(
        borderRadius:BorderRadius.circular(3),
        color: Colors.grey.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(2, 3), // Shadow position
            blurRadius: 2, // Shadow spread
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Image.asset(widget.dummyProfile.imagePath),
              height: 120,
              width: 120,
            decoration: BoxDecoration(

              borderRadius:BorderRadius.circular(3),
                color: Color.fromRGBO(82, 113, 255, 1)
            ),
          ),
         Padding(padding: EdgeInsets.all(3),child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(widget.dummyProfile.name,style: TextStyle(
                 fontSize: 10
             ),),
             Text(widget.dummyProfile.job,style: TextStyle(
                 fontSize: 10
             ),),
             Row(
               children : widget.dummyProfile.skill.map((e) => SkillLable(e)).toList()
               // children: [
               //   SkillLable('Dart'),
               //   SkillLable('Flutter'),
               //   SkillLable('Kotlin'),
               // ],
             )
           ],
         ),)
        ],
      ),
    );
  }
}

class SkillLable extends StatelessWidget {
  String skill;

  SkillLable(this.skill);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(1),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Color.fromRGBO(82, 113, 255, 1)
          )
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
        child: Text(skill,style: TextStyle(fontSize: 7),),
      ));
  }
}
