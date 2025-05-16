import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pokerpad/constants/screen_size.dart';
import 'package:pokerpad/view/register_page.dart';
import 'package:pokerpad/widget/build_bold_text_widget.dart';
import 'package:pokerpad/widget/build_sub_heading_text.dart';
import 'package:pokerpad/widget/build_text_field_widget.dart';
import 'package:pokerpad/widget/build_text_widget.dart';
import 'package:provider/provider.dart';

import '../provider/login_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = true;
  bool rememberButton = false;

  // TextEditingController emailController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  // LoginResponseModel? playerDetails;
  // bool isLoading = false;
  // late WebSocketChannel? _channel;
  // String _deviceId = "Fetching...";
  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // _getStoredDeviceId();
  //   Future.delayed(const Duration(seconds: 1), () {});
  // }
  //
  // Future<void> _getStoredDeviceId() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   String? storedDeviceId = pref.getString("device_id");
  //
  //   setState(() {
  //     _deviceId = storedDeviceId ?? "No Device ID Found";
  //   });
  //   print("Updated Device ID: $_deviceId");
  // }
  //
  // Future<void> login() async {
  //   if (!_formKey.currentState!.validate()) return;
  //
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   _channel = WebSocketChannel.connect(
  //       Uri.parse("ws://3.6.170.253:48001/game?playerId=1"));
  //   print("WebSocket connected...");
  //
  //   _channel?.sink.add(jsonEncode({
  //     "code": "LOGIN_REQUEST",
  //     "data": {
  //       "username": emailController.text,
  //       "password": passwordController.text,
  //       "deviceId": _deviceId
  //     }
  //   }));
  //
  //   _channel?.stream.listen(
  //     (message) async {
  //       print("Message received: $message");
  //       final response = jsonDecode(message);
  //
  //       switch (response["code"]) {
  //         case "LOGIN_REQUEST":
  //           switch (response["data"]["status"]) {
  //             case "OK":
  //               setState(() {
  //                 playerDetails = LoginResponseModel.fromJson(response["data"]);
  //                 isLoading = false;
  //               });
  //
  //               final appVersionStr = playerDetails?.data?.appVersion ?? "0";
  //               final appVersion = int.tryParse(appVersionStr) ?? 0;
  //               final appUrl = playerDetails?.data?.appUrl ?? "";
  //
  //               print("App Version: $appVersion");
  //               print("App URL: $appUrl");
  //
  //               if (appVersion > 2 && appUrl.isNotEmpty) {
  //                 print("A new update is available. Please update the app.");
  //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                   elevation: 10,
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(24)),
  //                   behavior: SnackBarBehavior.floating,
  //                   backgroundColor: Colors.orange,
  //                   content: const Text(
  //                       "A new update is available. Please update the app."),
  //                 ));
  //
  //                 await downloadAndInstallApk(appUrl);
  //                 return;
  //               }
  //
  //               if (playerDetails != null && playerDetails!.data != null) {
  //                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                   elevation: 10,
  //                   shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(24)),
  //                   behavior: SnackBarBehavior.floating,
  //                   backgroundColor: CupertinoColors.activeGreen,
  //                   content: const Text("Login Successful",
  //                       style: TextStyle(color: Colors.white)),
  //                 ));
  //                 Navigator.pushReplacement(
  //                   context,
  //                   PageTransition(
  //                     child: LobbyPage(
  //                       playerResponse: playerDetails,
  //                       playerBalance: playerDetails!.data!.balance ?? "",
  //                       avatar: playerDetails!.data!.lobbyAvatar ?? "",
  //                     ),
  //                     type: PageTransitionType.rightToLeftWithFade,
  //                   ),
  //                 );
  //               }
  //               break;
  //
  //             case "FAIL":
  //               setState(() {
  //                 isLoading = false;
  //               });
  //
  //               String errorMessage =
  //                   response["data"]["message"] ?? "Login failed,";
  //               print("Error Message: $errorMessage");
  //
  //               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                 backgroundColor: Colors.red,
  //                 elevation: 10,
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(24)),
  //                 behavior: SnackBarBehavior.floating,
  //                 content: Text(errorMessage),
  //               ));
  //
  //               if (_channel != null) {
  //                 print("web socket close");
  //                 _channel!.sink.close();
  //               }
  //               break;
  //           }
  //           break;
  //
  //         default:
  //           break;
  //       }
  //     },
  //     onError: (error) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(SnackBar(content: Text("Error: $error")));
  //       print(error);
  //     },
  //     onDone: () {
  //       setState(() {
  //         isLoading = false;
  //       });
  //
  //       print("WebSocket connection closed.");
  //     },
  //   );
  // }
  //
  // double downloadProgress = 0.0; // Track progress
  //
  // Future<void> downloadAndInstallApk(String appUrl) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   try {
  //     // Check and request permissions
  //     if (await Permission.storage.request().isDenied ||
  //         await Permission.manageExternalStorage.request().isDenied ||
  //         await Permission.requestInstallPackages.request().isDenied) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content:
  //                 Text("Storage permission is required to update the app")),
  //       );
  //       setState(() {
  //         isLoading = false;
  //       });
  //       return;
  //     }
  //
  //     // Save in app directory instead of external storage (avoids permission issues)
  //     final dir = await getApplicationDocumentsDirectory(); // Internal storage
  //     final apkPath = '${dir.path}/app-release.apk';
  //     final dio = Dio();
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("App Updating, please wait...")),
  //     );
  //
  //     await dio.download(
  //       appUrl,
  //       apkPath,
  //       onReceiveProgress: (received, total) {
  //         if (total != -1) {
  //           double progress = received / total;
  //           setState(() {
  //             downloadProgress = progress;
  //           });
  //           print("Progress: ${(progress * 100).toStringAsFixed(0)}%");
  //         }
  //       },
  //     );
  //
  //     // Install APK
  //     await OpenFilex.open(apkPath);
  //
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("App update complete!")),
  //     );
  //   } catch (e) {
  //     print("Error Downloading or Installing APK: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Failed to update the app")),
  //     );
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    print("Device id login:${loginProvider.deviceId}");
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              color: Colors.transparent,
              width: 646,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: height / 12,
                  ),
                  Image.asset(
                    "assets/images/welcome_to_pokerpad.png",
                  ),
                  const SizedBox(height: 12),
                  const BuildTextWidget(
                    text: "Login to your account",
                  ),
                  const SizedBox(height: 24),
                  // Login Fields
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        BuildTextFieldWidget(
                          controller: loginProvider.emailController,
                          hintText: "Email",
                          labelText: 'email',
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your email";
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        BuildTextFieldWidget(
                          labelText: "password",
                          hintText: "Password",
                          controller: loginProvider.passwordController,
                          obscureText: passwordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            }
                            return null;
                          },
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            child: passwordVisible
                                ? Image.asset(
                                    "assets/images/Artboard 28.png",
                                    width: 47,
                                  )
                                : Image.asset(
                                    "assets/images/Artboard 29.png",
                                    width: 47,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  rememberButton = !rememberButton;
                                });
                              },
                              child: rememberButton
                                  ? Image.asset(
                                      "assets/images/empty checkmark.png",
                                      width: 30,
                                    )
                                  : Image.asset(
                                      "assets/images/Artboard 41.png",
                                      width: 30,
                                    ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            const BuildTextWidget(
                              text: "Remember me",
                            )
                          ],
                        ),
                        loginProvider.isForgotLoading
                            ? const Padding(
                                padding: EdgeInsets.only(right: 50),
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator(
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  loginProvider.forgotPassword(context);
                                },
                                child: const BuildBoldTextWidget(
                                    text: "Forgot password"))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Consumer<LoginProvider>(
                    builder: (context, loginProvider, child) {
                      return SizedBox(
                        width: width / 1.4,
                        height: 50,
                        child: loginProvider.errorMessage != null
                            ? Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/verifyemail/alert frame.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    loginProvider.errorMessage!,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      );
                    },
                  ),

                  loginProvider.isLoading
                      ? Column(
                          children: [
                            const SizedBox(height: 20),
                            loginProvider.downloadProgress > 0
                                ? Column(
                                    children: [
                                      LinearProgressIndicator(
                                        value: loginProvider.downloadProgress,
                                        backgroundColor: Colors.grey[300],
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '${(loginProvider.downloadProgress * 100).toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : const CircularProgressIndicator(),
                          ],
                        )
                      : GestureDetector(
                          onTap: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              loginProvider
                                  .login(context); // Call the login function
                              // _connectWebSocket();
                            } else {
                              print("Form is not valid");
                            }
                          },
                          child: Image.asset(
                            "assets/images/login button.png",
                            height: 59,
                          ),
                        ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const BuildTextWidget(
                        text: "Don’t have an account? ",
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: const RegisterPage(),
                                    type: PageTransitionType
                                        .rightToLeftWithFade));
                          },
                          child: const BuildBoldTextWidget(text: " Sign up")),
                    ],
                  ),
                  const Spacer(),
                  const BuildSubHeadingText(
                    text: "Version:2.1.0",
                    fontSize: 10,
                    color: Colors.black26,
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
