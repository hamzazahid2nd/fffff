import 'dart:async';

import 'package:augmntx/constants/constants.dart';
import 'package:augmntx/handlers/state_handler.dart';
import 'package:augmntx/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:augmntx/components/show_snackbar.dart';
import '/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String firstName;
  final String jobTitle;
  final String companyName;
  final String workEmail;
  final String phone;
  String otp;

  OtpScreen.name(this.firstName, this.jobTitle, this.companyName,
      this.workEmail, this.phone, this.otp,
      {super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  void _toProfileScreen() {
    final appBarState = Provider.of<StateHandler>(context, listen: false);

    Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
    appBarState.setProfileScreenAppBarAndScrollState(
      appBarState: true,
      scrollState: false,
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
          content: SelectableText(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _toProfileScreen();
                // Navigator.of(context).pop();
              },
              child: Text(
                'Okay!',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _loginAccount(String email, String password) async {
    await Provider.of<Auth>(context, listen: false)
        .loginWithEmailAndPassword(
          email: email,
          password: password,
        )
        .catchError((_) => ShowSnackBar(
              color: Colors.red,
              context: context,
              label: 'Login Failed!',
            ).show());
  }

  Future<void> _registerAccount() async {
    final response =
        // ignore: use_build_context_synchronously
        await Provider.of<Auth>(context, listen: false).registerAccount(
      firstName: widget.firstName,
      jobTitle: widget.jobTitle,
      companyName: widget.companyName,
      workEmail: widget.workEmail,
      phone: widget.phone,
    );

    if (response.isNotEmpty) {
      final responseString =
          'Email: ${response['email']}\nPassword: ${response['password']}';
      _showDialog('Account Created Successfuly', responseString);

      setState(() {
        _email = response['email'];
        _password = response['password'];
      });
    } else {
      ShowSnackBar(
        color: Colors.red,
        context: context,
        label: 'Failed to Create Account',
      ).show();
    }
  }

  Future<void> _resendOTP() async {
    final response1 =
        await Provider.of<Auth>(context, listen: false).otpVerification(
      firstName: widget.firstName,
      jobTitle: widget.jobTitle,
      companyName: widget.companyName,
      workEmail: widget.workEmail,
      phone: widget.phone,
    );

    setState(() {
      widget.otp = '${response1['otp']}';
    });

    ShowSnackBar(
            context: context,
            label: "A new OTP has been sent successfully.",
            color: Colors.green)
        .show();
  }

  TextEditingController controller1 = TextEditingController();

  TextEditingController controller2 = TextEditingController();

  TextEditingController controller3 = TextEditingController();

  TextEditingController controller4 = TextEditingController();

  String _email = '';
  String _password = '';

  bool isDisabled = false;
  int seconds = 60;
  late Timer timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        if (seconds > 0) {
          seconds--;
          // print(seconds);
        } else {
          timer.cancel();
          setState(() {
            isDisabled = false;
            seconds = 60;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ListView(children: [
            Text(
              'OTP - Verification',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'We have sent you a 4 digit OTP code to the following email. Verify your account to continue',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.grey[900],
              ),
            ),
            Text(
              widget.workEmail,
              style: GoogleFonts.quicksand(
                fontSize: 13,
                color: const Color.fromRGBO(82, 113, 255, 1),
                fontWeight: FontWeight.w500,
              ),
            ),
            const Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 68,
                  width: 65,
                  child: TextField(
                    controller: controller1,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    decoration: otpInput,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                SizedBox(
                  height: 68,
                  width: 65,
                  child: TextField(
                    controller: controller2,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: otpInput,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                SizedBox(
                  height: 68,
                  width: 65,
                  child: TextField(
                    controller: controller3,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                    decoration: otpInput,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                SizedBox(
                  height: 68,
                  width: 65,
                  child: TextField(
                    controller: controller4,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                    onChanged: (value) async {
                      if (value.length == 1) {
                        final addedOTP =
                            '${controller1.text}${controller2.text}${controller3.text}${controller4.text}';
                        if (widget.otp == addedOTP) {
                          ShowSnackBar(
                                  context: context,
                                  label: "Account successfully created",
                                  color: Colors.green)
                              .show();
                          await _registerAccount();
                          await _loginAccount(_email, _password);

                          // Navigator.pop(context);
                        } else {
                          ShowSnackBar(
                                  context: context,
                                  label: "Wrong OTP",
                                  color: Colors.red)
                              .show();
                          controller1.clear();
                          controller2.clear();
                          controller3.clear();
                          controller4.clear();
                        }
                      }
                    },
                    decoration: otpInput,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
              ],
            ),
            isDisabled
                ? Row(
                    children: [
                      Text(
                        'Time to resend the OTP: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.grey[900],
                        ),
                      ),
                      Text(
                        '$seconds',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color.fromRGBO(82, 113, 255, 1),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            const Gap(50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                fixedSize: const Size(300, 55),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 8.0,
                ),
                backgroundColor: const Color.fromRGBO(82, 113, 255, 1),
              ),
              onPressed: !isDisabled
                  ? () async {
                      await _resendOTP();
                      setState(() {
                        isDisabled = true;
                      });
                      startTimer();
                    }
                  : null,
              child: Text(
                'Re-send OTP ?',
                style: GoogleFonts.quicksand(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
