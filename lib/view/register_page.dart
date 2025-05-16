import 'dart:core';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/provider/register_provider.dart';
import 'package:pokerpad/view/login_page.dart';
import 'package:pokerpad/widget/build_bold_text_widget.dart';
import 'package:pokerpad/widget/build_text_widget.dart';
import 'package:provider/provider.dart';

import '../constants/screen_size.dart';
import '../widget/build_text_field_widget.dart';

class RegisterPage extends StatefulWidget {
  final int? affiliateId;
  const RegisterPage({
    super.key,
    this.affiliateId,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // bool passwordVisible = true;
  // bool confirmPasswordVisible = true;
  // TextEditingController confirmPasswordController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  // bool isLoading = false;
  // final SignupController _signupController = SignupController();
  // final _formKey = GlobalKey<FormState>();
  // String? validateEmail(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Email cannot be empty';
  //   }
  //   const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  //   final regex = RegExp(emailPattern);
  //   if (!regex.hasMatch(value)) {
  //     return 'Enter a valid email address';
  //   }
  //   return null;
  // }
  //
  // String? validatePassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Password cannot be empty';
  //   }
  //   // Updated regex pattern to include all special characters
  //   const pattern =
  //       r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&.#])[A-Za-z\d@$!%*?&.#]{8,}$';
  //   final regex = RegExp(pattern);
  //   if (!regex.hasMatch(value)) {
  //     return 'Password must be at least 8 characters long and include '
  //         '1 uppercase letter, 1 lowercase letter, 1 number, and 1 symbol (@,  !, %, *, ?, &, #).';
  //   }
  //   return null;
  // }
  //
  // String? validateConfirmPassword(String? confirmPassword, String? password) {
  //   if (confirmPassword == null || confirmPassword.isEmpty) {
  //     return 'Please confirm your password';
  //   }
  //   if (confirmPassword != password) {
  //     return 'Passwords do not match';
  //   }
  //   return null;
  // }
  //
  // Future<void> signup() async {
  //   if (!_formKey.currentState!.validate()) return;
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final requestModel = SignupRequestModel(
  //       email: emailController.text,
  //       password: passwordController.text,
  //       deviceId: _deviceId,
  //       accountNo: "A020241027101417");
  //   try {
  //     final response = await _signupController.signup(requestModel);
  //     setState(() {
  //       isLoading = false;
  //     });
  //     if (response.status == "OK") {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           elevation: 10,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(24),
  //           ),
  //           behavior: SnackBarBehavior.floating,
  //           backgroundColor: CupertinoColors.activeGreen,
  //           content: const Text(
  //             "Signup Successfully",
  //             style: TextStyle(color: Colors.white),
  //           )));
  //       Navigator.pushReplacement(
  //           context,
  //           PageTransition(
  //               child: VerifyEmailPage(
  //                 email: requestModel.email,
  //                 deviceId: requestModel.deviceId,
  //                 id: response.id!.toInt(),
  //               ),
  //               type: PageTransitionType.rightToLeftWithFade));
  //     } else {
  //       if (response.status == "FAIL") {
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //             elevation: 10,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(24),
  //             ),
  //             behavior: SnackBarBehavior.floating,
  //             content: Text(response.commonMessage ?? "Signup Failed")));
  //
  //         // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         //     content: Text(response.commonMessage ?? "Signup Failed")));
  //       }
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         elevation: 10,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(24),
  //         ),
  //         behavior: SnackBarBehavior.floating,
  //         content: const Text("Error Signup failed..")));
  //   }
  // }
  //
  // String _deviceId = "Fetching...";
  //
  // Future<void> _getStoredDeviceId() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String? storedDeviceId = pref.getString("device_id");
  //
  //   setState(() {
  //     _deviceId = storedDeviceId ?? "No Device ID Found";
  //   });
  //   print("Updated Device ID: $_deviceId");
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _getStoredDeviceId();
  //
  //   Future.delayed(const Duration(seconds: 1), () {
  //     print("register page device id: $_deviceId");
  //   });
  // }
  late RegisterProvider registerProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    registerProvider = Provider.of<RegisterProvider>(context, listen: false);
    print("affiliate id:${widget.affiliateId}");
  }

  void signUp() {
    registerProvider.signup(affiliateId: widget.affiliateId, context);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    final registerProvider = Provider.of<RegisterProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: ScreenSize.screenHeight,
            width: ScreenSize.screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Container(
                color: Colors.transparent,
                width: 646,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height / 12,
                    ),
                    Image.asset("assets/images/register.png", width: 200),
                    SizedBox(
                      height: 10,
                    ),
                    const BuildTextWidget(
                      text: "Create your new account",
                    ),
                    const SizedBox(height: 20),
                    // Login Fields
                    Form(
                      key: registerProvider.formKey,
                      child: Column(
                        children: [
                          BuildTextFieldWidget(
                            hintText: "Email                 ",
                            keyboardType: TextInputType.emailAddress,
                            controller: registerProvider.emailController,
                            labelText: 'email',
                            validator: registerProvider.validateEmail,
                          ),
                          const SizedBox(height: 5),
                          BuildTextFieldWidget(
                            hintText: "Password",
                            labelText: "password",
                            controller: registerProvider.passwordController,
                            obscureText: !registerProvider.isPasswordVisible,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                registerProvider.togglePasswordVisibility();
                                // setState(() {
                                //   passwordVisible = !passwordVisible;
                                // });
                              },
                              child: registerProvider.isPasswordVisible
                                  ? Image.asset("assets/images/Artboard 28.png",
                                      width: 47)
                                  : Image.asset("assets/images/Artboard 29.png",
                                      width: 47),
                            ),
                            // inputFormatters: [
                            //   LengthLimitingTextInputFormatter(8)
                            // ],
                            validator: registerProvider.validatePassword,
                          ),
                          const SizedBox(height: 5),
                          BuildTextFieldWidget(
                              controller:
                                  registerProvider.confirmPasswordController,
                              labelText: "confirm password",
                              hintText: "Confirm password",
                              obscureText: !registerProvider.isPasswordVisible,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  // setState(() {
                                  //   confirmPasswordVisible =
                                  //       !confirmPasswordVisible;
                                  // });
                                },
                                child: registerProvider.isPasswordMatch
                                    ? Image.asset(
                                        "assets/images/register/Artboard 31 (2).png",
                                        width: 47)
                                    : Image.asset(
                                        "assets/images/register/Artboard 30 (2).png",
                                        width: 47),
                              ),

                              // inputFormatters: [
                              //   LengthLimitingTextInputFormatter(8)
                              // ],
                              validator:
                                  registerProvider.validateConfirmPassword
                              // (value) => validateConfirmPassword(
                              // passwordController.text, value ?? ""),
                              ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        text: 'Password must be at least ',
                        style: TextStyle(
                          color: Color(0xFF5F6368),
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: '8 characters ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: 'and contain ',
                            style: TextStyle(
                              color: Color(0xFF5F6368),
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: '1 number, ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: '1 uppercase letter, ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: '1 lowercase letter ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: ' and ',
                            style: TextStyle(
                              color: Color(0xFF5F6368),
                              fontSize: 14,
                            ),
                          ),
                          TextSpan(
                            text: '1 symbol.',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: width / 1.4,
                      height: 50,
                      child: registerProvider.errorMessage != null
                          ? Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/verifyemail/alert frame.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  registerProvider.errorMessage!,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    registerProvider.isLoading
                        ? const CircularProgressIndicator()
                        : GestureDetector(
                            onTap: () {
                              // registerProvider.signup(context);
                              signUp();
                              // if (_formKey.currentState?.validate() ??
                              //     false) {
                              //   // signup();
                              // }
                            },
                            child: Image.asset(
                              "assets/images/sign up button.png",
                              height: 59,
                            ),
                          ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const BuildTextWidget(
                          text: "Already have an account? ",
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                child: const LoginPage(),
                                type: PageTransitionType.leftToRightWithFade,
                              ),
                            );
                          },
                          child: const BuildBoldTextWidget(text: "Login"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
