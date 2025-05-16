import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokerpad/widget/transfer_text_field_widget.dart';

import '../controller/forgot_password_controller.dart';
import '../controller/resetpassword_controller.dart';
import '../model/forgot_password_model.dart';
import '../model/login_response_model.dart';
import '../model/resetpassword_request_model.dart';
import 'build_sub_heading_text.dart';
import 'build_text_widget.dart';

class TransferForgotPasswordWidget extends StatefulWidget {
  final LoginResponseModel? playerResponse;

  const TransferForgotPasswordWidget({super.key, this.playerResponse});

  @override
  State<TransferForgotPasswordWidget> createState() =>
      _TransferForgotPasswordWidgetState();
}

class _TransferForgotPasswordWidgetState
    extends State<TransferForgotPasswordWidget> {
  bool isResendEnabled = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isResendEnabled = true;
    forgotPassword();
  }

  bool localIsLoading = false;

  Future<void> forgotPassword() async {
    setState(() {
      localIsLoading = true;
    });

    final request = ForgotPasswordRequestModel(
      email: widget.playerResponse?.data?.email ?? "",
    );
    print("forgot request email:${request.email}");
    try {
      final response = await ForgotPasswordController().forgotPassword(request);

      setState(() {
        localIsLoading = false;
      });
    } catch (e, stackTrace) {
      setState(() {
        localIsLoading = false;
      });
      debugPrint('Forgot password error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  bool passwordVisible = true;
  String? errorMessage;
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
      // email: "gamer100@gmail.com",
      // newPassword: "Gamer@12a",
      // confirmPassword: "Gamer@12a",
      // otp: "123456"
      email: widget.playerResponse?.data!.email ?? "",
      otp: otpCode,
      newPassword: newPasswordController.text,
      confirmPassword: confirmPasswordController.text,
    );

    try {
      print("Sending reset password request...");
      print("Email: ${requestModel.email}");
      print("OTP: ${requestModel.otp}");
      print("New Password: ${requestModel.newPassword}");
      print("Confirm Password: ${requestModel.confirmPassword}");
      final response =
          await _resetPasswordController.resetPassword(requestModel);

      setState(() {
        isLoading = false;
      });

      if (response?.status == "OK") {
        print("Password updated successfully");
        String successMessage =
            response?.data?['message'] ?? "Password updated successfully";

        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext imageDialogContext) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.of(imageDialogContext).pop(); // Close image dialog
                Navigator.of(context)
                    .pop(); // Close TransferForgotPasswordWidget
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Dialog(
                  alignment: Alignment.topCenter,
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.zero,
                  child: Stack(
                    children: [
                      Image.asset(
                        width: MediaQuery.of(context).size.width / 1.7,
                        "assets/images/transfer (2)/successful popup.png",
                        fit: BoxFit.contain,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 70, left: 70),
                        child: Column(
                          children: [
                            BuildSubHeadingText(
                              text: "password successfully",
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              "Your new password is \nnow effective",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );

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

        // Navigator.push(
        //   context,
        //   PageTransition(
        //     child: const LoginPage(),
        //     type: PageTransitionType.rightToLeftWithFade,
        //   ),
        // );
      } else {
        print("error message: ");
        print(response?.message);
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
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Dialog(
        alignment: Alignment.topCenter,
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width / 1,
          height: MediaQuery.sizeOf(context).height / 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                'assets/images/passwordchangeFromTransferpage/password frame.png',
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 35,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const BuildTextWidget(
                      text: "A 6-digit code has been sent to your email.",
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 2,
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
                                      "assets/images/passwordchangeFromTransferpage/code text field (1).png"),
                                  fit: BoxFit
                                      .fill, // Ensures the image covers the text field
                                ),
                              ),
                              child: TextField(
                                cursorColor: Colors.white,
                                controller: _otpControllers[index],
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                maxLength: 1,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
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
                    //     forgotPassword();
                    //     print("clicked resend button");
                    //   },
                    //   child: Image.asset(
                    //     width: width / 1.6,
                    //     "assets/images/passwordchangeFromTransferpage/RESEND CODE.png",
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: isResendEnabled && !localIsLoading
                          ? () {
                              forgotPassword();
                              print("Resend code tapped");
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

                    SizedBox(
                      width: width / 1.24,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TransferTextFieldWidget(
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
                                    ? Image.asset(
                                        "assets/images/passwordchangeFromTransferpage/visibility off.png",
                                        width: 47)
                                    : Image.asset(
                                        "assets/images/passwordchangeFromTransferpage/visibility on.png",
                                        width: 47),
                              ),
                              validator: validatePassword,
                            ),
                            TransferTextFieldWidget(
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
                                    width: 47,
                                    "assets/images/passwordchangeFromTransferpage/password rejection.png"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80, right: 80),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          text: 'Password must be at least ',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(
                              text: '8 characters ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: 'and contain ',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: '1 number, \n',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: '1 uppercase letter, ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: '1 lowercase letter ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: ' and ',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            TextSpan(
                              text: '1 symbol.',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 9,
                    ),
                    SizedBox(
                      width: width / 1.62,
                      height: 40, // Ensuring consistent height
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
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                    isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : GestureDetector(
                            onTap: () {
                              resetPassword();
                            },
                            child: Image.asset(
                              "assets/images/passwordchangeFromTransferpage/proceed (1).png",
                              width: width / 1.6,
                            ),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
