import 'package:flutter/material.dart';
import 'package:pokerpad/view/scroll_pages/accessories_page.dart';
import 'package:pokerpad/view/scroll_pages/face_check_page.dart';
import 'package:pokerpad/view/scroll_pages/light_page.dart';
import 'package:pokerpad/view/scroll_pages/posture_page.dart';
import 'package:provider/provider.dart';

import '../constants/screen_size.dart';
import '../controller/gender_controller.dart';
import '../controller/signup_controller.dart';
import '../model/players_gender_request_model.dart';
import '../model/players_gender_response_model.dart';
import '../provider/login_provider.dart';
import '../widget/build_heading_widget.dart';
import '../widget/build_text_widget.dart';

class ImageScrollPage extends StatefulWidget {
  const ImageScrollPage({super.key});

  @override
  State<ImageScrollPage> createState() => _ImageScrollPageState();
}

class _ImageScrollPageState extends State<ImageScrollPage> {
  final PageController _pageController = PageController();
  bool _showButton = false;
  String? selectGender;
  bool isLoading = false;
  bool genderImage = false;
  bool canScroll = false;
  final GenderController _genderController = GenderController();

  void genderSelect(String gender) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final deviceId = loginProvider.deviceId;
    final loginId = loginProvider.playerId;
    print("login id :$loginId");
    //I/flutter (30972): Player ID: 469

    setState(() {
      isLoading = true;
    });

    PlayersGenderRequestModel request = PlayersGenderRequestModel(
      gender: gender,
      deviceId: 1,
      id: (SignupController.userId ?? loginId)!.toInt(),
    );

    PlayersGenderResponseModel? response =
        await _genderController.gender(request);

    setState(() {
      isLoading = false;
      canScroll = true; // Enable scrolling
    });

    if (response != null && response.status == "OK") {
      print(response.status);
      print("Step:${response.data?.step}");

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     duration: const Duration(milliseconds: 350),
      //     elevation: 10,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(24),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     backgroundColor: CupertinoColors.activeGreen,
      //     content: Text(
      //         "Success! Step: ${response.data!.step}, ID: ${response.data!.id}"),
      //   ),
      // );
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     elevation: 10,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(24),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     backgroundColor: CupertinoColors.destructiveRed,
      //     content: Text("Error: ${response?.message ?? 'Unknown error'}"),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
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
          Column(
            children: [
              Expanded(
                child: PageView(
                  physics: canScroll
                      ? const AlwaysScrollableScrollPhysics()
                      : const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _showButton = (index == 4);
                    });
                  },
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/gender&avatar/log-reg frame.png',
                          fit: BoxFit.cover,
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 90),
                              const BuildHeadingWidget(text: "Gender"),
                              const SizedBox(height: 40),
                              Image.asset(
                                width: width / 5,
                                "assets/images/gender&avatar/gender icon.png",
                              ),
                              const SizedBox(height: 100),
                              const BuildTextWidget(
                                text: "Select your gender",
                                fontSize: 20,
                              ),
                              const SizedBox(height: 70),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectGender = "male";
                                            genderImage = false;
                                            canScroll =
                                                true; // Unlock scrolling
                                          });
                                          genderSelect("M");
                                        },
                                        child: selectGender == "male"
                                            ? Image.asset(
                                                "assets/images/Artboard 41.png",
                                                width: 30)
                                            : Image.asset(
                                                "assets/images/empty checkmark.png",
                                                width: 30),
                                      ),
                                      const BuildTextWidget(text: "Male    "),
                                    ],
                                  ),
                                  const SizedBox(width: 80),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectGender = "female";
                                            genderImage = false;
                                            canScroll =
                                                true; // Unlock scrolling
                                          });
                                          genderSelect("F");
                                        },
                                        child: selectGender == "female"
                                            ? Image.asset(
                                                "assets/images/Artboard 41.png",
                                                width: 30)
                                            : Image.asset(
                                                "assets/images/empty checkmark.png",
                                                width: 30),
                                      ),
                                      const BuildTextWidget(
                                        text: "Female",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 80),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                      height: height / 28,
                                      "assets/images/gender&avatar/page indicator_full.png"),
                                  Image.asset(
                                      height: height / 28,
                                      "assets/images/gender&avatar/page indicator_empty.png"),
                                  Image.asset(
                                      height: height / 28,
                                      "assets/images/gender&avatar/page indicator_empty.png"),
                                  Image.asset(
                                      height: height / 28,
                                      "assets/images/gender&avatar/page indicator_empty.png"),
                                  Image.asset(
                                      height: height / 28,
                                      "assets/images/gender&avatar/page indicator_empty.png"),
                                ],
                              ),
                              SizedBox(
                                height: height / 3.5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (selectGender != null) {
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  } else {
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   SnackBar(
                                    //     content: const Text(
                                    //         "Please select a gender before proceeding."),
                                    //     backgroundColor: Colors.red,
                                    //     duration: const Duration(seconds: 2),
                                    //     behavior: SnackBarBehavior.floating,
                                    //     shape: RoundedRectangleBorder(
                                    //       borderRadius:
                                    //           BorderRadius.circular(12),
                                    //     ),
                                    //   ),
                                    // );
                                  }
                                },
                                child: Image.asset(
                                  "assets/genderpage/confirm_btn.png",
                                  width: width / 1.3,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    FaceCheckPage(
                      controller: _pageController,
                    ),
                    PosturePage(
                      controller: _pageController,
                    ),
                    LightPage(
                      controller: _pageController,
                    ),
                    AccessoriesPage(
                      controller: _pageController,
                    ),
                  ],
                ),
              ),
              if (_showButton)
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         PageTransition(
                //             child: const FrontCameraPage(),
                //             type: PageTransitionType.rightToLeftWithFade));
                //   },
                //   child: Image.asset(
                //     "assets/images/gender&avatar/proceed to camera.png",
                //     height: 55,
                //   ),
                // ),
                const SizedBox(height: 35),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
