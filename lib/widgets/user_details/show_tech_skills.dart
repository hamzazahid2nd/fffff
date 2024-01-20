import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../handlers/state_handler.dart';
import '../../provider/profile_info_provider.dart';

class ShowTechSkills extends StatelessWidget {
  final List<dynamic> skills;

  const ShowTechSkills({Key? key, required this.skills}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: skills.asMap().entries.map((entry) {
          final index = entry.key;
          final skill = entry.value;
          return SkillPill(key: ValueKey('$skill$index'), skill: skill);
        }).toList(),
      ),
    );
  }
}

class SkillPill extends StatefulWidget {
  final String skill;

  const SkillPill({Key? key, required this.skill}) : super(key: key);

  @override
  _SkillPillState createState() => _SkillPillState();
}

class _SkillPillState extends State<SkillPill> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isClicked = !isClicked;
        });
        final profileInfo =
            Provider.of<ProfileInfoProvider>(context, listen: false);
        profileInfo.addSkillToSkillList(widget.skill);
        profileInfo.fetchProfileInfoBySkills();
        final stateHandler = Provider.of<StateHandler>(context, listen: false);
        stateHandler.setProfileScreenAppBarAndScrollState(
          appBarState: true,
          scrollState: false,
        );

        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: const Color.fromRGBO(82, 113, 255, 1),
          ),
          color: isClicked
              ? const Color.fromRGBO(82, 113, 255, 0.1)
              : Colors.transparent,
        ),
        child: Text(
          widget.skill,
          style: const TextStyle(
            fontSize: 13.0,
            height: 1.0,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
