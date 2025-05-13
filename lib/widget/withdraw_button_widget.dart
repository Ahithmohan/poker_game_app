import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pokerpad/controller/cashier_controller.dart';
import 'package:pokerpad/model/withdraw_request_model.dart';
import 'package:pokerpad/provider/cashier_button_provider.dart';
import 'package:pokerpad/provider/qr_provider.dart';
import 'package:pokerpad/view/qr_scan_page.dart';
import 'package:pokerpad/widget/build_text_widget.dart';
import 'package:provider/provider.dart';

import '../controller/forgot_password_controller.dart';
import '../model/forgot_password_model.dart';
import '../model/login_response_model.dart';

class WithdrawButtonWidget extends StatefulWidget {
  final LoginResponseModel? playerResponse;

  const WithdrawButtonWidget({
    super.key,
    this.playerResponse,
  });

  @override
  State<WithdrawButtonWidget> createState() => _WithdrawButtonWidgetState();
}

class _WithdrawButtonWidgetState extends State<WithdrawButtonWidget> {
  String scannedCode = ""; // Store scanned QR code
  final MobileScannerController controller = MobileScannerController();
  int selectedButton = 1;
  bool isLoading = false;
  bool isForgotLoading = false;
  TextEditingController withdrawAmountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final CashierController cashierController = CashierController();
  ForgotPasswordController forgotPasswordController =
      ForgotPasswordController();

  String? errorMessage;

