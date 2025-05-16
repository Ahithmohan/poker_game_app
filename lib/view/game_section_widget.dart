// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:pokerpad/view/profile_button_page.dart';
// import 'package:provider/provider.dart';
//
// import '../controller/rat_hole_controller.dart';
// import '../model/login_response_model.dart';
// import '../model/rat_hole_request_model.dart';
// import '../model/rat_hole_response_model.dart';
// import '../provider/login_provider.dart';
// import 'game_view.dart';
//
// class GameSectionWidget extends StatefulWidget {
//   final LoginResponseModel? playerResponse;
//
//   const GameSectionWidget({super.key, this.playerResponse});
//
//   @override
//   State<GameSectionWidget> createState() => _GameSectionWidgetState();
// }
//
// class _GameSectionWidgetState extends State<GameSectionWidget> {
//   bool isLoading = false;
//   final RatHoleController ratHoleController = RatHoleController();
//
//   Future<bool> hasInternetConnection() async {
//     try {
//       final result = await InternetAddress.lookup('example.com');
//       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } on SocketException catch (_) {
//       return false;
//     }
//   }
//
//   Future<bool> ratHole(String buyIn) async {
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       // ✅ Check if internet is truly reachable
//       bool internetAvailable = await hasInternetConnection();
//       if (!internetAvailable) {
//         print("🚫 No real internet connection");
//         return false; // Do NOT show popup
//       }
//
//       // ✅ Proceed with request if internet is there
//       RatHoleRequestModel request = RatHoleRequestModel(
//         roomId: '16',
//         playerId: widget.playerResponse!.data?.id,
//         buyIn: buyIn,
//       );
//
//       RatHoleResponseModel? response =
//           await ratHoleController.checkRatHole(request);
//
//       if (response?.status == "OK") {
//         print("✅ RatHole OK");
//         return true;
//       } else {
//         print("❌ RatHole API failed — showing popup");
//         showDialog(
//           context: context,
//           builder: (context) {
//             return Dialog(
//               backgroundColor: Colors.transparent,
//               child:
//                   Image.asset("assets/images/rathole/no retholing popup.png"),
//             );
//           },
//         );
//         return false;
//       }
//     } on SocketException catch (e) {
//       print("🚫 SocketException (caught): $e");
//       return false;
//     } catch (e) {
//       print("❗ Unexpected error: $e");
//       return false;
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final loginProvider = Provider.of<LoginProvider>(context);
//     final balance = loginProvider.playerBalance;
//
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: balance! >= 100
//                   ? () async {
//                       // final kyc = widget.playerResponse?.data?.kyc;
//                       // final idRejected =
//                       //     kyc?.idStatus?.toLowerCase() == 'rejected';
//                       // final faceRejected =
//                       //     kyc?.faceStatus?.toLowerCase() ==
//                       //         'rejected';
//                       final kyc = loginProvider.kycStatus;
//                       final idStatus = kyc["id"]?.toLowerCase();
//                       final photoStatus = kyc["photo"]?.toLowerCase();
//
//                       final idRejected = idStatus == 'rejected';
//                       final faceRejected = photoStatus == 'rejected';
//
//                       if (idRejected || faceRejected) {
//                         showDialog(
//                             context: context,
//                             builder: (context) => ProfileButtonPage(
//                                 playerResponse: widget.playerResponse)
//                             // const KycInfoPopup(),
//                             );
//                         return;
//                       }
//                       bool success = await ratHole("100");
//                       if (!mounted || !success) return;
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => GameView(
//                             playerResponse: widget.playerResponse,
//                             buttonId: 100,
//                           ),
//                         ),
//                       ).then((_) {
//                         SystemChrome.setEnabledSystemUIMode(
//                             SystemUiMode.immersiveSticky);
//                       });
//                     }
//                   : null, // Disabled if balance < 100
//               child: Image.asset(
//                 balance >= 100
//                     ? "assets/images/lobby/100 jeton.png"
//                     : "assets/images/new_lobby/100 Jeton bw.png",
//                 fit: BoxFit.fill,
//                 width: MediaQuery.sizeOf(context).width / 2,
//                 height: MediaQuery.sizeOf(context).height / 5,
//               ),
//             ),
//             GestureDetector(
//               onTap: balance >= 200
//                   ? () async {
//                       final kyc = loginProvider.kycStatus;
//                       final idStatus = kyc["id"]?.toLowerCase();
//                       final photoStatus = kyc["photo"]?.toLowerCase();
//
//                       final idRejected = idStatus == 'rejected';
//                       final faceRejected = photoStatus == 'rejected';
//
//                       if (idRejected || faceRejected) {
//                         showDialog(
//                             context: context,
//                             builder: (context) => ProfileButtonPage(
//                                 playerResponse: widget.playerResponse)
//
//                             // const KycInfoPopup(),
//                             );
//                         return;
//                       }
//                       bool success = await ratHole("200");
//                       if (!mounted || !success) return;
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => GameView(
//                             playerResponse: widget.playerResponse,
//                             buttonId: 200,
//                           ),
//                         ),
//                       ).then((_) {
//                         SystemChrome.setEnabledSystemUIMode(
//                             SystemUiMode.immersiveSticky);
//                       });
//                     }
//                   : null,
//               child: Image.asset(
//                 balance >= 200
//                     ? "assets/images/lobby/200 jeton.png"
//                     : "assets/images/new_lobby/200 Jeton bw.png",
//                 fit: BoxFit.fill,
//                 width: MediaQuery.sizeOf(context).width / 2,
//                 height: MediaQuery.sizeOf(context).height / 5,
//               ),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             GestureDetector(
//               onTap: balance >= 500
//                   ? () async {
//                       final kyc = loginProvider.kycStatus;
//                       final idStatus = kyc["id"]?.toLowerCase();
//                       final photoStatus = kyc["photo"]?.toLowerCase();
//
//                       final idRejected = idStatus == 'rejected';
//                       final faceRejected = photoStatus == 'rejected';
//
//                       if (idRejected || faceRejected) {
//                         showDialog(
//                             context: context,
//                             builder: (context) => ProfileButtonPage(
//                                 playerResponse: widget.playerResponse)
//
//                             // const KycInfoPopup(),
//                             );
//                         return;
//                       }
//                       bool success = await ratHole("500");
//                       if (!mounted || !success) return;
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => GameView(
//                             playerResponse: widget.playerResponse,
//                             buttonId: 500,
//                           ),
//                         ),
//                       ).then((_) {
//                         SystemChrome.setEnabledSystemUIMode(
//                             SystemUiMode.immersiveSticky);
//                       });
//                     }
//                   : null,
//               child: Image.asset(
//                 balance >= 500
//                     ? "assets/images/new_lobby/500 Jeton (3).png"
//                     : "assets/images/new_lobby/500 Jeton bw.png",
//                 fit: BoxFit.fill,
//                 width: MediaQuery.sizeOf(context).width / 2,
//                 height: MediaQuery.sizeOf(context).height / 5,
//               ),
//             ),
//             GestureDetector(
//               onTap: balance >= 1000
//                   ? () async {
//                       final kyc = loginProvider.kycStatus;
//                       final idStatus = kyc["id"]?.toLowerCase();
//                       final photoStatus = kyc["photo"]?.toLowerCase();
//
//                       final idRejected = idStatus == 'rejected';
//                       final faceRejected = photoStatus == 'rejected';
//
//                       if (idRejected || faceRejected) {
//                         showDialog(
//                             context: context,
//                             builder: (context) => ProfileButtonPage(
//                                 playerResponse: widget.playerResponse)
//
//                             // const KycInfoPopup(),
//                             );
//                         return;
//                       }
//                       bool success = await ratHole("1000");
//                       if (!mounted || !success) return;
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => GameView(
//                             playerResponse: widget.playerResponse,
//                             buttonId: 1000,
//                           ),
//                         ),
//                       ).then((_) {
//                         SystemChrome.setEnabledSystemUIMode(
//                             SystemUiMode.immersiveSticky);
//                       });
//                     }
//                   : null,
//               child: Image.asset(
//                 balance >= 1000
//                     ? "assets/images/new_lobby/1000 Jeton (3).png"
//                     : "assets/images/new_lobby/1000 Jeton bw (1).png",
//                 fit: BoxFit.fill,
//                 width: MediaQuery.sizeOf(context).width / 2,
//                 height: MediaQuery.sizeOf(context).height / 5,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokerpad/view/profile_button_page.dart';
import 'package:provider/provider.dart';

import '../controller/rat_hole_controller.dart';
import '../model/login_response_model.dart';
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

  Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  // Future<bool> ratHole(String buyIn) async {
  //   try {
  //     bool internetAvailable = await hasInternetConnection();
  //     if (!internetAvailable) {
  //       print("🚫 No real internet connection");
  //       return false;
  //     }
  //
  //     RatHoleRequestModel request = RatHoleRequestModel(
  //       roomId: '16',
  //       playerId: widget.playerResponse!.data?.id,
  //       buyIn: buyIn,
  //     );
  //
  //     RatHoleResponseModel? response =
  //         await ratHoleController.checkRatHole(request);
  //
  //     if (response?.status == "OK") {
  //       print("✅ RatHole OK");
  //       return true;
  //     } else {
  //       print("❌ RatHole API failed — showing popup");
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return Dialog(
  //             backgroundColor: Colors.transparent,
  //             child:
  //                 Image.asset("assets/images/rathole/no retholing popup.png"),
  //           );
  //         },
  //       );
  //       return false;
  //     }
  //   } catch (e) {
  //     print("❗ Error in ratHole: $e");
  //     return false;
  //   }
  // }

  Future<void> handleGameTap(int buyIn) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      bool internetAvailable = await hasInternetConnection();
      if (!internetAvailable) {
        print("🚫 No real internet connection");
        return;
      }
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final kyc = loginProvider.kycStatus;

      final idRejected = kyc["id"]?.toLowerCase() == 'rejected';
      final faceRejected = kyc["photo"]?.toLowerCase() == 'rejected';

      if (idRejected || faceRejected) {
        showDialog(
          context: context,
          builder: (context) => ProfileButtonPage(
            playerResponse: widget.playerResponse,
          ),
        );
        return;
      }

      // bool success = await ratHole(buyIn.toString());
      // if (!mounted || !success) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameView(
            playerResponse: widget.playerResponse,
            buttonId: buyIn,
          ),
        ),
      ).then((_) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final loginProvider = Provider.of<LoginProvider>(context);
    final balance = loginProvider.playerBalance ?? 0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: (balance >= 100 && !isLoading)
                  ? () => handleGameTap(100)
                  : null,
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
              onTap: (balance >= 200 && !isLoading)
                  ? () => handleGameTap(200)
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
              onTap: (balance >= 500 && !isLoading)
                  ? () => handleGameTap(500)
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
              onTap: (balance >= 1000 && !isLoading)
                  ? () => handleGameTap(1000)
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
