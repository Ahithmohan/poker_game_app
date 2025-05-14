import 'package:flutter/material.dart';
import 'package:pokerpad/controller/forgot_password_controller.dart';
import 'package:pokerpad/controller/transfer_controller.dart';
import 'package:pokerpad/model/forgot_password_model.dart';
import 'package:pokerpad/provider/transfer_button_provider.dart';
import 'package:pokerpad/view/profile_button_page.dart';
import 'package:pokerpad/widget/build_sub_heading_text.dart';
import 'package:pokerpad/widget/transfer_forgot_password_widget.dart';
import 'package:pokerpad/widget/transfer_history_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login_response_model.dart';
import '../model/transfer_request_model.dart';
import '../provider/login_provider.dart';
import 'build_button_image_widget.dart';
import 'build_text_widget.dart';
import 'custom_transfer_text_field.dart';

class TransferButtonWidget extends StatefulWidget {
  final LoginResponseModel? playerResponse;

  const TransferButtonWidget({super.key, this.playerResponse});

  @override
  State<TransferButtonWidget> createState() => _TransferButtonWidgetState();
}

class _TransferButtonWidgetState extends State<TransferButtonWidget> {
  bool isMarked = false;
  bool isLoading = false;
  bool isTransferLoading = false;
  final ForgotPasswordController forgotPasswordController =
      ForgotPasswordController();
  TransferController transferController = TransferController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController playerIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSavedPassword();
  }

  Future<void> _loadSavedPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPassword = prefs.getString('remembered_password');
    if (savedPassword != null) {
      setState(() {
        passwordController.text = savedPassword;
        isMarked = true;
      });
    }
  }

  Future<void> _rememberPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (isMarked) {
      await prefs.setString('remembered_password', password);
    } else {
      await prefs.remove('remembered_password');
    }
  }

  // Future<void> forgotPassword() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   final request = ForgotPasswordRequestModel(
  //     email: widget.playerResponse?.data?.email ?? "",
  //   );
  //   print("forgot request email:${request.email}");
  //   try {
  //     final response = await ForgotPasswordController().forgotPassword(request);
  //
  //     setState(() {
  //       isLoading = false;
  //     });
  //
  //     if (response != null) {
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return TransferForgotPasswordWidget(
  //             playerResponse: widget.playerResponse,
  //           );
  //         },
  //       );
  //     }
  //   } catch (e, stackTrace) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     debugPrint('Forgot password error: $e');
  //     debugPrintStack(stackTrace: stackTrace);
  //   }
  // }
  bool localIsLoading = false;

  Future<void> forgotPassword(StateSetter setDialogState) async {
    setDialogState(() {
      localIsLoading = true;
    });

    final request = ForgotPasswordRequestModel(
      email: widget.playerResponse?.data?.email ?? "",
    );
    print("forgot request email:${request.email}");
    try {
      final response = await ForgotPasswordController().forgotPassword(request);

      setDialogState(() {
        localIsLoading = false;
      });

      if (response != null) {
        showDialog(
          context: context,
          builder: (context) {
            return TransferForgotPasswordWidget(
              playerResponse: widget.playerResponse,
            );
          },
        );
      }
    } catch (e, stackTrace) {
      setDialogState(() {
        localIsLoading = false;
      });
      debugPrint('Forgot password error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void toggleMarker() {
    setState(() {
      isMarked = !isMarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final provider = Provider.of<TransferButtonProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    return GestureDetector(
      onTap: () {
        // Clear input values before showing the dialog
        playerIdController.clear();
        amountController.clear();
        passwordController.clear();
        final provider =
            Provider.of<TransferButtonProvider>(context, listen: false);
        provider.setClick(true);

        showDialog(
          barrierDismissible: true,
          context: context,
          builder: (BuildContext context) {
            bool isLoading = false;
            String? errorMessage;

            Future<void> transferAmount(StateSetter setDialogState) async {
              setDialogState(() {
                isTransferLoading = true;
                errorMessage = null;
              });

              final request = TransferRequestModel(
                from: widget.playerResponse?.data?.id.toString(),
                to: playerIdController.text.trim(),
                chips: amountController.text.trim(),
                password: passwordController.text,
              );

              try {
                final response =
                    await transferController.amountTransfer(request);

                setDialogState(() {
                  isTransferLoading = false;
                });

                if (response?.status == "OK") {
                  await _rememberPassword(passwordController.text);

                  // Clear text fields after successful transfer
                  playerIdController.clear();
                  amountController.clear();
                  passwordController.clear();
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (_) => Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 150),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: width / 1.4,
                                height: height / 3,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/transfer (2)/successful popup.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 90),
                                    const BuildSubHeadingText(
                                      text: "TRANSFER SUCCESSFUL",
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                    const SizedBox(height: 20),
                                    BuildTextWidget(
                                      align: TextAlign.center,
                                      text:
                                          "You transfer the amount \n \$${amountController.text} to Player ID${playerIdController.text}",
                                      color: Colors.white,
                                      fontSize: 15,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (response?.status == "FAIL") {
                  setDialogState(() {
                    errorMessage = response?.messages?["to"] ??
                        response?.messages?["from"] ??
                        response?.messages?["error"] ??
                        "Transfer failed";
                  });
                }
              } catch (e) {
                setDialogState(() {
                  isTransferLoading = false;
                  errorMessage = "Unexpected error occurred.";
                });
              }
            }

            return StatefulBuilder(
              builder: (context, setDialogState) {
                final width = MediaQuery.sizeOf(context).width;
                final height = MediaQuery.sizeOf(context).height;
                // final kyc = widget.playerResponse?.data?.kyc;
                // final idRejected = kyc?.idStatus?.toLowerCase() == 'rejected';
                // final faceRejected =
                //     kyc?.faceStatus?.toLowerCase() == 'rejected';
                final kyc = loginProvider.kycStatus;
                final idStatus = kyc["id"]?.toLowerCase();
                final photoStatus = kyc["photo"]?.toLowerCase();

                final idRejected = idStatus == 'rejected';
                final faceRejected = photoStatus == 'rejected';

                if (idRejected || faceRejected) {
                  // return KycInfoPopup();
                  return ProfileButtonPage(
                      playerResponse: widget.playerResponse);
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Dialog(
                      alignment: Alignment.topCenter,
                      backgroundColor: Colors.transparent,
                      child: SizedBox(
                        width: width,
                        height: height / 2,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              width: width,
                              height: height,
                              'assets/images/transfer (2)/bank frame (3).png',
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 58, left: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          CustomTransferTextField(
                                              controller: playerIdController,
                                              hintText: "Transfer Player ID:"),
                                          CustomTransferTextField(
                                              controller: amountController,
                                              hintText:
                                                  "Transfer to Amount\$:"),
                                          CustomTransferTextField(
                                            controller: passwordController,
                                            hintText: "Password",
                                            keyboardType: TextInputType.text,
                                          ),
                                          // GestureDetector(
                                          //            onTap: () {
                                          //              print("clicked");
                                          //              forgotPassword();
                                          //            },
                                          //            child: const BuildTextWidget(
                                          //              text: "Forgot Password",
                                          //              color: Colors.white,
                                          //              fontSize: 13,
                                          //            ),
                                          //          ),

                                          localIsLoading
                                              ? SizedBox(
                                                  width: 15,
                                                  height: 15,
                                                  child:
                                                      CircularProgressIndicator())
                                              : GestureDetector(
                                                  onTap: () {
                                                    // forgotPassword(
                                                    //     setDialogState);

                                                    showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return TransferForgotPasswordWidget(
                                                          playerResponse: widget
                                                              .playerResponse,
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: const BuildTextWidget(
                                                    text: "Forgot Password",
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                  ),
                                                ),

                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  setDialogState(() {
                                                    isMarked = !isMarked;
                                                  });
                                                  final prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  if (!isMarked) {
                                                    await prefs.remove(
                                                        'remembered_password');
                                                  }
                                                },
                                                child: Image.asset(
                                                  width: width / 24,
                                                  isMarked
                                                      ? "assets/images/CASHIER Button/TRANSFER/black check.png"
                                                      : "assets/images/CASHIER Button/TRANSFER/black check emty.png",
                                                ),
                                              ),
                                              const BuildTextWidget(
                                                text: "Remember Password",
                                                color: Colors.white,
                                                fontSize: 13,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            width: width / 2.4,
                                            height: height / 12,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/CASHIER Button/TRANSFER/transfer alert holder.png"),
                                              ),
                                            ),
                                            child: isTransferLoading
                                                ? const Center(
                                                    child: SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child:
                                                            CircularProgressIndicator()))
                                                : (errorMessage != null &&
                                                        errorMessage!
                                                            .isNotEmpty)
                                                    ? Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child:
                                                              BuildTextWidget(
                                                            text: errorMessage!,
                                                            align: TextAlign
                                                                .center,
                                                            fontSize: 15,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      )
                                                    : null,
                                          ),
                                        ],
                                      ),
                                      Image.asset(
                                        width: width / 2.4,
                                        "assets/images/transfer (2)/avatar frame (4).png",
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                TransferHistoryWidget(
                                                    playerResponse:
                                                        widget.playerResponse),
                                          );
                                        },
                                        child: Image.asset(
                                          "assets/images/CASHIER Button/TRANSFER/history button.png",
                                          width: width / 2.4,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            transferAmount(setDialogState),
                                        child: Image.asset(
                                          "assets/images/CASHIER Button/TRANSFER/transfer button.png",
                                          width: width / 2.4,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          },
        ).then((_) {
          provider.setClick(false);
        });
      },
      child: BuildButtonImageWidget(
        imgPath: provider.isClicked
            ? "assets/images/lobby/Transfer Button active.png"
            : "assets/images/lobby/transfer button passive.png",
      ),
    );
  }
}
