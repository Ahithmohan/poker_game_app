import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/controller/get_avatar_controller.dart';
import 'package:pokerpad/view/view_primary_avatar.dart';
import 'package:pokerpad/widget/build_heading_widget.dart';

class PickAvatarPage extends StatefulWidget {
  const PickAvatarPage({
    super.key,
  });

  @override
  State<PickAvatarPage> createState() => _PickAvatarPageState();
}

class _PickAvatarPageState extends State<PickAvatarPage> {
  final List<String> avatarImageUrls = [];
  int _currentIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAvatarData();
  }

  Future<void> _fetchAvatarData() async {
    try {
      GetAvatarController getAvatarController = GetAvatarController();
      final response = await getAvatarController.getAvatar(context);
      if (response != null) {
        final primaryAvatars = response.data.primary;
        List<String> tempAvatars = [
          primaryAvatars.avatar0,
          primaryAvatars.avatar1,
          primaryAvatars.avatar2,
          primaryAvatars.avatar3,
          primaryAvatars.avatar4,
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
                const BuildHeadingWidget(text: "Pick primary Avatar"),
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
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
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
                        //   color: Colors.white,
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
                            child: ViewPrimaryAvatar(
                              selectedImageUrl: avatarImageUrls[_currentIndex],
                            ),
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

          // Padding(
          //   padding: const EdgeInsets.all(5.0),
          //   child: Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         const SizedBox(
          //           height: 30,
          //         ),
          //         Image.asset(
          //             width: 400,
          //             "assets/images/pokerPadArt/pick your primary avatar title.png"),
          //         const SizedBox(
          //           height: 60,
          //         ),
          //         Stack(
          //           alignment: Alignment.center,
          //           children: [
          //             // Frame Image
          //             Image.asset(
          //               "assets/images/pokerPadArt/frame for a avatar picture.png",
          //               height: 470,
          //             ),
          //             // Carousel Slider
          //             SizedBox(
          //               height: 450,
          //               width: 360,
          //               child: isLoading
          //                   ? const Center(
          //                       child: CircularProgressIndicator(),
          //                     )
          //                   : CarouselSlider(
          //                       options: CarouselOptions(
          //                         height: 450, // Adjust height to fit the frame
          //                         enlargeCenterPage: true,
          //                         autoPlay: false,
          //                         viewportFraction:
          //                             1.5, // Show one image at a time
          //                         onPageChanged: (index, reason) {
          //                           setState(() {
          //                             _currentIndex = index;
          //                           });
          //                         },
          //                       ),
          //                       items: avatarImageUrls.map((imageUrl) {
          //                         return Builder(
          //                           builder: (BuildContext context) {
          //                             return Container(
          //                               width: 360,
          //                               decoration: BoxDecoration(
          //                                 borderRadius:
          //                                     BorderRadius.circular(9),
          //                                 image: DecorationImage(
          //                                   image: NetworkImage(imageUrl),
          //                                   fit: BoxFit.cover,
          //                                 ),
          //                               ),
          //                             );
          //                           },
          //                         );
          //                       }).toList(),
          //                     ),
          //             ),
          //             // Stacked Dot Indicators
          //             Positioned(
          //               bottom: 10,
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children:
          //                     avatarImageUrls.asMap().entries.map((entry) {
          //                   return Container(
          //                     margin:
          //                         const EdgeInsets.symmetric(horizontal: 8.0),
          //                     width: _currentIndex == entry.key ? 12.0 : 12.0,
          //                     height: 18.0,
          //                     decoration: BoxDecoration(
          //                       color: _currentIndex == entry.key
          //                           ? Colors.white
          //                           : Colors.grey,
          //                       shape: BoxShape.circle,
          //                       border: Border.all(
          //                         color: Colors.white,
          //                         width: 1.0,
          //                       ),
          //                     ),
          //                   );
          //                 }).toList(),
          //               ),
          //             ),
          //           ],
          //         ),
          //         const SizedBox(
          //           height: 5,
          //         ),
          //         Text(
          //           "Swipe to see your Avatar",
          //           style: TextStyle(color: Colors.grey.shade600),
          //         ),
          //         const SizedBox(
          //           height: 50,
          //         ),
          //         GestureDetector(
          //           onTap: () {
          //             Navigator.push(
          //                 context,
          //                 PageTransition(
          //                     child: ViewPrimaryAvatar(
          //                       selectedImageUrl:
          //                           avatarImageUrls[_currentIndex],
          //                     ),
          //                     type: PageTransitionType.rightToLeftWithFade));
          //           },
          //           child: Image.asset(
          //               width: MediaQuery.of(context).size.width / 1.3,
          //               "assets/images/pokerPadArt/pick avatar button.png"),
          //         ),
          //         const SizedBox(
          //           height: 50,
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
