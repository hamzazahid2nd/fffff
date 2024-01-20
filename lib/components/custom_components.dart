import 'package:augmntx/screens/profile/profile_properties_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '/components/show_snackbar.dart';
import '/constants/constants.dart';

mixin CustomComponents {
  static AnimatedContainer showAppBar({
    required bool show,
    required bool showActionButton,
    required bool showLeadingButton,
  }) {
    return AnimatedContainer(
      height: show ? 80.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      child: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: showLeadingButton ? const BackButton() : null,
        title: Image.asset(
          MyIcons.augmntx,
          fit: BoxFit.contain,
          height: 30,
        ),
        elevation: 0,
        actions: showActionButton
            ? [
                Builder(builder: (ctx) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Scaffold.of(ctx).openDrawer();
                        Navigator.pushNamed(ctx, profilePropertiesScreen.routeName);
                      },
                      child: CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.person, color: Colors.white,),
                        backgroundColor:Color.fromRGBO(82, 113, 255, 1),
                      ),
                    ),
                  );
                }),
              ]
            : [],
      ),
    );
  }

  static Widget customContainer(
      String info, double fontSize, bool setConstraint) {
    return Container(
      constraints: setConstraint
          ? const BoxConstraints(maxWidth: 60, minWidth: 30)
          : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(
          color: const Color.fromRGBO(82, 113, 255, 1),
        ),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(6),
      margin: const EdgeInsets.all(5),
      child: Text(
        info,
        style: TextStyle(
          fontSize: fontSize,
          height: 1.0,
          overflow: TextOverflow.ellipsis,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget progressiveDotsLoading = LoadingAnimationWidget.prograssiveDots(
    color: Colors.blue[800]!,
    size: 50,
  );

  static Widget customImageWidget(String imagePath) {
    return Card(
      shape: const CircleBorder(),
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: CachedNetworkImage(
        imageUrl: imagePath,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          radius: 40,
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white,
          child: progressiveDotsLoading,
        ),
        errorWidget: (context, url, error) => const CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(
            "https://augmntx.com/assets/img/noimage.jpg",
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  static Widget customTextButton({
    required String label,
    required IconData icon,
    required double iconSize,
    required TextStyle textStyle,
    required Color iconColor,
    double width = 100,
    required void Function() onPressed,
  }) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: iconSize,
      ),
      label: SizedBox(
        width: width,
        child: Text(
          label,
          style: textStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      style: TextButton.styleFrom(
        iconColor: iconColor,
      ),
    );
  }

  static Widget customRow(IconData icon, String title, String info) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon),
        const SizedBox(width: 5),
        SelectableText(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const Spacer(),
        SelectableText(
          info,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  static Widget customColumn(IconData icon, String title, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon),
            const SizedBox(width: 5),
            SelectableText(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        SelectableText(
          info,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  static Future<void> downloadPDF({
    required BuildContext context,
    required String url,
  }) async {
    final pdfUrl = Uri.parse(url);
    await launcher.canLaunchUrl(pdfUrl).then((canUrlLaunch) {
      if (canUrlLaunch) {
        launcher.launchUrl(
          pdfUrl,
          mode: launcher.LaunchMode.externalApplication,
        );
      } else {
        ShowSnackBar(
          context: context,
          color: Colors.red,
          label: 'Cannot Download PDF!',
        ).show();
      }
    });
  }

  static void sendEmailToAugmntx(String email) {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': 'General Queries',
      }),
    );
    launcher.launchUrl(
      emailLaunchUri,
      mode: launcher.LaunchMode.externalApplication,
    );
  }

  static void contactAugmntxThroughSMS(String number) {
    final Uri smsLaunchUri = Uri(
      scheme: 'sms',
      path: number,
    );
    launcher.launchUrl(
      smsLaunchUri,
      mode: launcher.LaunchMode.externalApplication,
    );
  }

  static Future<int> hireRequest(
      BuildContext context, String name, String lastName) async {
    try {
      var data = {"name": name, "job": lastName};
      var response =
          await http.post(Uri.https('reqres.in', 'api/users'), body: data);
      print(response.body);
      var responseStatus = response.statusCode;
      return responseStatus;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> hire(
      BuildContext context, String name, String lastName) async {
    await showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (_) => Container(
        height: 300,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Text(
          '''Your request to interview $name $lastName has been accepted and our team will reach out on your registered number within 24 Hours.\n\nAdditionally you can also reach out to us now +91 637 490 9636''',
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
