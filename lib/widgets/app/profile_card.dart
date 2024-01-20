import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../screens/auth/auth_screen.dart';
import '/components/show_snackbar.dart';
import '/provider/profile_info_provider.dart';
import '../../components/custom_components.dart';
import '../../handlers/state_handler.dart';
import '../../screens/profile/profile_detail_screen.dart';

class ProfileCard extends StatefulWidget {
  final String id;
  final String uniqueId;
  final String name;
  final String lastName;
  final String image;
  final String designation;
  final String description;
  final String experience;
  final List<dynamic> industries;
  final List<dynamic> techSkills;

  const ProfileCard({
    super.key,
    required this.id,
    required this.uniqueId,
    required this.name,
    required this.lastName,
    required this.image,
    required this.experience,
    required this.designation,
    required this.description,
    required this.industries,
    required this.techSkills,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  String get lastNameString {
    if (widget.lastName.contains(' ')) {
      final splittedName = widget.lastName.split(' ');
      String trimmedName = '${splittedName[0]} ${splittedName[1].substring(0)}';
      return trimmedName;
    }
    return widget.lastName;
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      builder: (BuildContext context) {
        return Consumer<StateHandler>(
          builder: (context, StateHandler, _) {
            return SingleChildScrollView(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
                height: StateHandler.height,
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom * 0.1),
                child: AuthScreen(
                  hireValue: true,
                  firstName: widget.lastName,
                  lastName: widget.name,
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final profileProvider = Provider.of<ProfileInfoProvider>(context);
    final auth = Provider.of<Auth>(context);

    return InkWell(
      onTap: () {
        if (profileProvider.isFetchingMoreProfiles &&
            profileProvider.profileDataBySkills.isEmpty) {
          ShowSnackBar(
            context: context,
            color: Colors.blue[800]!,
            label: 'Please Wait Fetching More Profiles...',
          ).show();
          return;
        }
        Navigator.of(context).pushNamed(
          ProfileDetailScreen.routeName,
          arguments: widget.uniqueId,
        );
        Provider.of<StateHandler>(context, listen: false)
            .setProfileDetailScreenAppBarAndScrollState(
          appBarState: true,
          scrollState: false,
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
        padding: const EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              spreadRadius: 5,
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Hero(
                  tag: widget.uniqueId,
                  child: CustomComponents.customImageWidget(widget.image),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        SizedBox(
                          width: 130,
                          child: Text(
                            '$lastNameString ${widget.name}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.uniqueId,
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: size.width * 0.5,
                      padding: const EdgeInsets.only(
                        top: 7,
                        left: 5,
                        bottom: 5,
                      ),
                      child: Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              widget.designation,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          Text(
                            widget.experience == "0"
                                ? ', < 1 year'
                                : widget.experience == "1"
                                    ? ", 1 year"
                                    : ', ${widget.experience} years',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        for (int i = 0; i < 3; i++)
                          CustomComponents.customContainer(
                            widget.techSkills[i],
                            9,
                            true,
                          )
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              widget.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 10,
              width: 3,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Industries: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (int i = 0; i < widget.industries.length; i++)
                          GestureDetector(
                            onTap: () {},
                            child: Row(
                              children: [
                                Text(
                                  '${widget.industries[i]}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    decoration: TextDecoration.underline,
                                  ),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                ),
                                if (i < widget.industries.length - 1)
                                  const Text(', ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: CustomComponents.customTextButton(
                    label: 'Hire ${widget.lastName} ${widget.name}',
                    icon: LineIcons.sms,
                    iconColor: const Color.fromRGBO(82, 113, 255, 1),
                    iconSize: 20,
                    textStyle: Theme.of(context).textTheme.titleSmall!,
                    onPressed: () {
                      if (auth.isAuth) {
                        CustomComponents.hireRequest(
                                context, widget.lastName, widget.name)
                            .then((statusCode) {
                          if (statusCode == 201) {
                            CustomComponents.hire(
                                context, widget.lastName, widget.name);
                          } else {
                            ShowSnackBar(
                                    context: context,
                                    label: 'Error statusCode: $statusCode',
                                    color: Colors.red)
                                .show();
                          }
                        });
                      } else {
                        _showModal(context);
                      }
                    },
                  ),
                ),
                Container(
                  height: 20,
                  width: 1,
                  color: const Color.fromRGBO(211, 211, 211, 1),
                ),
                Expanded(
                  child: CustomComponents.customTextButton(
                    label: 'Download PDF',
                    icon: LineIcons.download,
                    iconColor: const Color.fromRGBO(82, 113, 255, 1),
                    iconSize: 20,
                    textStyle: Theme.of(context).textTheme.titleSmall!,
                    onPressed: () {
                      final url =
                          'https://augmntx.com/home/profile2pdf/${widget.id}';
                      CustomComponents.downloadPDF(
                        context: context,
                        url: url,
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
