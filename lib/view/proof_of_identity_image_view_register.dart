import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/view/p_y_i_camera_page.dart';
import 'package:pokerpad/view/terms_page.dart';
import 'package:provider/provider.dart';

import '../constants/screen_size.dart';
import '../controller/signup_controller.dart';
import '../provider/login_provider.dart';

class ProofOfIdentityImageViewRegister extends StatefulWidget {
  final String imagePath;

  const ProofOfIdentityImageViewRegister({super.key, required this.imagePath});

  @override
  State<ProofOfIdentityImageViewRegister> createState() =>
      _ProofOfIdentityImageViewRegisterState();
}

class _ProofOfIdentityImageViewRegisterState
    extends State<ProofOfIdentityImageViewRegister> {
  late File _imageFile;
  bool _isUploading = false;
  String? _base64String;

  @override
  void initState() {
    super.initState();
    _imageFile = File(widget.imagePath);
  }

  Future<void> uploadImage() async {
    try {
      setState(() {
        _isUploading = true;
      });

      // Convert the image to Base64
      String base64String = base64Encode(_imageFile.readAsBytesSync());
      _base64String = base64String;
      // log("Base64 String: $_base64String");
      // Get the userId from SignupController
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final loginId = loginProvider.playerId;
      String userId = (SignupController.userId ?? loginId).toString();

      // API URL
      String apiUrl =
          "http://3.6.170.253:1080/server.php/api/v1/player/save-id/$userId?XDEBUG_SESSION_START=netbeans-xdebug";
      print("upload url:$apiUrl");

      Map<String, dynamic> requestBody = {
        "photo": base64String,
        "id": userId,
        "deviceId": 1
      };
      // print("00000");
      // print(apiUrl);
      // print(userId);
      // print(requestBody["id"]);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      // log("Response: ${response.body}");
      // print(response.body);
      // Check response
      if (response.statusCode == 200) {
        // log("Image uploaded successfully: ${response.body}");
        Navigator.push(
            context,
            PageTransition(
                child: const TermsPage(),
                type: PageTransitionType.rightToLeftWithFade));
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     elevation: 10,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(24),
        //     ),
        //     behavior: SnackBarBehavior.floating,
        //     backgroundColor: CupertinoColors.activeGreen,
        //     content: const Text(
        //       "Image uploaded successfully!",
        //       style: TextStyle(color: Colors.white),
        //     )));
      } else {
        print("000000000000000000000");
        print(response.statusCode);
        print(response.body);
        // log("Failed to upload image: ${response.statusCode}");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     elevation: 10,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(24),
        //     ),
        //     behavior: SnackBarBehavior.floating,
        //     backgroundColor: CupertinoColors.destructiveRed,
        //     content: const Text(
        //       "Face not detected. Please ensure your face is clearly visible, well-lit, and positioned directly in front of the camera.",
        //       style: TextStyle(color: Colors.white),
        //     )));
      }
    } catch (e) {
      log("Error uploading image: $e");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Failed to upload image.")),
      // );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: ScreenSize.screenHeight,
            width: ScreenSize.screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Image.file(
                _imageFile,
                width: width,
                height: height / 1.2,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PYICameraPage(),
                          ));
                    },
                    child: Image.asset(
                      "assets/images/retake (6).png",
                      width: width / 2.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      uploadImage();
                    },
                    child: _isUploading
                        ? SizedBox(
                            width: width / 2.3,
                            child: const Center(
                                child: CircularProgressIndicator()))
                        : Image.asset(
                            "assets/images/confirm (6).png",
                            width: width / 2.3,
                          ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
