import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../widget/build_heading_widget.dart';
import '../../widget/build_text_widget.dart';
import '../front_camera_page.dart';

class AccessoriesPage extends StatefulWidget {
  final PageController controller;

  const AccessoriesPage({super.key, required this.controller});

  @override
  State<AccessoriesPage> createState() => _AccessoriesPageState();
}

class _AccessoriesPageState extends State<AccessoriesPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Stack(
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
              const SizedBox(
                height: 90,
              ),
              const BuildHeadingWidget(text: "Accessories"),
              const SizedBox(
                height: 60,
              ),
              Image.asset(
                  width: width / 5,
                  "assets/images/gender&avatar/accessories icon.png"),
              const SizedBox(
                height: 90,
              ),
              const BuildTextWidget(
                align: TextAlign.center,
                text:
                    'Remove accessories that\n cover your face, like hats, \n sunglasses, or scarves. ',
                fontSize: 20,
              ),
              const SizedBox(
                height: 130,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Image.asset(
                      height: height / 28,
                      "assets/images/gender&avatar/page indicator_full.png"),
                ],
              ),
              SizedBox(
                height: height / 3.5,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: const FrontCameraPage(),
                          type: PageTransitionType.rightToLeftWithFade));
                },
                child: Image.asset(
                  "assets/images/gender&avatar/proceed to camera.png",
                  height: 55,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
