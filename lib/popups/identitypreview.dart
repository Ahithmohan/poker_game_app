import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/popups/faceidentity_dark.dart';
import 'package:pokerpad/view/kyc_loading_avatar_page.dart';
import 'package:provider/provider.dart';

import '../model/login_response_model.dart';
import '../provider/login_provider.dart';

class ImagePreviewScreenDark extends StatefulWidget {
  final LoginResponseModel? playerResponse;

  final String imagePath;

  const ImagePreviewScreenDark(
      {super.key, required this.imagePath, this.playerResponse});

  @override
  State<ImagePreviewScreenDark> createState() => _ImagePreviewScreenDarkState();
}

class _ImagePreviewScreenDarkState extends State<ImagePreviewScreenDark> {
  late File _imageFile;
  bool _isUploading = false;
  String? _base64String;

  @override
  void initState() {
    super.initState();
    _imageFile = File(widget.imagePath);
    print("image path::$_imageFile");
    print("response:${widget.playerResponse?.data?.id}");
  }

  Future<void> uploadImage() async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final userId =
        (loginProvider.playerId ?? widget.playerResponse?.data?.id.toString());
    print(loginProvider.playerId);
    try {
      setState(() {
        _isUploading = true;
      });

      // Convert the image to Base64
      String base64String = base64Encode(_imageFile.readAsBytesSync());
      _base64String = base64String;
      log("Base64 String: $_base64String");
      // Get the userId from SignupController
      // String? userId = widget.playerResponse?.data?.id.toString();
      // widget.playerResponse?.data?.id.toString();
      // API URL
      String apiUrl =
          "http://3.6.170.253:1080/server.php/api/v1/players/$userId?XDEBUG_SESSION_START=netbeans-xdebug";
      print(apiUrl);
      Map<String, dynamic> requestBody = {
        "photo": base64String,
        "id": userId,
      };
      print("00000");
      print("Compare value: ${requestBody['compare']}");

      // log("Request Body (JSON): ${jsonEncode(requestBody)}");
      print(apiUrl);
      print(userId);
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      // log("Response: ${response.body}");
      print(response.body);
      // Check response
      if (response.statusCode == 200) {
        log("Image uploaded successfully: ${response.body}");
        Navigator.push(
            context,
            PageTransition(
                child: KycLoadingAvatarPage(
                  playerResponse: widget.playerResponse,
                ),
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
        log("Failed to upload image: ${response.statusCode}");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //     elevation: 10,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(24),
        //     ),
        //     behavior: SnackBarBehavior.floating,
        //     backgroundColor: CupertinoColors.destructiveRed,
        //     content: const Text(
        //       "Compare image failed.",
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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/lobby/lobby pattern.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              child: _imageFile.path.isNotEmpty
                  ? Column(
                      children: [
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: Image.file(
                            _imageFile,
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height / 1.2,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const FaceIdentityPage(),
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
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const KycPickAvatarPage()
                                //         // KycLoadingAvatarPage(),
                                //         ));
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
                  : const Text("No image captured."),
            ),
          ),
        ],
      ),
    );
  }
}
