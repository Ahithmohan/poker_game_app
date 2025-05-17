import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pokerpad/view/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../controller/forgot_password_controller.dart';
import '../model/forgot_password_model.dart';
import '../model/login_response_model.dart';
import '../view/lobby_page.dart';
import '../view/verify_forgot_password.dart';

class LoginProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  int? _playerId;
  int? get playerId => _playerId;

  WebSocketChannel? _channel;
  bool isLoading = false;
  bool isForgotLoading = false;
  LoginResponseModel? playerDetails;
  String _deviceId = "Fetching..";
  double downloadProgress = 0.0;
  int? playerBalance;
  Map<String, dynamic> kycStatus = {};
  Map<String, dynamic> updateAvatar = {};
  String? errorMessage;
  LoginProvider() {
    _getStoredDeviceId();
  }
  String get deviceId => _deviceId;

  late int _avatarVersion = 0;
  int get avatarVersion => _avatarVersion;

  void setPlayerId(int? id) {
    _playerId = id;
    notifyListeners();
  }

  Future<void> _getStoredDeviceId() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? storedDeviceId = pref.getString("device_id");

    _deviceId = storedDeviceId ?? "No Device ID Found";
    notifyListeners(); // Update UI
    print("Updated Device ID: $_deviceId");
  }

  Future<void> saveLoginInfo(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_email', email);
    await prefs.setString('saved_password', password);
    await prefs.setBool('remember_me', true); // <- Save checkbox state
  }

  Future<void> clearLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('saved_email');
    await prefs.remove('saved_password');
    await prefs.setBool('remember_me', false); // <- Clear checkbox state
  }

  Future<void> loadRememberedLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('saved_email');
    String? password = prefs.getString('saved_password');
    bool remember = prefs.getBool('remember_me') ?? false;

    emailController.text = email ?? '';
    passwordController.text = password ?? '';
  }

  Future<void> login(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    _channel = WebSocketChannel.connect(
      Uri.parse("ws://3.6.170.253:48001/game?playerId=1"),
    );
    print("WebSocket connected...");

    _channel?.sink.add(jsonEncode({
      "code": "LOGIN_REQUEST",
      "data": {
        "username": emailController.text,
        "password": passwordController.text,
        "deviceId": _deviceId,
      }
    }));

    _channel?.stream.listen(
      (message) async {
        print("Message received: $message");
        final response = jsonDecode(message);

        switch (response["code"]) {
          case "LOGIN_REQUEST":
            _handleLoginResponse(response, context);
            break;

          case "NOTIFY_PLAYER_BALANCE":
            _updatePlayerBalance(response);
            break;

          case "KYC_STATUS":
            _updateKycStatus(response);
            break;

          case "PROFILE_AVATAR":
            _updatePlayerAvatar(response);
            break;
          default:
            print("Unhandled WebSocket message: $response");
            break;
        }
      },
      onError: (error) {
        isLoading = false;
        notifyListeners();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $error")),
        );
      },
      onDone: () {
        isLoading = false;
        notifyListeners();
        print("WebSocket connection closed.");
      },
    );
  }

  void _handleLoginResponse(
      Map<String, dynamic> response, BuildContext context) async {
    if (response["data"]["status"] == "OK") {
      playerDetails = LoginResponseModel.fromJson(response["data"]);
      // ✅ Set the player ID so it's available globally
      setPlayerId(playerDetails?.data?.id);
      playerBalance =
          double.tryParse(playerDetails?.data?.balance.toString() ?? '0')
                  ?.toInt() ??
              0;

      // Set initial KYC status from login response
      kycStatus = {
        "id": playerDetails?.data?.kyc?.idStatus ?? "Unknown",
        "photo": playerDetails?.data?.kyc?.faceStatus ?? "Unknown",
      };

      updateAvatar = {
        "lobby_avatar": playerDetails?.data?.lobbyAvatar ?? "Unknown",
        "avatar": playerDetails?.data?.avatar ?? "Unknown",
      };

      isLoading = false;
      errorMessage = null;
      notifyListeners();
      print("balance;$playerBalance");

      final appVersionStr = playerDetails?.data?.appVersion ?? "0";
      print("appverison:$appVersionStr");
      final appVersion = int.tryParse(appVersionStr) ?? 0;
      final appUrl = playerDetails?.data?.appUrl ?? "";

      if (appVersion > 2.1 && appUrl.isNotEmpty) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     elevation: 10,
        //     shape:
        //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        //     behavior: SnackBarBehavior.floating,
        //     backgroundColor: Colors.orange,
        //     content:
        //         const Text("A new update is available. Please update the app."),
        //   ),
        // );
        await downloadAndInstallApk(appUrl, context);
        return;
      }

      //   👇 NEW: Get the current registration step from the server
      int currentStep = playerDetails?.data?.step ?? 99;
      currentStep += 1; // Increment step by 1

      final int playerId = playerDetails?.data?.id ?? 0;
      print("Player ID: $playerId");
      print("Current Step: $currentStep");

      //   Navigator.pushReplacement(
      //     context,
      //     PageTransition(
      //       child: LobbyPage(
      //         kycStatus: Map<String, String>.from(kycStatus),
      //         avatarStatus: Map<String, String>.from(updateAvatar),
      //         playerResponse: playerDetails,
      //         playerBalance: playerDetails?.data?.balance.toString(),
      //         avatar: playerDetails!.data!.lobbyAvatar ?? "",
      //       ),
      //       type: PageTransitionType.rightToLeftWithFade,
      //     ),
      //   );
      // }
//    👇 NEW: Navigate based on the step
      switch (currentStep) {
        case 100:
          Navigator.pushReplacement(
            context,
            PageTransition(
              child: LobbyPage(
                kycStatus: Map<String, String>.from(kycStatus),
                avatarStatus: Map<String, String>.from(updateAvatar),
                playerResponse: playerDetails,
                playerBalance: playerDetails?.data?.balance.toString(),
                avatar: playerDetails!.data!.lobbyAvatar ?? "",
              ),
              type: PageTransitionType.rightToLeftWithFade,
            ),
          );
          break;

        case 1:
          Navigator.pushReplacementNamed(context, '/email');
          break;
        case 2:
          // Navigator.pushReplacementNamed(context, '/otp');
          Navigator.pushReplacementNamed(context, '/otp');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/gender');
          break;
        case 4:
          Navigator.pushReplacementNamed(context, '/photo');
        case 5:
          Navigator.pushReplacementNamed(context, '/name');
          break;
        case 6:
          Navigator.pushReplacementNamed(context, '/phone');
          break;
        case 7:
          Navigator.pushReplacementNamed(context, '/primaryAvatar');
          break;
        case 8:
          Navigator.pushReplacementNamed(context, '/secondaryAvatar');
          break;
        // case 9:
        //   Navigator.pushReplacementNamed(context, '/kycId');
        //   break;
        case 9:
          Navigator.pushReplacementNamed(context, '/terms');
          break;
        // case 99:
        //   Navigator.pushReplacementNamed(context, '/finish');
        //   break;

        default:
          print("Unhandled step: $currentStep");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Unknown registration step")),
          );
      }
    } else if (response["data"]["status"] == "FAIL") {
      // Login failed, update errorMessage
      this.errorMessage = response["data"]["message"] ?? "Login Failed";
      isLoading = false;
      notifyListeners();

      bool shouldRedirect = response["data"]["data"]["redirect"] ?? false;
      int? affiliateId = response["data"]["data"]["affiliate_id"];
      String errorMessage = response["data"]["message"] ?? "Login Failed";
      print(shouldRedirect);
      print(affiliateId);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(errorMessage),
      //     backgroundColor: Colors.yellow,
      //   ),
      // );

      print(errorMessage);

      if (shouldRedirect && affiliateId != null) {
        print("Redirecting to Register Page...");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RegisterPage(
                affiliateId: affiliateId,
              ),
            ));
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text("Redirecting to signup..."),
        //     backgroundColor: Colors.blue,
        //   ),
        // );
      }
    } else {
      isLoading = false;
      notifyListeners();
      String errorMessage = response["data"]["message"] ?? "Login failed.";
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: Colors.red,
      //     elevation: 10,
      //     shape:
      //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      //     behavior: SnackBarBehavior.floating,
      //     content: Text(errorMessage),
      //   ),
      // );

      _channel?.sink.close();
    }
  }

  void _updatePlayerBalance(Map<String, dynamic> response) {
    // playerBalance = response["balance"] ?? 0;
    playerBalance = response["balance"] is String
        ? int.tryParse(response["balance"]) ?? 0
        : (response["balance"] as num?)?.toInt() ?? 0;
    notifyListeners();
    print("Player Balance Updated: $playerBalance");
  }

  void _updateKycStatus(Map<String, dynamic> response) {
    final idStatus = response["id"] is String ? response["id"] : "Unknown";
    final photoStatus =
        response["photo"] is String ? response["photo"] : "Unknown";

    kycStatus = {
      "id": idStatus,
      "photo": photoStatus,
    };

    notifyListeners();
    print("KYC Status Updated: $kycStatus");
  }

  void _updatePlayerAvatar(Map<String, dynamic> response) {
    final lobbyAvatar = response["lobby_avatar"] is String
        ? response["lobby_avatar"]
        : "Unknown";
    final avatar =
        response["avatar"] is String ? response["avatar"] : "Unknown";

    updateAvatar = {
      "lobby_avatar": lobbyAvatar,
      "avatar": avatar,
    };
    _avatarVersion = DateTime.now().millisecondsSinceEpoch; // Version update

    notifyListeners();
    print("Updater Avatar:$updateAvatar");
  }

  Future<void> downloadAndInstallApk(
      String appUrl, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      // Request necessary permissions
      if (await Permission.storage.request().isDenied ||
          await Permission.manageExternalStorage.request().isDenied ||
          await Permission.requestInstallPackages.request().isDenied) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //       content:
        //           Text("Storage permission is required to update the app")),
        // );
        isLoading = false;
        notifyListeners();
        return;
      }

      // Get app directory path
      final dir = await getApplicationDocumentsDirectory();
      final apkPath = '${dir.path}/app-release.apk';
      final dio = Dio();

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("App Updating, please wait...")),
      // );

      // Download APK
      await dio.download(
        appUrl,
        apkPath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress = received / total;
            notifyListeners();
            print("Progress: ${(downloadProgress * 100).toStringAsFixed(0)}%");
          }
        },
      );

      // Install APK
      await OpenFilex.open(apkPath);

      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("App update complete!")),
      // );
    } catch (e) {
      print("Error Downloading or Installing APK: $e");
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Failed to update the app")),
      //   );
      // } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword(BuildContext context) async {
    if (emailController.text.isEmpty) {
      errorMessage = "Please enter your email";
      notifyListeners();
      return;
    }
    errorMessage = null;
    notifyListeners();

    // Perform forgot password API call or navigation logic here

    isForgotLoading = true;
    notifyListeners();
    final request = ForgotPasswordRequestModel(email: emailController.text);
    print(request.email);
    try {
      final response = await ForgotPasswordController().forgotPassword(request);
      isForgotLoading = false;
      notifyListeners();
      print(response);
      if (response != null) {
        Navigator.pushReplacement(
          context,
          PageTransition(
            child: VerifyForgotPassword(email: emailController.text),
            type: PageTransitionType.rightToLeftWithFade,
          ),
        );
      } else {
        errorMessage = "The selected email is invalid";
      }
    } catch (e) {
      isForgotLoading = false;
      notifyListeners();
      print('Error: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('An error occurred, please try again')),
      // );
    }
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Forgot password request sent")),
    // );
  }

// in profile proof of identity upload image
  Future<bool> uploadIdImage(File imageFile) async {
    try {
      if (playerId == null) throw Exception("User ID is null");

      final dio = Dio();

      final base64String = base64Encode(await imageFile.readAsBytes());

      final String apiUrl =
          "http://3.6.170.253:1080/server.php/api/v1/player/save-id/$playerId?XDEBUG_SESSION_START=netbeans-xdebug";

      final requestBody = {
        "photo": base64String,
        "id": playerId,
        "deviceId": 1, // Consider replacing with your actual deviceId
      };

      final response = await dio.post(
        apiUrl,
        data: jsonEncode(requestBody),
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        log("Upload successful: ${response.data}");
        return true;
      } else {
        log("Upload failed: ${response.statusCode} ${response.statusMessage}");
        return false;
      }
    } catch (e) {
      log("Upload error: $e");
      return false;
    }
  }

  void disposeResources() {
    emailController.dispose();
    passwordController.dispose();
    _channel?.sink.close();
  }
}
