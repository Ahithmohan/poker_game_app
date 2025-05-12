import 'dart:async'; // Import for Timer

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/controller/get_avatar_controller.dart';
import 'package:pokerpad/view/pick_avatar_page.dart';
import 'package:pokerpad/widget/build_heading_widget.dart';

import '../constants/screen_size.dart';

class LoadingAvatarPage extends StatefulWidget {
  const LoadingAvatarPage({super.key});

  @override
  State<LoadingAvatarPage> createState() => _LoadingAvatarPageState();
}

class _LoadingAvatarPageState extends State<LoadingAvatarPage> {
  final GetAvatarController _getAvatarController = GetAvatarController();
  bool isLoading = true;
  late Timer _timer; // Declare Timer for periodic refresh

  @override
  void initState() {
    super.initState();

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

  Future<void> fetchAvatarData() async {
    setState(() {
      isLoading = true; // Trigger a rebuild and show loading state
    });

    final avatarData = await _getAvatarController.getAvatar(context);
    if (avatarData != null && avatarData.status == "OK") {
      print("Avatar fetched successfully: ${avatarData.status}");
      _timer.cancel();
      Navigator.push(
        context,
        PageTransition(
          child: const PickAvatarPage(),
          type: PageTransitionType.rightToLeftWithFade,
        ),
      );
    } else {
      print("Avatar data fetch failed.");
      if (avatarData == null) {
        print("Avatar data is null.");
      } else {
        print("Avatar status: ${avatarData.status}");
      }

      setState(() {
        isLoading = false; // Stop loading after trying to fetch the data
      });
      //
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //       duration: Duration(seconds: 2),
      //       content: Text("Please wait... Your avatar is being generated")),
      // );
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const BuildHeadingWidget(text: "Loading Avatars"),
                // Show a loading indicator or the avatar data
                isLoading
                    ? Center(
                        child: SizedBox(
                          width: width / 2,
                          child: Image.asset(
                              "assets/Gifs/White PP Logo Animation.gif"),
                        ),
                      )
                    : Center(
                        child: SizedBox(
                          width: width / 2,
                          child: Image.asset(
                              "assets/Gifs/White PP Logo Animation.gif"),
                        ),
                      ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          )
          // Padding(
          //   padding: const EdgeInsets.all(35.0),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: [
          //       Image.asset(
          //           "assets/images/pokerPadArt/avtaar generation title.png"),
          //       const SizedBox(
          //         height: 100,
          //       ),
          //       // Show a loading indicator or the avatar data
          //       isLoading
          //           ? Image.asset(
          //               height: 250,
          //               width: 250,
          //               "assets/images/3d/ezgif.com-gif-maker (1).gif",
          //               fit: BoxFit.fill,
          //             )
          //           : Image.asset(
          //               height: 250,
          //               width: 250,
          //               "assets/images/3d/ezgif.com-gif-maker (1).gif",
          //               fit: BoxFit.fill,
          //             ),
          //
          //       const SizedBox(
          //         height: 150,
          //       ),
          //       Image.asset(
          //           "assets/images/pokerPadArt/avatar generation explanation.png"),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