  Future<void> withDrawAmount() async {
    print("id:${widget.playerResponse?.data!.id}");
    final qrProvider =
        Provider.of<QrProvider>(context, listen: false); // Add this

    if (!mounted) return; // Prevents setState after widget is disposed

    setState(() {
      isLoading = true;
    });

    final request = WithdrawRequestModel(
        playerId: widget.playerResponse?.data!.id.toString(),
        currency: "usdc",
        network: "solana",
        password: passwordController.text,
        chips: int.tryParse(withdrawAmountController.text) ?? 0,
        toAc: qrProvider.scannedCode);

    try {
      final response = await cashierController.postWithdraw(request);
      print("response:${response.data}");

      if (!mounted) return; // Prevents further execution if widget is disposed

      setState(() {
        isLoading = false;
      });

      if (response.status == "OK") {
        Navigator.pop(context);

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     duration: const Duration(milliseconds: 350),
        //     elevation: 10,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(24),
        //     ),
        //     behavior: SnackBarBehavior.floating,
        //     backgroundColor: CupertinoColors.activeGreen,
        //     content: Text(
        //       "Success!: ${response.status}, ID: ${response.data?.id ?? "N/A"}",
        //     ),
        //   ),
        // );
      } else {
        setState(() {
          errorMessage = " Unable to initiate redeem, Verification failed";
        });
        print("API Failure: ${response.status}, Message: ${response.messages}");

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     duration: const Duration(milliseconds: 350),
        //     elevation: 10,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(24),
        //     ),
        //     behavior: SnackBarBehavior.floating,
        //     backgroundColor: CupertinoColors.systemRed,
        //     content: Text("Fail!: ${response.messages ?? "Unknown error"}"),
        //   ),
        // );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
      //
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     duration: const Duration(milliseconds: 350),
      //     elevation: 10,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(24),
      //     ),
      //     behavior: SnackBarBehavior.floating,
      //     backgroundColor: CupertinoColors.systemRed,
      //     content: Text("API Error: $e"),
      //   ),
      // );

      print("API Error: $e");
    }
  }

  Future<void> forgotPassword() async {
    setState(() {
      isForgotLoading = true;
    });

    final request = ForgotPasswordRequestModel(
      email: widget.playerResponse?.data?.email ?? "",
    );
    print(request.email);
    try {
      final response = await ForgotPasswordController().forgotPassword(request);

      setState(() {
        isForgotLoading = false;
      });

      if (response != null) {
        print("okkkkkkkkkkkkkkkkk");
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return WithdrawForgotPassword(
        //       playerResponse: widget.playerResponse,
        //     );
        //   },
        // );
      }
    } catch (e, stackTrace) {
      setState(() {
        isForgotLoading = false;
      });
      debugPrint('Forgot password error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final provider = Provider.of<CashierButtonProvider>(context);
    final qrProvider = Provider.of<QrProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Dialog(
        alignment: Alignment.topCenter,
        backgroundColor: Colors.transparent,
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height / 2,
          width: MediaQuery.sizeOf(context).width,
          child: Stack(
            children: [
              Image.asset(
                width: width,
                height: height / 2,
                'assets/images/cashier/withdraw images/bank  frame (1).png',
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        //left side column
                        Column(
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                    width:
                                        MediaQuery.sizeOf(context).width / 2.2,
                                    "assets/images/cashier/withdraw images/withdraw_currency-network frame.png"),
                                Positioned(
                                    left: 14,
                                    top: 29,
                                    child: Image.asset(
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                2.5,
                                        "assets/images/cashier/withdraw images/withdraw_usdc.png")),
                                Positioned(
                                    left: 14,
                                    top: height / 10,
                                    child: Image.asset(
                                        width:
                                            MediaQuery.sizeOf(context).width /
                                                2.5,
                                        "assets/images/cashier/withdraw images/withdraw_solana.png")),
                              ],
                            ),
                            Stack(
                              children: [
                                // Background Image
                                Image.asset(
                                  "assets/images/cashier/withdraw/withdraw amount-password.png",
                                  width: MediaQuery.sizeOf(context).width / 2.2,
                                  fit: BoxFit.cover,
                                ),

                                // TextField without border
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 49,
                                      vertical: 23), // Adjust as needed
                                  child: SizedBox(
                                    width: MediaQuery.sizeOf(context).width /
                                        3.5, // To fit inside the image
                                    child: TextField(
                                      controller: withdrawAmountController,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration:
                                          const InputDecoration.collapsed(
                                        hintText: "Withdraw Amount: \$",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                // Background Image
                                Image.asset(
                                  "assets/images/cashier/withdraw/withdraw amount-password.png",
                                  width: MediaQuery.sizeOf(context).width / 2.2,
                                  fit: BoxFit.cover,
                                ),

                                // TextField without border
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 49,
                                      vertical: 23), // Adjust as needed
                                  child: SizedBox(
                                    width: MediaQuery.sizeOf(context).width /
                                        3.5, // To fit inside the image
                                    child: TextField(
                                      controller: passwordController,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                      decoration:
                                          const InputDecoration.collapsed(
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                      ),
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            isForgotLoading
                                ? const SizedBox(
                                    height: 17,
                                    width: 15,
                                    child: CircularProgressIndicator())
                                : GestureDetector(
                                    onTap: () {
                                      forgotPassword();
                                    },
                                    child: const Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                  ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                  width: MediaQuery.sizeOf(context).width / 2.3,
                                  "assets/images/cashier/withdraw images/deposit button black.png"),
                            ),
                          ],
                        ),
                        //right side column
                        Column(
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                    width: width / 2.6,
                                    "assets/images/cashier/withdraw images/receival address holder.png"),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 29, left: 30),
                                  child: GestureDetector(
                                    onTap: () async {
                                      final scannedValue = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const QrScanPage(),
                                        ),
                                      );

                                      if (scannedValue != null) {
                                        setState(() {
                                          scannedCode =
                                              scannedValue; // Update state with scanned value
                                        });
                                      }
                                    },
                                    child: Image.asset(
                                      width: MediaQuery.sizeOf(context).width /
                                          3.5,
                                      "assets/images/cashier/withdraw/scan qr code.png",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Stack(
                              children: [
                                Image.asset(
                                    width:
                                        MediaQuery.sizeOf(context).width / 2.6,
                                    "assets/images/cashier/withdraw images/receival address code holder.png"),
                                Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, top: 15),
                                    width: MediaQuery.sizeOf(context).width / 3,
                                    child: Consumer<QrProvider>(
                                      builder: (context, qrProvider, child) {
                                        return Text(
                                          qrProvider.scannedCode,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            overflow: TextOverflow.clip,
                                          ),
                                        );
                                      },
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.sizeOf(context).width / 2.6,
                              height: height / 10,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      "assets/images/cashier/withdraw images/withdraw alert holder.png"),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: BuildTextWidget(
                                    text: errorMessage ?? "",
                                    align: TextAlign.center,
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            // Image.asset(
                            //     width: MediaQuery.sizeOf(context).width / 2.6,
                            //     "assets/images/cashier/withdraw images/withdraw alert holder.png"),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 60,
                              width: MediaQuery.sizeOf(context).width / 2.6,
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : GestureDetector(
                                      onTap: () {
                                        provider.setClicked(false);
                                        withDrawAmount();
                                      },
                                      child: Image.asset(
                                          width:
                                              MediaQuery.sizeOf(context).width /
                                                  2.6,
                                          "assets/images/cashier/withdraw images/withdraw button white.png"),
                                    ),
                            )
                          ],
                        )
                      ],
                    ),
                    const Row(
                      children: [
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
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
