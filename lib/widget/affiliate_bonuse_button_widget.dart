// import 'package:flutter/material.dart';
// import 'package:pokerpad/widget/affiliate_bonuses_listview.dart';
// import 'package:provider/provider.dart';

// import '../provider/affiliated_button_provider.dart';
// import 'build_sub_heading_text.dart';

// class AffiliateBonusButtonWidget extends StatefulWidget {
//   const AffiliateBonusButtonWidget({super.key});

//   @override
//   State<AffiliateBonusButtonWidget> createState() =>
//       _AffiliateBonusButtonWidgetState();
// }

// class _AffiliateBonusButtonWidgetState
//     extends State<AffiliateBonusButtonWidget> {
//   final TextEditingController _searchController = TextEditingController();
//   String searchQuery = "";
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.sizeOf(context).width;
//     final height = MediaQuery.sizeOf(context).height;
//     final provider = Provider.of<AffiliatedButtonProvider>(context);
//     return Padding(
//       padding: const EdgeInsets.only(top: 140),
//       child: Container(
//         width: width,
//         height: height,
//         decoration: const BoxDecoration(
//             image: DecorationImage(
//                 image: AssetImage("assets/images/affiliate screen/aff_bg.png"),
//                 fit: BoxFit.cover)),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   ClipRRect(
//                     child: Container(
//                         width: width / 2.1,
//                         height: 50,
//                         decoration: const BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage(
//                                 "assets/images/affiliate screen/aff_textfield1.png"),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             BuildSubHeadingText(
//                               text: "NO.OF REFRRALS",
//                               color: Colors.white,
//                               fontSize: 10,
//                             ),
//                             BuildSubHeadingText(
//                               text: "365",
//                               color: Colors.white,
//                               fontSize: 13,
//                             ),
//                           ],
//                         )),
//                   ),
//                   ClipRRect(
//                     child: Container(
//                         width: width / 2.1,
//                         height: 50,
//                         decoration: const BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage(
//                                 "assets/images/affiliate screen/aff_texfield2.png"),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             BuildSubHeadingText(
//                               text: "PENDING BONUSES",
//                               color: Colors.white,
//                               fontSize: 10,
//                             ),
//                             BuildSubHeadingText(
//                               text: "\$34,000",
//                               color: Colors.white,
//                               fontSize: 13,
//                             ),
//                           ],
//                         )),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   GestureDetector(
//                     onTap: () {
//                       provider.toggleBonusClicked(true);
//                       Navigator.pop(context);
//                       // Navigator.pop(context);
//                       //
//                       // setState(() {
//                       //   showDialog(
//                       //     barrierDismissible: false,
//                       //     context: context,
//                       //     builder: (context) {
//                       //       return AffiliatePlayersButtonWidget();
//                       //     },
//                       //   );
//                       // });
//                     },
//                     child: Image.asset(
//                         width: width / 4.2,
//                         "assets/images/affiliate screen/players passive.png"),
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       provider.setClicked(false);
//                       Navigator.pop(context);
//                       Navigator.pop(context);
//                       provider.toggleBonusClicked(true);
//                     },
//                     child: Image.asset(
//                         width: width / 4.2,
//                         "assets/images/affiliate screen/bonuses active.png"),
//                   ),
//                   ClipRRect(
//                     child: Container(
//                         width: width / 2.1,
//                         height: 50,
//                         decoration: const BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage(
//                                 "assets/images/affiliate screen/aff_texfield2.png"),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             BuildSubHeadingText(
//                               text: "BONUSES CLAIMED",
//                               color: Colors.white,
//                               fontSize: 10,
//                             ),
//                             BuildSubHeadingText(
//                               text: "\$16,000",
//                               color: Colors.white,
//                               fontSize: 13,
//                             ),
//                           ],
//                         )),
//                   ),
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(3.0),
//                 child: ClipRRect(
//                   child: Container(
//                     width: width,
//                     height: height / 16,
//                     decoration: const BoxDecoration(
//                         image: DecorationImage(
//                             image: AssetImage(
//                                 "assets/images/bonuses/referral_text field.png"))),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         BuildSubHeadingText(
//                           text:
//                               "REFER A FRIEND AND RECEIVE  A BONUS UP TO \$10,000",
//                           color: Colors.black87,
//                           fontSize: 15,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(3.0),
//                 child: ClipRRect(
//                   child: Container(
//                     width: width,
//                     height: height / 13,
//                     decoration: const BoxDecoration(
//                         image: DecorationImage(
//                             image: AssetImage(
//                                 "assets/images/affiliate screen/search frame.png"))),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         SizedBox(
//                           width: 80,
//                           height: 50,
//                           child: Material(
//                             color: Colors.transparent,
//                             child: TextField(
//                               controller: _searchController,
//                               decoration: const InputDecoration(
//                                 hintText: "   SEARCH",
//                                 hintStyle: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 11,
//                                 ),
//                                 contentPadding:
//                                     EdgeInsets.symmetric(horizontal: 10),
//                                 border: InputBorder.none,
//                               ),
//                               style: const TextStyle(color: Colors.white70),
//                               onChanged: (value) {
//                                 setState(() {
//                                   searchQuery = value;
//                                 });
//                               },
//                             ),
//                           ),
//                         ),
//                         const BuildSubHeadingText(
//                           text: "REFERRALS",
//                           color: Colors.white,
//                           fontSize: 10,
//                         ),
//                         const SizedBox(
//                           width: 40,
//                         ),
//                         const BuildSubHeadingText(
//                           text: "ROAD TO \$10,000",
//                           color: Colors.white,
//                           fontSize: 10,
//                         ),
//                         const SizedBox(
//                           width: 30,
//                         ),
//                         const BuildSubHeadingText(
//                           text: "BONUSES",
//                           color: Colors.white,
//                           fontSize: 10,
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               AffiliateBonusesListview(
//                 searchQuery: searchQuery,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokerpad/widget/affiliate_bonuses_listview.dart';
import 'package:provider/provider.dart';

import '../model/login_response_model.dart';
import '../provider/affiliated_button_provider.dart';
import 'build_sub_heading_text.dart';

class AffiliateBonusButtonWidget extends StatefulWidget {
  final LoginResponseModel? playerResponse;

  const AffiliateBonusButtonWidget({super.key, this.playerResponse});

  @override
  State<AffiliateBonusButtonWidget> createState() =>
      _AffiliateBonusButtonWidgetState();
}

class _AffiliateBonusButtonWidgetState
    extends State<AffiliateBonusButtonWidget> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  Map<String, dynamic>? bonusesData;
  bool isLoading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBonusesDetails();
  }

  void fetchBonusesDetails() async {
    final affiliated_id = widget.playerResponse?.data?.selfAffiliateId;
    final url =
        "http://3.6.170.253:1080/server.php/api/v1/affiliate-bonus-refresh/$affiliated_id";
    print("Bonuses url:$url");
    final response = await Dio().get(url);
    if (response.statusCode == 200) {
      setState(() {
        bonusesData = response.data;

        isLoading = false;
      });
      print("Bonuses response:${response.data}");
      print(bonusesData?["summary"]["no_of_referrals"]);
    } else {
      setState(() {
        isLoading = false;
      });
      print("Bonuses error:${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final provider = Provider.of<AffiliatedButtonProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(top: 140),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: width,
                    height: height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/images/affiliate screen/aff_bg.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                child: Container(
                                  width: width / 2.1,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/affiliate screen/aff_textfield1.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const BuildSubHeadingText(
                                        text: "NO.OF REFRRALS",
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      BuildSubHeadingText(
                                        text: bonusesData?["summary"]
                                                    ["no_of_referrals"]
                                                .toString() ??
                                            "null",
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ClipRRect(
                                child: Container(
                                  width: width / 2.1,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/affiliate screen/aff_texfield2.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      BuildSubHeadingText(
                                        text: "PENDING BONUSES",
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      BuildSubHeadingText(
                                        text:
                                            "\$${bonusesData?["summary"]["pending_bonus"].toString() ?? "null"}",
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  provider.toggleBonusClicked(true);
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  "assets/images/affiliate screen/players passive.png",
                                  width: width / 4.2,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  provider.setClicked(false);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  provider.toggleBonusClicked(true);
                                },
                                child: Image.asset(
                                  "assets/images/affiliate screen/bonuses active.png",
                                  width: width / 4.2,
                                ),
                              ),
                              ClipRRect(
                                child: Container(
                                  width: width / 2.1,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/affiliate screen/aff_texfield2.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      BuildSubHeadingText(
                                        text: "BONUSES CLAIMED",
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      BuildSubHeadingText(
                                        text:
                                            "\$${bonusesData?["summary"]["bonus_claimed"].toString() ?? "null"}",
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ClipRRect(
                              child: Container(
                                width: width,
                                height: height / 16,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/bonuses/referral_text field.png"),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BuildSubHeadingText(
                                      text:
                                          "REFER A FRIEND AND RECEIVE  A BONUS UP TO \$10,000",
                                      color: Colors.black87,
                                      fontSize: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ClipRRect(
                              child: Container(
                                width: width,
                                height: height / 13,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/affiliate screen/search frame.png"),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      height: 50,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: TextField(
                                          controller: _searchController,
                                          decoration: const InputDecoration(
                                            hintText: "   SEARCH",
                                            hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 10),
                                            border: InputBorder.none,
                                          ),
                                          style: const TextStyle(
                                              color: Colors.white70),
                                          onChanged: (value) {
                                            setState(() {
                                              searchQuery = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    const BuildSubHeadingText(
                                      text: "REFERRALS",
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    const SizedBox(width: 40),
                                    const BuildSubHeadingText(
                                      text: "ROAD TO \$10,000",
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    const SizedBox(width: 30),
                                    const BuildSubHeadingText(
                                      text: "BONUSES",
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AffiliateBonusesListview(
                            playerResponse: widget.playerResponse,
                            searchQuery: searchQuery,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
