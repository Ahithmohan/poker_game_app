import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/controller/signup_controller.dart';
import 'package:pokerpad/controller/terms_controller.dart';
import 'package:pokerpad/model/terms_request_model.dart';
import 'package:pokerpad/model/terms_response_model.dart';
import 'package:pokerpad/view/login_page.dart';
import 'package:pokerpad/widget/build_heading_widget.dart';
import 'package:pokerpad/widget/build_text_widget.dart';
import 'package:provider/provider.dart';

import '../constants/screen_size.dart';
import '../provider/login_provider.dart';

class TermsPage extends StatefulWidget {
  const TermsPage({super.key});

  @override
  State<TermsPage> createState() => _TermsPageState();
}

class _TermsPageState extends State<TermsPage> {
  bool checker = false;
  bool checker2 = false;
  bool isLoading = false;
  final TermsController _termsController = TermsController();

  Future<void> acceptTerms() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final loginId = loginProvider.playerId;
    if (!checker) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     elevation: 10,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(24),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     backgroundColor: CupertinoColors.destructiveRed,
      //     content: const Text(
      //       "Please confirm that you have read the Terms of Service",
      //       style: TextStyle(color: Colors.white),
      //     )));

      return;
    }
    if (!checker2) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     elevation: 10,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(24),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     backgroundColor: CupertinoColors.destructiveRed,
      //     content: const Text(
      //       "Please confirm that you have read the Terms of Service",
      //       style: TextStyle(color: Colors.white),
      //     ),
      //   ),
      // );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      TermsRequestModel request = TermsRequestModel(
        tos: "true",
        deviceId: 1,
        id: SignupController.userId ?? loginId!,
      );

      TermsResponseModel? response = await _termsController.terms(request);

      if (response != null && response.status == "OK") {
        Navigator.push(
          context,
          PageTransition(
            child: const LoginPage(),
            type: PageTransitionType.rightToLeftWithFade,
          ),
        );
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content:
        //         Text('Failed to accept the terms. Please try again later.'),
        //     duration: Duration(seconds: 2),
        //   ),
        // );
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('An error occurred: $e'),
      //     duration: const Duration(seconds: 2),
      //   ),
      // );
    } finally {
      setState(() {
        isLoading = false;
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
            height: height / 1.1,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/terms/terms bg.png")),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BuildHeadingWidget(text: "Terms and Conditions"),
                const SizedBox(height: 45),
                Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          "assets/images/terms/terms text field.png"),
                      fit: BoxFit.fill, // Ensures the image fills the container
                    ),
                  ),
                  width: width / 1.4,
                  height: height / 1.7,
                  child: Padding(
                    padding: const EdgeInsets.all(
                        16.0), // Adds spacing from the edges
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(
                            12.0), // Inner padding for better spacing
                        decoration: const BoxDecoration(),
                        child: const BuildTextWidget(
                          fontSize: 15,
                          text:
                              "Contrary to popular belief, Lorem Ipsum... Contrary to popular belief, Lorem Ipsum is not simply random text. "
                              "It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, "
                              "a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, "
                              "from a Lorem Ipsum passage and discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 "
                              "of (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, "
                              "very popular during the Renaissance. The first line of Lorem Ipsum, comes from a line in section 1.10.32. "
                              "The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested...Contrary to popular belief, Lorem Ipsum... Contrary to popular belief, Lorem Ipsum is not simply random text. "
                              "It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, "
                              "a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, "
                              "from a Lorem Ipsum passage and discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 "
                              "of (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, "
                              "very popular during the Renaissance. The first line of Lorem Ipsum, comes from a line in section 1.10.32. "
                              "The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested...",
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          checker = !checker;
                        });
                      },
                      child: Image.asset(
                        checker
                            ? "assets/images/Artboard 41.png"
                            : "assets/images/empty checkmark.png",
                        width: 30,
                      ),
                    ),
                    const SizedBox(width: 19),
                    const BuildTextWidget(
                      text: "I agree with the Terms and Conditions.",
                      fontSize: 14,
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          checker2 = !checker2;
                        });
                      },
                      child: Image.asset(
                        checker2
                            ? "assets/images/Artboard 41.png"
                            : "assets/images/empty checkmark.png",
                        width: 30,
                      ),
                    ),
                    const SizedBox(width: 19),
                    const BuildTextWidget(
                      text: "I confirm that i am over 18 years old.   ",
                      fontSize: 14,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     SizedBox(
                //       width: 170,
                //       height: 40,
                //       child: ElevatedButton(
                //         onPressed: () {},
                //         style: const ButtonStyle(
                //           backgroundColor: WidgetStatePropertyAll(Colors.black),
                //         ),
                //         child: const Text(
                //           "Decline",
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 20),
                //     SizedBox(
                //       width: 170,
                //       height: 40,
                //       child: isLoading
                //           ? const Center(child: CircularProgressIndicator())
                //           : ElevatedButton(
                //               onPressed: acceptTerms,
                //               style: const ButtonStyle(
                //                 backgroundColor:
                //                     WidgetStatePropertyAll(Colors.white),
                //               ),
                //               child: const Text(
                //                 "Accept",
                //                 style: TextStyle(color: Colors.black),
                //               ),
                //             ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                  width: width / 1.25,
                  child: GestureDetector(
                      onTap: () {
                        acceptTerms();
                      },
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Image.asset(
                              "assets/images/enter_pokerpad_button.png")))),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
