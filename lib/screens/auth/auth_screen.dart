import 'dart:async';
import 'package:augmntx/components/auto_scroll.dart';
import 'package:augmntx/components/small_profile_widget.dart';
import 'package:augmntx/screens/auth/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/show_snackbar.dart';
import '../../components/web_view.dart';
import '../../handlers/state_handler.dart';
import '/constants/constants.dart';
import '/provider/auth_provider.dart';
import '/screens/auth/custom_text_field.dart';
import '/screens/profile/profile_screen.dart';
import 'package:augmntx/model/DummyProfile.dart';
enum AuthMode { signup, login }

class AuthScreen extends StatefulWidget {
  bool? hireValue;
  String? firstName;
  String? lastName;
  AuthScreen({super.key, this.hireValue, this.firstName, this.lastName});
  static const routeName = '/auth-screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.login;
  final _passwordFocusNode = FocusNode();
  final _lastNameFocusNode = FocusNode();
  final _jobFocusNode = FocusNode();
  final _companyFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _workEmailFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  final Map<String, String> _loginAuthData = {
    'email': '',
    'password': '',
  };

  final Map<String, String> _signUpAuthData = {
    'first_name': '',
    'last_name': '',
    'job_title': '',
    'company_name': '',
    'work_email': '',
    'phone': '',
  };

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
    }
  }

  bool _isLoading = false;

  String firstName = '';
  String lastName = '';
  bool ishiring = false;
  bool isPushed = false;


  @override
  void initState() {
    super.initState();
    setState(() {
      if (widget.hireValue == true) {
        ishiring = true;
        firstName = widget.firstName.toString();
        lastName = widget.lastName.toString();
      }
    });

  }


  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_authMode == AuthMode.login) {
      await Provider.of<Auth>(context, listen: false)
          .loginWithEmailAndPassword(
            email: _loginAuthData['email']!,
            password: _loginAuthData['password']!,
          )
          .catchError((_) => ShowSnackBar(
                color: Colors.red,
                context: context,
                label: 'Login Failed!',
              ).show());
    } else {
      final response1 =
          await Provider.of<Auth>(context, listen: false).otpVerification(
        firstName: _signUpAuthData['first_name']!,
        jobTitle: _signUpAuthData['job_title']!,
        companyName: _signUpAuthData['company_name']!,
        workEmail: _signUpAuthData['work_email']!,
        phone: _signUpAuthData['phone']!,
      );

      if (response1.isNotEmpty) {
        if (widget.hireValue == true) {
          // ignore: use_build_context_synchronously
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              builder: (_) {
                return SingleChildScrollView(
                  child: GestureDetector(
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom * 0.2),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2 +
                            MediaQuery.of(context).viewInsets.bottom,
                        margin: const EdgeInsets.all(10),
                        child: OtpScreen.name(
                          _signUpAuthData['first_name']!,
                          _signUpAuthData['job_title']!,
                          _signUpAuthData['company_name']!,
                          _signUpAuthData['work_email']!,
                          _signUpAuthData['phone']!,
                          '${response1['otp']}',
                        ),
                      ),
                    ),
                  ),
                );
              });
        } else {
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen.name(
                _signUpAuthData['first_name']!,
                _signUpAuthData['job_title']!,
                _signUpAuthData['company_name']!,
                _signUpAuthData['work_email']!,
                _signUpAuthData['phone']!,
                '${response1['otp']}',
              ),
            ),
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Future<void> _signInWithGoogle() async {
  //   await Provider.of<Auth>(context, listen: false)
  //       .signInWithGoogle()
  //       .catchError((_) => ShowSnackBar(
  //             color: Colors.red,
  //             context: context,
  //             label: 'Login Failed!',
  //           ).show());
  // }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  // InfiniteScrollController sc = InfiniteScrollController();


  @override
  Widget build(BuildContext context) {
    bool isPushed = ModalRoute.of(context)?.settings.arguments != null;
    final auth = Provider.of<Auth>(context, listen: false);
    final navigatorContext = Navigator.of(context);
    final appBarState = Provider.of<StateHandler>(context, listen: false);
    final authstate = Provider.of<StateHandler>(context);

    List<Widget> DummyProfileWidgetList = DummyProfileList.map((e) => SmallProfileWidget(e)).toList();

    return Scaffold(
      appBar: isPushed
          ? AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              leading: BackButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          : AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          // Add the Skip button to the AppBar
          TextButton.icon(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('skipAuthentication', true);
              navigatorContext.pushReplacementNamed(ProfileScreen.routeName);
              appBarState.setProfileScreenAppBarAndScrollState(
                appBarState: true,
                scrollState: false,
              );
            },
            label: Text(
              'Skip',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ), icon: Icon(Icons.fast_forward),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              //
            mainAxisAlignment:_authMode == AuthMode.signup ?  MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              _authMode == AuthMode.login ? Container(

                decoration: BoxDecoration(
                  // color: Colors.yellow,
                ),

              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: AutoScrollable(DummyProfileWidgetList,200,)),
                ],
              ),
              ) : Container(),
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: isPushed || widget.hireValue == true
                      ? const EdgeInsets.symmetric(horizontal: 20)
                      : const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: _isLoading
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.stretch,
                    children: [
                      ishiring
                          ? Container()
                          : SizedBox(
                              height: 38,
                              child: Image.asset(
                                MyIcons.augmntx,
                                fit: BoxFit.contain,
                                // height: 40,
                              ),
                            ),
          
                      ishiring
                          ? Text.rich(
                              _authMode == AuthMode.signup
                                  ? TextSpan(
                                      text: 'Register to hire ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                      children: [
                                          TextSpan(
                                            text: '$firstName $lastName',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff11049a),
                                            ),
                                          )
                                        ])
                                  : TextSpan(
                                      text: 'Login to hire ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700],
                                      ),
                                      children: [
                                          TextSpan(
                                            text: '$firstName $lastName',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff11049a),
                                            ),
                                          )
                                        ]),
                              textAlign: TextAlign.center,
                            )
                          : Center(
                              child: Text(
                                _authMode == AuthMode.signup
                                    ? 'Create a new account'
                                    : 'sign in to start your session',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                      ishiring
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _authMode == AuthMode.login
                                      ? 'Not a member?'
                                      : 'Already a member?',
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    _switchAuthMode();
                                    if (_authMode == AuthMode.login) {
                                      authstate.setAuthMode(400);
                                    } else if (_authMode == AuthMode.signup) {
                                      authstate.setAuthMode(700);
                                    }
                                  },
                                  child: Text(
                                    _authMode == AuthMode.login
                                        ? 'Register Now'
                                        : 'Login Now',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(82, 113, 255, 1),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Container(),
          
                      const SizedBox(height: 10),
          
                      // Login Mode
                      if (_authMode == AuthMode.login) ...[
                        CustomTextField(
                          focusNode: null,
                          key: const Key('email'),
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_passwordFocusNode);
                          },
                          controller: _emailController,
                          validator: (email) {
                            if (email!.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                          onSaved: (email) {
                            _loginAuthData['email'] = email!.trim();
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          key: const Key('pass'),
                          obscureText: true,
                          hintText: 'Password',
                          keyboardType: TextInputType.text,
                          focusNode: _passwordFocusNode,
                          controller: _passwordController,
                          textInputAction: (_authMode == AuthMode.login)
                              ? TextInputAction.done
                              : TextInputAction.next,
                          onFieldSubmitted: (_) => _submit(),
                          validator: (pass) {
                            if (pass!.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                          onSaved: (pass) {
                            _loginAuthData['password'] = pass!.trim();
                          },
                        ),
                      ],
          
                      // Sign Up Mode
                      if (_authMode == AuthMode.signup) ...[
                        CustomTextField(
                          focusNode: null,
                          key: const Key('first_name'),
                          hintText: 'Full name',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_lastNameFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field is required';
                            }
                            final trimmedValue = value.trim();
                            if (!trimmedValue.contains(' ') ||
                                trimmedValue.indexOf(' ') == 0 ||
                                trimmedValue.lastIndexOf(' ') ==
                                    trimmedValue.length - 1) {
                              return 'Please enter a valid full name';
                            }
                            return null;
                          },
                          onSaved: (fistName) {
                            _signUpAuthData['first_name'] = fistName!.trim();
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          key: const Key('jobTitle'),
                          hintText: 'Job Title',
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: _jobFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_companyFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                          onSaved: (jobTitle) {
                            _signUpAuthData['job_title'] = jobTitle!.trim();
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          key: const Key('companyName'),
                          hintText: 'Company Name',
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: _companyFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_workEmailFocusNode);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                          onSaved: (companyName) {
                            _signUpAuthData['company_name'] = companyName!.trim();
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          key: const Key('workEmail'),
                          hintText: 'Work Email',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          focusNode: _workEmailFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_phoneFocusNode);
                          },
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return 'This field is required';
                            }
          
                            final emailRegExp = RegExp(
                              r'^[\w-]+(\.[\w-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*(\.[A-Za-z]{2,})$',
                            );
          
                            if (!emailRegExp.hasMatch(email)) {
                              return 'Invalid email!';
                            }
          
                            return null;
                          },
                          onSaved: (workEmail) {
                            _signUpAuthData['work_email'] = workEmail!.trim();
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          key: const Key('phone'),
                          hintText: 'Phone',
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          focusNode: _phoneFocusNode,
                          onFieldSubmitted: (_) {},
                          maxLength: 13,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'This field is required';
                            }
                            return null;
                          },
                          onSaved: (phone) {
                            _signUpAuthData['phone'] = phone!.trim();
                          },
                        ),
                      ],
          
                      const SizedBox(height: 10),
                      if (_isLoading)
                        CircularProgressIndicator(
                          color: Colors.blue[900],
                        )
                      else
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
                          onPressed: () {
                            _submit().whenComplete(() async {
                              await auth.tryAutoLogin();
                              if (auth.isAuth) {
                                navigatorContext
                                    .pushReplacementNamed(ProfileScreen.routeName);
                                appBarState.setProfileScreenAppBarAndScrollState(
                                  appBarState: true,
                                  scrollState: false,
                                );
                              }
                            });
                          },
                          child: Text(
                            _authMode == AuthMode.login ? 'Sign In' : 'Sign Up',
                            style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      Visibility(
                        visible: _authMode == AuthMode.login,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              WebViewScreen.routeName,
                              arguments: {
                                'url': 'https://augmntx.com/forgot-password'
                              },
                            );
                            Scaffold.of(context).closeDrawer();
                          },
                          child: Text(
                            _authMode == AuthMode.login ? 'Forgot Password?' : '',
                            style: const TextStyle(
                              color: Color.fromRGBO(82, 113, 255, 1),
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 20),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: Divider(
                      //         thickness: 0.5,
                      //         color: Colors.grey.shade500,
                      //       ),
                      //     ),
                      //     Text(
                      //       'Or continue with',
                      //       style: TextStyle(
                      //         color: Colors.grey[700],
                      //         fontSize: 14,
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: Divider(
                      //         thickness: 0.5,
                      //         color: Colors.grey.shade500,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(height: 20),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     SocialLoginButton(
                      //       icon: MyIcons.google,
                      //       onTap: () {
                      //         _signInWithGoogle().whenComplete(() async {
                      //           await auth.tryAutoLogin();
                      //           if (auth.isAuth) {
                      //             navigatorContext
                      //                 .pushReplacementNamed(ProfileScreen.routeName);
                      //           }
                      //         });
                      //       },
                      //     ),
                      //     const SizedBox(width: 10),
                      //     SocialLoginButton(
                      //       icon: MyIcons.apple,
                      //       onTap: () {
                      //         ShowSnackBar(
                      //           color: const Color.fromRGBO(82, 113, 255, 1),
                      //           context: context,
                      //           label: 'Coming soon...',
                      //         ).show();
                      //       },
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 10),
          
                      ishiring
                          ? Container()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _authMode == AuthMode.login
                                      ? 'Not a member?'
                                      : 'Already a member?',
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: _switchAuthMode,
                                  child: Text(
                                    _authMode == AuthMode.login
                                        ? 'Register Now'
                                        : 'Login Now',
                                    style: const TextStyle(
                                      color: Color.fromRGBO(82, 113, 255, 1),
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
