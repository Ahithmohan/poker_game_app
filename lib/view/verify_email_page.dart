import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/controller/verification_controller.dart';
import 'package:pokerpad/model/verification_request_model.dart';
import 'package:pokerpad/view/image_scroll_page.dart';
import 'package:pokerpad/widget/build_text_widget.dart';
import 'package:provider/provider.dart';

import '../constants/screen_size.dart';
import '../controller/forgot_password_controller.dart';
import '../model/forgot_password_model.dart';
import '../provider/login_provider.dart';

class VerifyEmailPage extends StatefulWidget {
  final String? email;
  final String? deviceId;
  final int? id;
  const VerifyEmailPage({super.key, this.email, this.deviceId, this.id});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isLoading = false;
  bool isResendEnabled = true;

  String? _errorText; // Error message for OTP validation
  final VerificationController _verificationController =
      VerificationController();
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  bool localIsLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isResendEnabled = true;
  }

  Future<void> forgotPassword() async {
    setState(() {
      localIsLoading = true;
    });

    final request = ForgotPasswordRequestModel(
      email: widget.email ?? "",
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

  Future<void> verify() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final deviceId = loginProvider.deviceId;
    final loginId = loginProvider.playerId;
    final loginEmail = loginProvider.playerDetails?.data?.email;
    print("login id :$loginId");
    print("login email :$loginEmail");
    print("login device id :$deviceId");
    setState(() {
      _errorText = null; // Reset error message
    });

    // Check if all OTP fields are filled
    bool isAnyFieldEmpty =
        _otpControllers.any((controller) => controller.text.isEmpty);

    if (isAnyFieldEmpty) {
      setState(() {
        _errorText = "Please type the verification code.";
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    final otp = _otpControllers.map((controller) => controller.text).join();
    final requestModel = VerificationRequestModel(
      email: widget.email ?? loginEmail!,
      otp: otp,
      deviceId: widget.deviceId ?? deviceId,
      id: widget.id ?? loginId!,
    );

    final response = await _verificationController.verify(requestModel);

    setState(() {
      isLoading = false;
    });

    if (response != null && response.status == "OK") {
      print("Step:${response.data?.step}");
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     elevation: 10,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(24),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     backgroundColor: CupertinoColors.activeGreen,
      //     content: const Text(
      //       "Verification Successful",
      //       style: TextStyle(color: Colors.white),
      //     )));
      Navigator.push(
          context,
          PageTransition(
              child: const ImageScrollPage(),
              type: PageTransitionType.rightToLeftWithFade));
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     elevation: 10,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(24),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     content:
      //         Text(response?.messages?["common"] ?? "Verification failed")));
      setState(() {
        _errorText =
            response?.messages?["common"] ?? "Invalid verification code!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
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
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // const BuildHeadingText(text: "Verify Email"),
                  const BuildTextWidget(
                    text: "Verify Email",
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.black54,
                  ),
                  const SizedBox(height: 10),
                  const Icon(
                    Icons.mail_outline,
                    color: Colors.black26,
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  const BuildTextWidget(
                    fontSize: 18,
                    align: TextAlign.center,
                    text:
                        "A 4-digit verification code has been sent to your email.\n Enter the code below.",
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      4,
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
                                if (value.isNotEmpty && index < 3) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // GestureDetector(
                  //   onTap: () {
                  //     // Resend OTP logic
                  //   },
                  //   child: Image.asset(
                  //     width: width / 1.4,
                  //     "assets/images/verifyemail/resend code button (3).png",
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
                        width: width / 1.4,
                        "assets/images/verifyemail/resend code button (3).png",
                      ),
                    ),
                  ),

                  // if (_errorText != null) ...[
                  //   Container(
                  //     width: width / 1.4,
                  //     height: 50,
                  //     decoration: const BoxDecoration(
                  //       image: DecorationImage(
                  //           image: AssetImage(
                  //               "assets/images/verifyemail/alert frame.png"),
                  //           fit: BoxFit.cover),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         _errorText!,
                  //         style: const TextStyle(
                  //           color: Colors.black, // Text color
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ],
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: width / 1.4,
                    height: 50, // Ensuring consistent height
                    child: _errorText != null
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
                                _errorText!,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                        : const SizedBox(), // Empty SizedBox maintains the height
                  ),
                  const SizedBox(height: 40),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/verifyemail/back button.png",
                        width: width / 2.8,
                      ),
                      isLoading
                          ? SizedBox(
                              width: width / 2.8,
                              child: const Center(
                                  child: CircularProgressIndicator()))
                          : GestureDetector(
                              onTap: verify,
                              child: Image.asset(
                                "assets/images/verifyemail/confirm button (1).png",
                                width: width / 2.8,
                              ),
                            ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
