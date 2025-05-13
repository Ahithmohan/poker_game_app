import 'package:flutter/material.dart';
import 'package:pokerpad/view/profile_phone_number.dart';
import 'package:pokerpad/widget/build_sub_heading_text.dart';
import 'package:provider/provider.dart';

import '../model/login_response_model.dart';
import '../provider/login_provider.dart';
import '../provider/profile_country_provider.dart';
import 'face_check_popUp.dart';

class ProfileButtonPage extends StatefulWidget {
  final LoginResponseModel? playerResponse;

  const ProfileButtonPage({super.key, this.playerResponse});

  @override
  State<ProfileButtonPage> createState() => _ProfileButtonPageState();
}

class _ProfileButtonPageState extends State<ProfileButtonPage> {
  @override
  Widget build(BuildContext context) {
    // final kyc = loginProvider.kycStatus;
    // final idStatus = kyc["id"];
    // final photoStatus = kyc["photo"];
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        final kyc = loginProvider.kycStatus;
        final idStatus = kyc["id"];
        final photoStatus = kyc["photo"];
        print("kyc Status profile : id=$idStatus photo=$photoStatus");

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
                    'assets/images/cashier/deposit image/bank  frame (1).png',
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 60,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 68,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                  "assets/images/profilebutton/name_field.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(11.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                BuildSubHeadingText(
                                  text: widget.playerResponse?.data!.nickname ??
                                      "No Name",
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                                Spacer(),
                                BuildSubHeadingText(
                                  text: widget.playerResponse?.data!.id
                                          ?.toString() ??
                                      "No id",
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 2,
                            ),
                            Container(
                              height: height / 15,
                              width: width / 2.4,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage(
                                      "assets/images/profilebutton/mail_phone_field.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  widget.playerResponse?.data!.email
                                          ?.toString() ??
                                      "No email",
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Stack(
                              children: [
                                Container(
                                  height: height / 15,
                                  width: width / 2.4,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/profilebutton/mail_phone_field.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Center(
                                    child: Consumer<ProfileCountryProvider>(
                                      builder: (context, countryProvider, _) {
                                        final phone = countryProvider
                                                .phoneNumber.isNotEmpty
                                            ? "${countryProvider.countryCode} ${countryProvider.phoneNumber}"
                                            : widget.playerResponse?.data
                                                    ?.phone ??
                                                "No phone";

                                        return Text(
                                          phone,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                    ),

                                    // Text(
                                    //   widget.playerResponse?.data!.phone
                                    //           ?.toString() ??
                                    //       "No phone",
                                    //   style: const TextStyle(
                                    //       color: Colors.white70, fontSize: 12),
                                    // ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 190, top: 1),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ProfilePhoneNumber(
                                            playerResponse:
                                                widget.playerResponse,
                                          );
                                        },
                                      );
                                    },
                                    child: Image.asset(
                                        width: 59,
                                        "assets/images/profilebutton/edit_button_passive.png"),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        // (photoStatus == "Rejected")
                        //     ? Column(
                        //         children: [
                        //           Container(
                        //             height: height / 12,
                        //             width: width / 1,
                        //             decoration: BoxDecoration(
                        //               image: const DecorationImage(
                        //                 image: AssetImage(
                        //                     "assets/images/profilebutton/profile_alerts.png"),
                        //                 fit: BoxFit.cover,
                        //               ),
                        //             ),
                        //             child: Padding(
                        //               padding: const EdgeInsets.all(18.0),
                        //               child: Center(
                        //                   child: BuildSubHeadingText(
                        //                 text:
                        //                     "We're sorry, but your Face Check picture has not been accepted. Please review \nthe requirements and try again. If you need assistance feel free to contact our \nsupport team for guidance. Thank you for your understanding!",
                        //                 fontSize: 10,
                        //                 color: Colors.black,
                        //               )),
                        //             ),
                        //           ),
                        //           SizedBox(height: 10),
                        //         ],
                        //       )
                        //     : Container(
                        //         height: height / 12,
                        //         width: width / 1,
                        //         decoration: BoxDecoration(
                        //           image: const DecorationImage(
                        //             image: AssetImage(
                        //                 "assets/images/profilebutton/profile_alerts.png"),
                        //             fit: BoxFit.cover,
                        //           ),
                        //         ),
                        //         child: Padding(
                        //           padding: const EdgeInsets.all(18.0),
                        //           child: Center(
                        //               child: BuildSubHeadingText(
                        //             text:
                        //                 "Thank you for your submission! Your Face check verification is currently in progress. Please be patient as our team reviews your picture.if you have any questions, feel free to reach out to our support team.",
                        //             fontSize: 10,
                        //             color: Colors.black,
                        //           )),
                        //         ),
                        //       ),

                        if (photoStatus == "Rejected")
                          Column(
                            children: [
                              Container(
                                height: height / 12,
                                width: width,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/profilebutton/profile_alerts.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Center(
                                    child: BuildSubHeadingText(
                                      text:
                                          "We're sorry, but your Face Check picture has not been accepted. Please review \nthe requirements and try again. If you need assistance feel free to contact our \nsupport team for guidance. Thank you for your understanding!",
                                      fontSize: 10,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          )
                        else if (photoStatus == "Pending")
                          Container(
                            height: height / 12,
                            width: width,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/profilebutton/profile_alerts.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Center(
                                child: BuildSubHeadingText(
                                  text:
                                      "Thank you for your submission! Your Face check verification is currently in progress. Please be patient as our team reviews your picture. If you have any questions, feel free to reach out to our support team.",
                                  fontSize: 10,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: height / 11,
                          ),

                        SizedBox(
                          height: height / 13.5,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              width: 2,
                            ),
                            GestureDetector(
                              onTap: (photoStatus == "Rejected")
                                  ? () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return FaceCheckPopup(
                                            playerResponse:
                                                widget.playerResponse,
                                          );
                                        },
                                      );
                                    }
                                  : null,
                              child: Container(
                                height: height / 15,
                                width: width / 2.4,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/profilebutton/kyc_field.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Center(
                                    child: BuildSubHeadingText(
                                  text: "FACE CHECK",
                                  fontSize: 14,
                                  color: Colors.white,
                                )),
                              ),
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Container(
                              height: height / 15,
                              width: width / 2.4,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(photoStatus == "Approved"
                                      ? "assets/images/profilebutton/verified_button.png"
                                      : photoStatus == "Rejected"
                                          ? "assets/images/profilebutton/try_again_button.png"
                                          : "assets/images/profilebutton/pending_notification.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     SizedBox(
                        //       width: 2,
                        //     ),
                        //     GestureDetector(
                        //       onTap: (idStatus == "Rejected")
                        //           ? () {
                        //               showDialog(
                        //                 context: context,
                        //                 builder: (context) {
                        //                   return ProofOfIdentityPopup(
                        //                     playerResponse:
                        //                         widget.playerResponse,
                        //                   );
                        //                 },
                        //               );
                        //             }
                        //           : null,
                        //       child: Container(
                        //         height: height / 15,
                        //         width: width / 2.4,
                        //         decoration: BoxDecoration(
                        //           image: const DecorationImage(
                        //             image: AssetImage(
                        //                 "assets/images/profilebutton/kyc_field.png"),
                        //             fit: BoxFit.cover,
                        //           ),
                        //         ),
                        //         child: Center(
                        //             child: BuildSubHeadingText(
                        //           text: "PROOF OF IDENTITY",
                        //           fontSize: 14,
                        //           color: Colors.white,
                        //         )),
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: 14,
                        //     ),
                        //     Container(
                        //       height: height / 15,
                        //       width: width / 2.4,
                        //       decoration: BoxDecoration(
                        //         image: DecorationImage(
                        //           image: AssetImage(idStatus == "Approved"
                        //               ? "assets/images/profilebutton/verified_button.png"
                        //               : idStatus == "Rejected"
                        //                   ? "assets/images/profilebutton/try_again_button.png"
                        //                   : "assets/images/profilebutton/pending_notification.png"),
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
