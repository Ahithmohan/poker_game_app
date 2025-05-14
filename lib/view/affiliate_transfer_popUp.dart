import 'package:flutter/material.dart';
import 'package:pokerpad/view/affiliate_transfer_history_popUp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/transfer_controller.dart';
import '../model/login_response_model.dart';
import '../model/transfer_request_model.dart';
import '../widget/build_sub_heading_text.dart';
import '../widget/build_text_widget.dart';
import '../widget/custom_transfer_text_field.dart';

class AffiliateTransferPopup extends StatefulWidget {
  final LoginResponseModel? playerResponse;

  final int? playerId;
  const AffiliateTransferPopup({super.key, this.playerId, this.playerResponse});

  @override
  State<AffiliateTransferPopup> createState() => _AffiliateTransferPopupState();
}

class _AffiliateTransferPopupState extends State<AffiliateTransferPopup> {
  bool isMarked = false;
  bool isLoading = false;
  bool isTransferLoading = false;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController playerIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  TransferController transferController = TransferController();

  String? errorMessage;
  @override
  void initState() {
    super.initState();
    if (widget.playerId != null) {
      playerIdController.text = widget.playerId.toString();
    }
  }

  Future<void> transferAmount() async {
    setState(() {
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
      final response = await transferController.amountTransfer(request);

      setState(() {
        isTransferLoading = false;
      });

      if (response?.status == "OK") {
        showDialog(
          context: context,
          builder: (_) => Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          "assets/images/transfer (2)/successful popup.png",
                        ),
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
                              "You transfer the amount \n \$${amountController.text} to Player ID ${playerIdController.text}",
                          color: Colors.white,
                          fontSize: 15,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else if (response?.status == "FAIL") {
        setState(() {
          errorMessage = response?.messages?["to"] ??
              response?.messages?["from"] ??
              response?.messages?["error"] ??
              "Transfer failed";
        });
      }
    } catch (e) {
      setState(() {
        isTransferLoading = false;
        errorMessage = "Unexpected error occurred.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    print("playeridd:${widget.playerId}");
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
                                hintText: "Transfer to Amount\$:"),
                            CustomTransferTextField(
                              controller: passwordController,
                              hintText: "Password",
                              keyboardType: TextInputType.text,
                            ),
                            isLoading
                                ? const CircularProgressIndicator()
                                : GestureDetector(
                                    onTap: () {},
                                    // onTap: () => forgotPassword(),
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
                                    // setDialogState(() {
                                    //   isMarked = !isMarked;
                                    // });
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    if (!isMarked) {
                                      await prefs.remove('remembered_password');
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
                                          child: CircularProgressIndicator()))
                                  : (errorMessage != null &&
                                          errorMessage!.isNotEmpty)
                                      ? Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: BuildTextWidget(
                                              text: errorMessage!,
                                              align: TextAlign.center,
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
                                  AffiliateTransferHistoryPopup(
                                playerResponse: widget.playerResponse,
                              ),
                            );
                          },
                          child: Image.asset(
                            "assets/images/CASHIER Button/TRANSFER/history button.png",
                            width: width / 2.4,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            transferAmount();
                          },
                          // onTap: () =>
                          //     transferAmount(setDialogState),
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
}
