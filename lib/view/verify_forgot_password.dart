import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/model/resetpassword_request_model.dart';
import 'package:pokerpad/view/login_page.dart';
import 'package:pokerpad/widget/build_text_widget.dart';
import 'package:provider/provider.dart';

import '../constants/screen_size.dart';
import '../controller/resetpassword_controller.dart';
import '../provider/login_provider.dart';
import '../widget/build_heading_widget.dart';
import '../widget/build_text_field_widget.dart';

class VerifyForgotPassword extends StatefulWidget {
  final String? email;
  const VerifyForgotPassword({super.key, this.email});

  @override
  State<VerifyForgotPassword> createState() => _VerifyForgotPasswordState();
}

class _VerifyForgotPasswordState extends State<VerifyForgotPassword> {
  bool passwordVisible = true;
  bool isResendEnabled = true;
  String? errorMessage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isResendEnabled = true;
  }

  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final ResetPasswordController _resetPasswordController =
      ResetPasswordController();
  bool isLoading = false;

  Future<void> resetPassword() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop execution if validation fails
    }

    setState(() {
      isLoading = true;
      errorMessage = null; // Reset error message on new request
    });

    String otpCode = _otpControllers.map((c) => c.text.trim()).join();

    if (otpCode.length < 6) {
      setState(() {
        isLoading = false;
        errorMessage = "Please enter the 6-digit OTP code.";
      });
      return;
    }

    final requestModel = ResetPasswordRequestModel(
      email: widget.email ?? "",
      otp: otpCode,
      newPassword: newPasswordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    try {
      final response =
          await _resetPasswordController.resetPassword(requestModel);

      setState(() {
        isLoading = false;
      });

      if (response?.status?.trim().toUpperCase() == "OK") {
        String successMessage =
            response?.data?['message'] ?? "Password updated successfully";

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: CupertinoColors.activeGreen,
            content: Text(successMessage,
                style: const TextStyle(color: Colors.white)),
          ),
        );

        Navigator.push(
          context,
          PageTransition(
            child: const LoginPage(),
            type: PageTransitionType.rightToLeftWithFade,
          ),
        );
      } else {
        print(response);
        setState(() {
          errorMessage = response?.message ?? "Invalid verification code";
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            behavior: SnackBarBehavior.floating,
            content: Text(errorMessage!),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error: Reset failed. Please try again.";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          behavior: SnackBarBehavior.floating,
          content: const Text("Error: Reset failed. Please try again."),
        ),
      );
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    const pattern =
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+{}\[\]:;<>,.?/~`-])[A-Za-z\d!@#$%^&*()_+{}\[\]:;<>,.?/~`-]{8,}$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Password must be at least 8 characters long and include '
          '1 uppercase letter, 1 lowercase letter, 1 number, and 1 special character.';
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String? newPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != newPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: ScreenSize.screenHeight,
            width: ScreenSize.screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                // opacity: 0.14,
                image: AssetImage(
                  "assets/images/background.jpg",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: width,
            height: height / 1.4,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image:
                    AssetImage("assets/images/phone&country/log-reg frame.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BuildHeadingWidget(text: "Forgot password"),
                const SizedBox(
                  height: 10,
                ),
                const BuildTextWidget(
                  text: "A 6-digit code has been sent to your email.",
                  color: Colors.black,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    6,
                    (index) => SizedBox(
                      height: 60,
                      width: 60,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/verifyemail/code field.png"),
                              fit: BoxFit
                                  .fill, // Ensures the image covers the text field
                            ),
                          ),
                          child: TextField(
                            controller: _otpControllers[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              counterText: "",

                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.all(
                                  15), // Ensures text stays centered
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty && index < 5) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //
                //   }, child: Image.asset(
                //     width: width / 1.4,
                //     "assets/images/verifyemail/resend code button (3).png",
                //   ),
                // ),
                GestureDetector(
                  onTap: isResendEnabled && !isLoading
                      ? () {
                          print("Resend code tapped");
                          loginProvider.forgotPassword(context);
                          setState(() {
                            isResendEnabled = false;
                          });
                          // Start timer to re-enable after 60 seconds
                          Timer(const Duration(minutes: 1), () {
                            setState(() {
                              isResendEnabled = true;
                            });
                          });
                        }
                      : null,
                  child: Opacity(
                    opacity: isResendEnabled
                        ? 1.0
                        : 0.5, // visually indicate disabled
                    child: Image.asset(
                      width: width / 1.6,
                      "assets/images/passwordchangeFromTransferpage/RESEND CODE.png",
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                SizedBox(
                  width: width / 1.24,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        BuildTextFieldWidget(
                          controller: newPasswordController,
                          hintText: "new password",
                          labelText: "new password",
                          obscureText: passwordVisible,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            child: passwordVisible
                                ? Image.asset("assets/images/Artboard 28.png",
                                    width: 47)
                                : Image.asset("assets/images/Artboard 29.png",
                                    width: 47),
                          ),
                          validator: validatePassword,
                        ),
                        BuildTextFieldWidget(
                          controller: confirmPasswordController,
                          hintText: "confirm password",
                          labelText: "confirm password",
                          obscureText: true,
                          validator: (value) => validateConfirmPassword(
                              newPasswordController.text, value ?? ""),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                confirmPasswordController.clear();
                              });
                            },
                            child: Image.asset(
                                "assets/images/pokerPadArt/Artboard 30 (1).png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: 'Password must be at least ',
                      style: TextStyle(
                        color: Color(0xFF5F6368),
                        fontSize: 13,
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
                          text: '1 number, \n',
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
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: width / 1.4,
                  height: 50, // Ensuring consistent height
                  child: errorMessage != null
                      ? Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/verifyemail/alert frame.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Text(
                                    errorMessage!,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                          ),
                        )
                      : const SizedBox(),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: const LoginPage(),
                            type: PageTransitionType.leftToRightWithFade,
                          ),
                        );
                      },
                      child: Image.asset(
                        "assets/images/verifyemail/back button.png",
                        width: width / 2.8,
                      ),
                    ),
                    isLoading
                        ? SizedBox(
                            width: width / 2.8,
                            child: const Center(
                                child: CircularProgressIndicator()))
                        : GestureDetector(
                            onTap: resetPassword,
                            child: Image.asset(
                              "assets/images/verifyemail/confirm button (1).png",
                              width: width / 2.8,
                            ),
                          ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
