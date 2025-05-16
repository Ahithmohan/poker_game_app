import 'package:flutter/material.dart';

import '../../widget/build_heading_widget.dart';

class PosturePage extends StatefulWidget {
  final PageController controller;

  const PosturePage({super.key, required this.controller});

  @override
  State<PosturePage> createState() => _PosturePageState();
}

class _PosturePageState extends State<PosturePage> {
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
              const BuildHeadingWidget(text: "Posture"),
              const SizedBox(
                height: 40,
              ),
              Image.asset(
                  width: width / 5,
                  "assets/images/gender&avatar/posture icon.png"),
              const SizedBox(
                height: 90,
              ),
              const Text.rich(
                style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF5F6368),
                    fontWeight: FontWeight.w400),
                TextSpan(
                  text: 'Keep an ',
                  children: [
                    TextSpan(
                      text: 'upright Position\n',
                      style:
                          TextStyle(fontWeight: FontWeight.bold), // Make bold
                    ),
                    TextSpan(
                      text: ' and ensure nothing is \nbehind your head',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 80,
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
                      "assets/images/gender&avatar/page indicator_full.png"),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.controller.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Image.asset(
                      "assets/genderpage/back_btn.png",
                      width: width / 2.5,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      widget.controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Image.asset(
                      "assets/genderpage/next_btn.png",
                      width: width / 2.5,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
