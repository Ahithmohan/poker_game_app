// import 'package:flutter/material.dart';
// import 'package:pokerpad/controller/get_avatar_controller.dart';
// import 'package:pokerpad/model/get_avatar_response_model.dart';
//
// class GetAvatarNotifier extends ChangeNotifier {
//   final GetAvatarController _getAvatarController = GetAvatarController();
//
//   GetAvatarResponseModel? avatarData;
//   bool isLoading = true;
//   String errorMessage = '';
//
//   Future<void> fetchAvatarData() async {
//     isLoading = true;
//     notifyListeners();
//
//     try {
//       avatarData = await _getAvatarController.getAvatar();
//
//       if (avatarData != null && avatarData!.status == "OK") {
//         errorMessage = '';
//       } else {
//         errorMessage = "Failed to fetch avatar data";
//       }
//     } catch (e) {
//       errorMessage = "Error occurred: $e";
//     }
//
//     isLoading = false;
//     notifyListeners();
//   }
// }
