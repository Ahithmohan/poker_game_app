import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/view/view_secondary_avatar.dart';

import '../controller/get_avatar_controller.dart';
import '../widget/build_heading_widget.dart';

class PickSecondaryAvatar extends StatefulWidget {
  const PickSecondaryAvatar({super.key});

  @override
  State<PickSecondaryAvatar> createState() => _PickSecondaryAvatarState();
}

class _PickSecondaryAvatarState extends State<PickSecondaryAvatar> {
  final List<String> avatarImageUrls = [];
  int _currentIndex = 0;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchAvatarData();
  }

  Future<void> _fetchAvatarData() async {
    try {
      GetAvatarController getAvatarController = GetAvatarController();
      final response = await getAvatarController.getAvatar(context);
      if (response != null) {
        final secondaryAvatars = response.data.secondary;
        List<String> tempAvatars = [
          secondaryAvatars.avatar5,
          secondaryAvatars.avatar6,
          secondaryAvatars.avatar7,
          secondaryAvatars.avatar8,
          secondaryAvatars.avatar9,
        ];

        await Future.wait(tempAvatars.map((imageUrl) {
          final ImageProvider imageProvider = NetworkImage(imageUrl);
          return precacheImage(imageProvider, context);
        }));

        setState(() {
          avatarImageUrls.addAll(tempAvatars);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching avatar data: $e");
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  height: 4,
                ),
                const BuildHeadingWidget(text: "Pick secondary Avatar"),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Frame Image
                    Image.asset(
                      "assets/images/pokerPadArt/frame for a avatar picture.png",
                      height: 470,
                    ),
                    // Carousel Slider
                    SizedBox(
                      height: 450,
                      width: 360,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : CarouselSlider(
                              options: CarouselOptions(
                                height: 450, // Adjust height to fit the frame
                                enlargeCenterPage: true,
                                autoPlay: false,
                                viewportFraction:
                                    1.5, // Show one image at a time
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _currentIndex = index;
                                  });
                                },
                              ),
                              items: avatarImageUrls.map((imageUrl) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: 360,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(9),
                                        image: DecorationImage(
                                          image: NetworkImage(imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                    ),
                    // Stacked Dot Indicators
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: avatarImageUrls.asMap().entries.map((entry) {
                    return Container(
                      // margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      width: _currentIndex == entry.key ? 40.0 : 40.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(_currentIndex == entry.key
                                ? "assets/images/primaryAvatar/page indicator_full.png"
                                : "assets/images/primaryAvatar/page indicator_empty.png")),
                        // color: _currentIndex == entry.key
                        //     ? Colors.white
                        //     : Colors.grey,
                        // shape: BoxShape.circle,
                        // border: Border.all(
                        //   color:
                        //       Colors.white, // Outline for active/inactive dots
                        //   width: 1.0,
                        // ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: ViewSecondaryAvatar(
                                selectedImageUrl:
                                    avatarImageUrls[_currentIndex]),
                            type: PageTransitionType.rightToLeftWithFade));
                  },
                  child: Image.asset(
                      width: MediaQuery.of(context).size.width / 1.3,
                      "assets/images/pokerPadArt/pick avatar button.png"),
                ),
                const SizedBox(
                  height: 5,
                ),
                Image.asset(
                  "assets/images/pokerPadArt/retake selfie.png",
                  height: 15,
                ),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
