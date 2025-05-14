import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpad/view/profile_button_page.dart';
import 'package:provider/provider.dart';

import '../controller/rat_hole_controller.dart';
import '../model/login_response_model.dart';
import '../model/rat_hole_request_model.dart';
import '../model/rat_hole_response_model.dart';
import '../provider/login_provider.dart';
import 'game_view.dart';

class GameSectionWidget extends StatefulWidget {
  final LoginResponseModel? playerResponse;

  const GameSectionWidget({super.key, this.playerResponse});

  @override
  State<GameSectionWidget> createState() => _GameSectionWidgetState();
}

class _GameSectionWidgetState extends State<GameSectionWidget> {
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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: balance! >= 100
                  ? () async {
                      // final kyc = widget.playerResponse?.data?.kyc;
                      // final idRejected =
                      //     kyc?.idStatus?.toLowerCase() == 'rejected';
                      // final faceRejected =
                      //     kyc?.faceStatus?.toLowerCase() ==
                      //         'rejected';
                      final kyc = loginProvider.kycStatus;
                      final idStatus = kyc["id"]?.toLowerCase();
                      final photoStatus = kyc["photo"]?.toLowerCase();

                      final idRejected = idStatus == 'rejected';
                      final faceRejected = photoStatus == 'rejected';

                      if (idRejected || faceRejected) {
                        showDialog(
                            context: context,
                            builder: (context) => ProfileButtonPage(
                                playerResponse: widget.playerResponse)
                            // const KycInfoPopup(),
                            );
                        return;
                      }
                      bool success = await ratHole("100");
                      if (!mounted || !success) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameView(
                            playerResponse: widget.playerResponse,
                            buttonId: 100,
                          ),
                        ),
                      ).then((_) {
                        SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.immersiveSticky);
                      });
                    }
                  : null, // Disabled if balance < 100
              child: Image.asset(
                balance >= 100
                    ? "assets/images/lobby/100 jeton.png"
                    : "assets/images/new_lobby/100 Jeton bw.png",
                fit: BoxFit.fill,
                width: MediaQuery.sizeOf(context).width / 2,
                height: MediaQuery.sizeOf(context).height / 5,
              ),
            ),
            GestureDetector(
              onTap: balance >= 200
                  ? () async {
                      final kyc = loginProvider.kycStatus;
                      final idStatus = kyc["id"]?.toLowerCase();
                      final photoStatus = kyc["photo"]?.toLowerCase();

                      final idRejected = idStatus == 'rejected';
                      final faceRejected = photoStatus == 'rejected';

                      if (idRejected || faceRejected) {
                        showDialog(
                            context: context,
                            builder: (context) => ProfileButtonPage(
                                playerResponse: widget.playerResponse)

                            // const KycInfoPopup(),
                            );
                        return;
                      }
                      bool success = await ratHole("200");
                      if (!mounted || !success) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameView(
                            playerResponse: widget.playerResponse,
                            buttonId: 200,
                          ),
                        ),
                      ).then((_) {
                        SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.immersiveSticky);
                      });
                    }
                  : null,
              child: Image.asset(
                balance >= 200
                    ? "assets/images/lobby/200 jeton.png"
                    : "assets/images/new_lobby/200 Jeton bw.png",
                fit: BoxFit.fill,
                width: MediaQuery.sizeOf(context).width / 2,
                height: MediaQuery.sizeOf(context).height / 5,
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: balance >= 500
                  ? () async {
                      final kyc = loginProvider.kycStatus;
                      final idStatus = kyc["id"]?.toLowerCase();
                      final photoStatus = kyc["photo"]?.toLowerCase();

                      final idRejected = idStatus == 'rejected';
                      final faceRejected = photoStatus == 'rejected';

                      if (idRejected || faceRejected) {
                        showDialog(
                            context: context,
                            builder: (context) => ProfileButtonPage(
                                playerResponse: widget.playerResponse)

                            // const KycInfoPopup(),
                            );
                        return;
                      }
                      bool success = await ratHole("500");
                      if (!mounted || !success) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameView(
                            playerResponse: widget.playerResponse,
                            buttonId: 500,
                          ),
                        ),
                      ).then((_) {
                        SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.immersiveSticky);
                      });
                    }
                  : null,
              child: Image.asset(
                balance >= 500
                    ? "assets/images/new_lobby/500 Jeton (3).png"
                    : "assets/images/new_lobby/500 Jeton bw.png",
                fit: BoxFit.fill,
                width: MediaQuery.sizeOf(context).width / 2,
                height: MediaQuery.sizeOf(context).height / 5,
              ),
            ),
            GestureDetector(
              onTap: balance >= 1000
                  ? () async {
                      final kyc = loginProvider.kycStatus;
                      final idStatus = kyc["id"]?.toLowerCase();
                      final photoStatus = kyc["photo"]?.toLowerCase();

                      final idRejected = idStatus == 'rejected';
                      final faceRejected = photoStatus == 'rejected';

                      if (idRejected || faceRejected) {
                        showDialog(
                            context: context,
                            builder: (context) => ProfileButtonPage(
                                playerResponse: widget.playerResponse)

                            // const KycInfoPopup(),
                            );
                        return;
                      }
                      bool success = await ratHole("1000");
                      if (!mounted || !success) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GameView(
                            playerResponse: widget.playerResponse,
                            buttonId: 1000,
                          ),
                        ),
                      ).then((_) {
                        SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.immersiveSticky);
                      });
                    }
                  : null,
              child: Image.asset(
                balance >= 1000
                    ? "assets/images/new_lobby/1000 Jeton (3).png"
                    : "assets/images/new_lobby/1000 Jeton bw (1).png",
                fit: BoxFit.fill,
                width: MediaQuery.sizeOf(context).width / 2,
                height: MediaQuery.sizeOf(context).height / 5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
