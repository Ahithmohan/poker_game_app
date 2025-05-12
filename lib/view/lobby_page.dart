import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpad/controller/rat_hole_controller.dart';
import 'package:pokerpad/model/login_response_model.dart';
import 'package:pokerpad/model/rat_hole_request_model.dart';
import 'package:pokerpad/model/rat_hole_response_model.dart';
import 'package:pokerpad/view/game_section_widget.dart';
import 'package:pokerpad/view/profile_button_page.dart';
import 'package:pokerpad/widget/affiliated_button_widget.dart';
import 'package:pokerpad/widget/avatar_image_view_widget.dart';
import 'package:pokerpad/widget/build_button_image_widget.dart';
import 'package:pokerpad/widget/build_icon_image_widget.dart';
import 'package:pokerpad/widget/build_sub_heading_text.dart';
import 'package:pokerpad/widget/cashier_button_widget.dart';
import 'package:pokerpad/widget/transfer_button_widget.dart';
import 'package:provider/provider.dart';

import '../constants/screen_size.dart';
import '../provider/login_provider.dart';
import '../widget/chat_support_widget.dart';
import '../widget/info_button_widget.dart';
import '../widget/top_winners_view_widget.dart';

class LobbyPage extends StatefulWidget {
  final String? playerBalance;
  final String? avatar;
  final Map<String, String>? kycStatus;
  final Map<String, String>? avatarStatus;

  final LoginResponseModel? playerResponse;
  const LobbyPage(
      {super.key,
      this.playerBalance,
      this.avatar,
      this.playerResponse,
      this.kycStatus,
      this.avatarStatus});

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  // String balance = "0.00";
  int selected_button = 1;
  int select_info = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    super.dispose();
  }

  bool isLoading = false;
  final RatHoleController ratHoleController = RatHoleController();

  Future<bool> ratHole(String buyIn) async {
    setState(() {
      isLoading = true;
    });
    try {
      RatHoleRequestModel request = RatHoleRequestModel(
          roomId: '16',
          playerId: widget.playerResponse!.data?.id,
          buyIn: buyIn);
      RatHoleResponseModel? response =
          await ratHoleController.checkRatHole(request);
      if (response?.status == "OK") {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     backgroundColor: Colors.greenAccent,
        //     content: Text(response!.status ?? "okay")));

        print("rathole successfully");
        return true;
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child:
                  Image.asset("assets/images/rathole/no retholing popup.png"),
            );
          },
        );
        return false;
      }
    } catch (e) {
      print("error$e");
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final balance = loginProvider.playerBalance;
    final kyc = loginProvider.kycStatus;
    final avatarStatus = loginProvider.updateAvatar;
    final lobbyAvatarStatus = avatarStatus["avatar"];
    final idStatus = kyc["id"];
    final photoStatus = kyc["photo"];
    print("kyc Status : id=$idStatus photo=$photoStatus");
    print(widget.playerResponse!.data?.id);
    print("playerBalance:${widget.playerResponse!.data?.balance}");
    print("update lobby avatar:: lobby=$lobbyAvatarStatus");
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

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
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ChatSupportWidget(),
                  GestureDetector(
                    onTap: () {
                      // showDialog(
                      //   context: context,
                      //   // barrierColor: Colors.grey.withOpacity(0.5),
                      //   builder: (context) {
                      //     return
                      //       ProfileButtonWidget(
                      //       playerResponse: widget.playerResponse,
                      //       userData: widget.playerResponse?.data ??
                      //           Data(
                      //             nickname: '',
                      //             email: '',
                      //             phone: '',
                      //           ),
                      //     );
                      //   },
                      // );

                      showDialog(
                        context: context,
                        builder: (context) {
                          return ProfileButtonPage(
                            playerResponse: widget.playerResponse,
                          );
                        },
                      );
                    },
                    child: const BuildIconImageWidget(
                        imgName:
                            "assets/images/lobby/profile button passive.png"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "assets/images/new_lobby/Lobby_balance.png",
                        width: MediaQuery.sizeOf(context).width / 2,
                      ),
                      Center(
                          child: BuildSubHeadingText(
                              color: Colors.white,
                              text:
                                  "\$ ${loginProvider.playerBalance ?? widget.playerBalance} USDC"))
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      print("clicked info button");
                      setState(() {
                        select_info = 1;
                      });
                      showDialog(
                        context: context,
                        builder: (context) {
                          return const InfoButtonWidget();
                          // return KycPickAvatarPage();
                        },
                      );
                    },
                    child: BuildIconImageWidget(
                        imgName: select_info == 1
                            ? "assets/images/lobby/info button active.png"
                            : "assets/images/lobby/info button active.png"),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const BuildIconImageWidget(
                        imgName: "assets/images/lobby/Logo active (1).png"),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AffiliatedButtonWidget(
                    playerResponse: widget.playerResponse,
                  ),
                  CashierButtonWidget(
                    playerResponse: widget.playerResponse,
                  ),
                  TransferButtonWidget(
                    playerResponse: widget.playerResponse,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AvatarImageViewWidget(
                    playerResponse: widget.playerResponse,
                    avatar: widget.avatar,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TopWinnersViewWidget(id: widget.playerResponse!.data?.id)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selected_button = 1),
                      child: BuildButtonImageWidget(
                        imgPath: selected_button == 1
                            ? "assets/images/new_lobby/Holdem Active.png"
                            : "assets/images/new_lobby/Hodlem Passive.png",
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selected_button = 2),
                      child: BuildButtonImageWidget(
                        imgPath: selected_button == 2
                            ? "assets/images/omaha_private/Omaha Active (1).png"
                            : "assets/images/omaha_private/Omaha Passive (1).png",
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => selected_button = 3),
                      child: BuildButtonImageWidget(
                        imgPath: selected_button == 3
                            ? "assets/images/omaha_private/Private Active (1).png"
                            : "assets/images/omaha_private/Privte Passive (1).png",
                      ),
                    ),
                  ),
                ],
              ),
              // GameSectionWidget(
              //   playerResponse: widget.playerResponse,
              // ),
              Builder(
                builder: (context) {
                  if (selected_button == 1) {
                    return GameSectionWidget(
                      playerResponse: widget.playerResponse,
                    );
                  } else if (selected_button == 2) {
                    return SizedBox(
                      height: height / 2.5,
                      width: width,
                      child: Image.asset(
                        "assets/images/omaha_private/Omaha_announcement.png",
                        fit: BoxFit.fill,
                      ),
                    );
                  } else if (selected_button == 3) {
                    return SizedBox(
                      height: height / 2.5,
                      width: width,
                      child: Image.asset(
                        "assets/images/omaha_private/Private_room_announcement.png",
                        fit: BoxFit.fill,
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
