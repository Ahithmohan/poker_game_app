import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/controller/choose_avatar_controller.dart';
import 'package:pokerpad/model/choose_avatar_request_model.dart';
import 'package:pokerpad/model/choose_avatar_response_model.dart';
import 'package:pokerpad/view/pick_secondary_avatar.dart';
import 'package:pokerpad/view/proof_of_identity_screen.dart';

import '../widget/build_heading_widget.dart';

class ViewSecondaryAvatar extends StatefulWidget {
  final String selectedImageUrl;

  const ViewSecondaryAvatar({super.key, required this.selectedImageUrl});

  @override
  State<ViewSecondaryAvatar> createState() => _ViewSecondaryAvatarState();
}

class _ViewSecondaryAvatarState extends State<ViewSecondaryAvatar> {
  bool isLoading = false;
  final ChooseAvatarController _chooseAvatarController =
      ChooseAvatarController();
  Future<void> chooseAvatar() async {
    setState(() {
      isLoading = true;
    });
    ChooseAvatarRequestModel requestModel =
        ChooseAvatarRequestModel(secondary: widget.selectedImageUrl);
    ChooseAvatarResponseModel? responseModel =
        await _chooseAvatarController.chooseAvatar(requestModel, context);
    try {
      if (responseModel != null && responseModel.status == "OK") {
        print("Avatar upload successfully");
        print(widget.selectedImageUrl);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     duration: const Duration(milliseconds: 350),
        //     content:
        //         Text("Avatar upload successfully ${responseModel.status}")));
        Navigator.push(
            context,
            PageTransition(
                child: const ProofOfIdentityScreen(),
                type: PageTransitionType.rightToLeftWithFade));
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text('Failed to upload avatar'),
        //     duration: Duration(milliseconds: 400),
        //   ),
        // );
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('An error occurred while uploading avatar'),
      //     duration: Duration(milliseconds: 400),
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
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 70,
                ),
                const BuildHeadingWidget(text: "Pick secondary Avatar"),
                const SizedBox(
                  height: 60,
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Frame Image
                    Image.asset(
                      "assets/images/pokerPadArt/golden selection frame.png",
                      height: 470,
                      // width: 280,
                    ),
                    // Avatar Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          9), // Ensure image fits within the frame's radius
                      child: Image.network(
                        widget.selectedImageUrl,
                        height: 452,
                        width: 360,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 60,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PickSecondaryAvatar(),
                          ));
                    },
                    child: Image.asset(
                        width: width / 2.5,
                        "assets/images/primaryAvatar/change avatar button (2).png"),
                  ),
                  GestureDetector(
                    onTap: () {
                      chooseAvatar();
                    },
                    child: isLoading
                        ? SizedBox(
                            width: width / 2.5,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Image.asset(
                            "assets/images/primaryAvatar/proceed button.png",
                            width: width / 2.5,
                          ),
                  ),
                ],
              ),
            ),
          )
          // Padding(
          //   padding: const EdgeInsets.all(5.0),
          //   child: Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         const SizedBox(
          //           height: 20,
          //         ),
          //         Image.asset(
          //             width: 400,
          //             "assets/images/pokerPadArt/pick your secondary avatar title.png"),
          //         const SizedBox(
          //           height: 50,
          //         ),
          //         Stack(
          //           alignment: Alignment.center,
          //           children: [
          //             // Frame Image
          //             Image.asset(
          //               "assets/images/pokerPadArt/golden selection frame.png",
          //               height: 470,
          //               // width: 280,
          //             ),
          //             // Avatar Image
          //             ClipRRect(
          //               borderRadius: BorderRadius.circular(
          //                   9), // Ensure image fits within the frame's radius
          //               child: Image.network(
          //                 widget.selectedImageUrl,
          //                 height: 452,
          //                 width: 360,
          //                 fit: BoxFit.cover,
          //               ),
          //             ),
          //           ],
          //         ),
          //         const SizedBox(
          //           height: 50,
          //         ),
          //         GestureDetector(
          //           onTap: () {
          //             Navigator.push(
          //                 context,
          //                 PageTransition(
          //                     child: const PickSecondaryAvatar(),
          //                     type: PageTransitionType.leftToRightWithFade));
          //           },
          //           child: Image.asset(
          //               width: MediaQuery.of(context).size.width / 1.3,
          //               "assets/images/pokerPadArt/change avatar button.png"),
          //         ),
          //         isLoading
          //             ? const Center(
          //                 child: CircularProgressIndicator(),
          //               )
          //             : GestureDetector(
          //                 onTap: () {
          //                   chooseAvatar();
          //                   // Navigator.push(
          //                   //     context,
          //                   //     PageTransition(
          //                   //         child: LobbyPage(),
          //                   //         type: PageTransitionType.leftToRightWithFade));
          //                 },
          //                 child: Image.asset(
          //                     width: MediaQuery.of(context).size.width / 1.3,
          //                     "assets/images/pokerPadArt/enter the pokerpad button.png"),
          //               ),
          //         const SizedBox(
          //           height: 20,
          //         ),
          //         Image.asset(
          //           "assets/images/pokerPadArt/retake selfie.png",
          //           height: 15,
          //         )
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
