import 'package:flutter/material.dart';
import 'package:pokerpad/widget/build_sub_heading_text.dart';
import 'package:pokerpad/widget/build_text_widget.dart';

class InfoButtonWidget extends StatefulWidget {
  const InfoButtonWidget({super.key});

  @override
  State<InfoButtonWidget> createState() => _InfoButtonWidgetState();
}

class _InfoButtonWidgetState extends State<InfoButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Dialog(
          alignment: Alignment.topCenter,
          backgroundColor: Colors.transparent,
          child: Container(
            width: width / 1,
            height: height / 2,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover, // fit: BoxFit.fill,
                    image: AssetImage(
                        "assets/images/info_chat/house_rules_text_field.png"))),
            child: const Padding(
              padding: EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  BuildSubHeadingText(
                    text: "House Rules",
                    fontSize: 28,
                    color: Colors.white,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  BuildSubHeadingText(
                    text: "Rake",
                    fontWeight: FontWeight.w300,
                    color: Colors.white70,
                  ),
                  BuildTextWidget(
                    align: TextAlign.center,
                    text: "Rake is capped at 2.5% for all games\n "
                        "1% service fee for all in equity cashouts.\n "
                        "no preflop rake or suprise fee of any sort.",
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w100,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  BuildSubHeadingText(
                    text: "Table",
                    fontWeight: FontWeight.w300,
                    color: Colors.white70,
                  ),
                  BuildTextWidget(
                    align: TextAlign.center,
                    text:
                        "A minimum of five players is required for the game to start.\n"
                        "Must Move Rule:Players with small stacks sit together,\n"
                        "and players with big stacks sit together.",
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w100,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  BuildSubHeadingText(
                    text: "Stakes",
                    fontWeight: FontWeight.w300,
                    color: Colors.white70,
                  ),
                  BuildTextWidget(
                    align: TextAlign.center,
                    text: "The stakes vary between\$2/\$3 and \$3/\$5.\n"
                        "All games have a big blind ante in the amount of five big blinds.\n"
                        "Private game stakes may differ.",
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w100,
                  ),
                ],
              ),
            ),
          )

          // Image.asset(
          //   width: width / 1,
          //   height: height / 2.1,
          //   "assets/images/info_chat/house_rules_popup.png",
          //   fit: BoxFit.cover,
          // )

          // Container(
          //   decoration: BoxDecoration(
          //       color: Colors.black,
          //       border: Border.all(color: Colors.grey),
          //       borderRadius: BorderRadius.circular(
          //         20,
          //       )),
          //   height: height / 2,
          //   // height: height / 2,
          //
          //   width: width,
          //   child: const Padding(
          //     padding: EdgeInsets.all(4.0),
          //     // child: Center(
          //     //     child: BuildSubHeadingText(
          //     //         color: Colors.white70,
          //     //         textAlign: TextAlign.center,
          //     //         text:
          //     //             "1% service fee for all in equity cash out instead of no service fee")),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         BuildSubHeadingText(
          //           text: "HOUSE RULES",
          //           fontSize: 30,
          //           color: Colors.white,
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         BuildSubHeadingText(
          //           text: "Rake",
          //           color: Colors.white,
          //           fontSize: 15,
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         BuildSubHeadingText(
          //           text: "   Rake is a capped at 2.5% for all games.\n"
          //               "  1% service fee for all in equity cashout.\n"
          //               "no preflop rake or suprice fee of any sort",
          //           color: Colors.white,
          //           fontWeight: FontWeight.w100,
          //           fontSize: 11,
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         BuildSubHeadingText(
          //           text: "Tables",
          //           color: Colors.white,
          //           fontSize: 15,
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         BuildSubHeadingText(
          //           text:
          //               "All tables are classic casino cash game format with eighty seats.\n"
          //               "    A mininum of five players is required for the game to start.\n",
          //           color: Colors.white,
          //           fontWeight: FontWeight.w100,
          //           fontSize: 11,
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         BuildSubHeadingText(
          //           text: "Selection",
          //           color: Colors.white,
          //           fontSize: 15,
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         BuildSubHeadingText(
          //           text:
          //               "An algorithm chooses players seats based on there stacksizes.\n",
          //           color: Colors.white,
          //           fontWeight: FontWeight.w100,
          //           fontSize: 11,
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         BuildSubHeadingText(
          //           text: "Stakes",
          //           color: Colors.white,
          //           fontSize: 15,
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         Align(
          //           alignment: Alignment.center,
          //           child: BuildSubHeadingText(
          //             text:
          //                 "An algorithm decides tabel-stackes based on players stacksizes.\n"
          //                 "                                           The stakes vary between:\n"
          //                 "                                             \$1\$1    \$1\$2      \$2\$4",
          //             color: Colors.white,
          //             fontWeight: FontWeight.w100,
          //             fontSize: 11,
          //           ),
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         BuildSubHeadingText(
          //           text: "Ante",
          //           color: Colors.white,
          //           fontSize: 15,
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //         Align(
          //           alignment: Alignment.center,
          //           child: BuildSubHeadingText(
          //             text:
          //                 "All game have a big blind ante in the amount of five big blinds.\n",
          //             color: Colors.white,
          //             fontWeight: FontWeight.w100,
          //             fontSize: 11,
          //           ),
          //         ),
          //         SizedBox(
          //           height: 10,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          ),
    );
  }
}
