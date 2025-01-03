import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/view/game_view.dart';
import 'package:pokerpad/widget/build_button_image_widget.dart';
import 'package:pokerpad/widget/build_icon_image_widget.dart';
import 'package:pokerpad/widget/build_sub_heading_text.dart';

import '../constants/screen_size.dart';

class LobbyPage extends StatefulWidget {
  const LobbyPage({super.key});

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    const BuildIconImageWidget(
                        imgName: "assets/images/lobby/Lobby music ON.png"),
                    const BuildIconImageWidget(
                        imgName:
                            "assets/images/lobby/profile button passive.png"),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset("assets/images/lobby/balance holder.png"),
                        const Center(
                            child: BuildSubHeadingText(text: "\$13,678.00"))
                      ],
                    ),
                    const BuildIconImageWidget(
                        imgName: "assets/images/lobby/info button active.png"),
                    const BuildIconImageWidget(
                        imgName:
                            "assets/images/lobby/pp logo button passive.png"),
                  ],
                ),
                const Row(
                  children: [
                    BuildButtonImageWidget(
                        imgPath:
                            "assets/images/lobby/affiliate button passive.png"),
                    BuildButtonImageWidget(
                        imgPath:
                            "assets/images/lobby/cashier button passive.png"),
                    BuildButtonImageWidget(
                        imgPath:
                            "assets/images/lobby/transfer button passive.png"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 380,
                        height: 370,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xff3C3D37), width: 6),
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.grey),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.asset(
                            "assets/images/user_img.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 380,
                        height: 370,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xff3C3D37), width: 5),
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.grey),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Image.network(
                            "https://img.freepik.com/premium-vector/playing-cards-dice-casino-logo-vector-illustration_396616-133.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Image.asset("assets/images/lobby/table header.png"),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                child: const GameView(),
                                type: PageTransitionType.rightToLeftWithFade));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            fit: BoxFit.fill,
                            "assets/images/lobby/100 jeton.png",
                            width: 390,
                            height: 200,
                          ),
                          Image.asset(
                            "assets/images/lobby/200 jeton.png",
                            fit: BoxFit.fill,
                            width: 390,
                            height: 200,
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/lobby/500 jeton.png",
                          width: 390,
                          fit: BoxFit.fill,
                          height: 200,
                        ),
                        Image.asset(
                          "assets/images/lobby/1000 jeton.png",
                          width: 390,
                          fit: BoxFit.fill,
                          height: 200,
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
