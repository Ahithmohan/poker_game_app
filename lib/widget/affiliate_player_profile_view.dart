import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokerpad/model/get_affiliate_player_model.dart';
import 'package:pokerpad/widget/build_sub_heading_text.dart';
import 'package:pokerpad/widget/build_text_widget.dart';

import '../model/login_response_model.dart';

class AffiliatePlayerProfileView extends StatefulWidget {
  final LoginResponseModel? playerResponse;

  const AffiliatePlayerProfileView({super.key, this.playerResponse});

  @override
  State<AffiliatePlayerProfileView> createState() =>
      _AffiliatePlayerProfileViewState();
}

class _AffiliatePlayerProfileViewState
    extends State<AffiliatePlayerProfileView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAffiliatePlayer();
  }

  GetAffiliatePlayerModel? affiliatePlayerData;

  bool isLoading = true;

  Future<void> getAffiliatePlayer() async {
    final playerId = widget.playerResponse?.data?.id;

    if (playerId == null) {
      print("Player ID is null. Cannot fetch transfer history.");
      return;
    }

    final url =
        "http://3.6.170.253:1080/server.php/api/v1/player-affiliate/$playerId";
    try {
      final response = await Dio().get(url);
      print(url);
      if (response.statusCode == 200) {
        final affiliatePlayer = GetAffiliatePlayerModel.fromJson(response.data);
        if (affiliatePlayer.status == "OK") {
          setState(() {
            affiliatePlayerData = affiliatePlayer;
            isLoading = false;
          });
          // print(affiliatePlayer.data?.id);
          print(affiliatePlayer.data?.about ?? "noo");
          print("✅ Affiliate Player Loaded Successfully");
        } else {
          print("❌ API returned failure: ${affiliatePlayer.status}");

          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("❗ Exception occurred while fetching history: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = affiliatePlayerData?.data;
    print(player?.id);

    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.only(top: 120),
      child: Stack(
        children: [
          SizedBox(
            width: width / 1,
            height: height / 1.6,
            child: Image.asset(
              "assets/images/playerAffiliate/affiliate_profile_combined.png",
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            top: 83,
            left: 55,
            child: player == null
                ? const Padding(
                    padding: EdgeInsets.only(top: 150, left: 30),
                    child: Center(
                        child: BuildSubHeadingText(
                      text: "No affiliate data found.",
                      color: Colors.white70,
                      fontSize: 13,
                    )),
                  )
                : Container(
                    height: height / 3.2,
                    width: width / 2.5,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(player.avatar.toString())),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BuildSubHeadingText(
                            text: player.name.toString(),
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w100,
                          ),
                          BuildSubHeadingText(
                            text: "ID:${player.id.toString()}",
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w100,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
          Positioned(
            top: 83,
            left: 329,
            child: Container(
              height: height / 3.2,
              width: width / 2.8,
              // height: 298,
              // width: 240,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black12),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: width / 2.9,
                      height: height / 4.4,
                      child: BuildTextWidget(
                        align: TextAlign.start,
                        maxLines: 11,
                        text: player?.about ?? "Not Found",
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                            width: 15,
                            height: 20,
                            "assets/images/playerAffiliate/phone icon (1).png"),
                        const SizedBox(
                          width: 10,
                        ),
                        BuildTextWidget(
                          fontSize: 12,
                          text: player?.phone ?? "Not Found",
                          color: Colors.white,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                            width: 15,
                            height: 20,
                            "assets/images/playerAffiliate/mail icon (1).png"),
                        const SizedBox(
                          width: 10,
                        ),
                        BuildTextWidget(
                          fontSize: 12,
                          text: player?.email ?? "Not Found",
                          color: Colors.white,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    // BuildTextWidget(
                    //   text:
                    //       "warning:Exercise caution and conduct due diligence when dealing with affiliate partners.",
                    //   fontSize: 13,
                    //   fontWeight: FontWeight.w400,
                    //   color: Colors.white,
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 414,
            left: 56,
            child: Container(
              height: height / 9.5,
              width: width / 1.23,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black12),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BuildSubHeadingText(
                    text: "DISCLAIMER",
                    fontSize: 12,
                    color: Colors.white,
                  ),
                  BuildTextWidget(
                    text:
                        "Affiliate partners are independent entities and do not act as employees or \nrepresentatives of PokerPad Ltd."
                        "Consequently, PokerPad Ltd. disclaims any \nliability for outcomers resulting from user interactions with affiliate partners, \nencompassing any ransactions and agreements.",
                    fontSize: 13,
                    fontWeight: FontWeight.w100,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
