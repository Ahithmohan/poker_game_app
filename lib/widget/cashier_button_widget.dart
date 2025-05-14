import 'package:flutter/material.dart';
import 'package:pokerpad/provider/cashier_button_provider.dart';
import 'package:pokerpad/provider/login_provider.dart';
import 'package:pokerpad/view/profile_button_page.dart';
import 'package:pokerpad/widget/deposit_button_widget.dart';
import 'package:provider/provider.dart';

import '../model/login_response_model.dart';
import 'build_button_image_widget.dart';

class CashierButtonWidget extends StatefulWidget {
  final LoginResponseModel? playerResponse;

  const CashierButtonWidget({super.key, this.playerResponse});

  @override
  State<CashierButtonWidget> createState() => _CashierButtonWidgetState();
}

class _CashierButtonWidgetState extends State<CashierButtonWidget> {
  String scannedCode = "";
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final provider = Provider.of<CashierButtonProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    return GestureDetector(
      onTap: () {
        // final kyc = widget.playerResponse?.data?.kyc;
        // final idRejected = kyc?.idStatus?.toLowerCase() == 'rejected';
        // final faceRejected = kyc?.faceStatus?.toLowerCase() == 'rejected';
        provider.setClicked(true);
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setDialogState) {
                final kyc = loginProvider.kycStatus;
                final idStatus = kyc["id"]?.toLowerCase();
                final photoStatus = kyc["photo"]?.toLowerCase();

                final idRejected = idStatus == 'rejected';
                final faceRejected = photoStatus == 'rejected';
                if (idRejected || faceRejected) {
                  // return const KycInfoPopup();
                  return ProfileButtonPage(
                    playerResponse: widget.playerResponse,
                  );
                } else {
                  return DepositButtonWidget(
                    playerResponse: widget.playerResponse,
                  );
                }
              },
            );

            DepositButtonWidget(
              playerResponse: widget.playerResponse,
            );
          },
        ).then((_) {
          provider.setClicked(false);
        });
      },
      child: BuildButtonImageWidget(
        imgPath: provider.isClicked
            ? "assets/images/lobby/Cashier Button active.png"
            : "assets/images/lobby/cashier button passive.png",
      ),
    );
  }
}
