import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/controller/kyc_avatar_controller.dart';
import 'package:pokerpad/view/kyc_pick_avatar_page.dart';

import '../constants/screen_size.dart';
import '../model/login_response_model.dart';
import '../widget/build_heading_widget.dart';

class KycLoadingAvatarPage extends StatefulWidget {
  final LoginResponseModel? playerResponse;
  const KycLoadingAvatarPage({super.key, this.playerResponse});

  @override
  State<KycLoadingAvatarPage> createState() => _KycLoadingAvatarPageState();
}

class _KycLoadingAvatarPageState extends State<KycLoadingAvatarPage> {
  late final KycAvatarController _kycAvatarController;
  bool isLoading = true;
  late Timer _timer; // Declare Timer for periodic refresh

  @override
  void initState() {
    super.initState();
    // _kycAvatarController =
    //     KycAvatarController(loginResponseModel: widget.playerResponse);
    // Start the periodic timer to refresh every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 20), (_) {
      fetchAvatarData();
    });

    // Initial fetch when the page loads
    fetchAvatarData();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  // Future<void> fetchAvatarData() async {
  //   setState(() {
  //     isLoading = true; // Trigger a rebuild and show loading state
  //   });
  //
  //   final avatarData = await _kycAvatarController.getAvatar();
  //   if (avatarData != null && avatarData.status == "OK") {
  //     print("Avatar fetched successfully: ${avatarData.status}");
  //     _timer.cancel();
  //     Navigator.push(
  //       context,
  //       PageTransition(
  //         child: KycPickAvatarPage(
  //           playerResponse: widget.playerResponse,
  //         ),
  //         type: PageTransitionType.rightToLeftWithFade,
  //       ),
  //     );
  //   } else {
  //     print("Avatar data fetch failed.");
  //     if (avatarData == null) {
  //       print("Avatar data is null.");
  //     } else {
  //       print("Avatar status: ${avatarData.status}");
  //     }
  //
  //     setState(() {
  //       isLoading = false; // Stop loading after trying to fetch the data
  //     });
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //           duration: Duration(seconds: 2),
  //           content: Text("Please wait... Your avatar is being generated")),
  //     );
  //   }
  // }
  Future<void> fetchAvatarData() async {
    print("===> fetchAvatarData called");

    setState(() {
      isLoading = true;
    });

    final userId = widget.playerResponse?.data?.id;
    print("===> userId: $userId");
    if (userId == null) {
      print("User ID is null");
      return;
    }

    final url =
        "http://3.6.170.253:1080/server.php/api/v1/avatar-list/$userId?XDEBUG_SESSION_START=netbeans-xdebug";

    print("===> Fetching avatar from URL: $url");

    try {
      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      print("===> Response status code: ${response.statusCode}");
      print("===> Response body: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        if (data["status"] == "OK") {
          print("===> Avatar status OK. Navigating...");
          _timer.cancel();
          Navigator.push(
            context,
            PageTransition(
              child: KycPickAvatarPage(playerResponse: widget.playerResponse),
              type: PageTransitionType.rightToLeftWithFade,
            ),
          );
          return;
        } else {
          print("===> Avatar status not OK: ${data["status"]}");
        }
      } else {
        print("===> HTTP error: ${response.statusCode}");
      }
    } catch (e) {
      print("===> Exception: $e");
    }

    print("===> Showing snackBar and stopping loading...");

    setState(() {
      isLoading = false;
    });

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     duration: Duration(seconds: 2),
    //     content: Text("Please wait... Your avatar is being generated"),
    //   ),
    // );
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
                image: AssetImage("assets/images/lobby/lobby pattern.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 50),
            child: Container(
              width: width / 1.2,
              height: height / 1.2,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                        "assets/images/avatar_new/avatar_content_field (1).png")),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const BuildHeadingWidget(
                    color: Colors.white70,
                    text: "Loading Avatars",
                  ),
                  // Show a loading indicator or the avatar data
                  isLoading
                      ? Image.asset(
                          height: 250,
                          width: 250,
                          "assets/Gifs/White PP Logo Animation.gif",
                          fit: BoxFit.fill,
                        )
                      : Image.asset(
                          height: 250,
                          width: 250,
                          "assets/Gifs/White PP Logo Animation.gif",
                          fit: BoxFit.fill,
                        ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
