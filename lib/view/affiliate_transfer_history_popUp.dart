import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/get_transfer_history_model.dart';
import '../model/login_response_model.dart';
import '../widget/build_sub_heading_text.dart';

class AffiliateTransferHistoryPopup extends StatefulWidget {
  final LoginResponseModel? playerResponse;

  const AffiliateTransferHistoryPopup({super.key, this.playerResponse});

  @override
  State<AffiliateTransferHistoryPopup> createState() =>
      _AffiliateTransferHistoryPopupState();
}

class _AffiliateTransferHistoryPopupState
    extends State<AffiliateTransferHistoryPopup> {
  final TextEditingController searchController = TextEditingController();
  List<Datum> transferList = [];
  List<Datum> filteredTransferList = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getTransferHistory();
    print("id:${widget.playerResponse?.data?.id}");

    searchController.addListener(() {
      setState(() {
        filteredTransferList = transferList.where((item) {
          final nickname = item.nickname?.toLowerCase() ?? '';
          return nickname.contains(searchController.text.toLowerCase());
        }).toList();
      });
    });
  }

  Future<void> getTransferHistory() async {
    final playerId = widget.playerResponse?.data?.id;

    if (playerId == null) {
      print("Player ID is null. Cannot fetch transfer history.");
      return;
    }

    final url =
        "http://3.6.170.253:1080/server.php/api/v1/player-transfer-history/$playerId";
    print("Requesting URL: $url");

    try {
      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        final transferHistory = GetTransferHistoryModel.fromJson(response.data);

        if (transferHistory.status == "OK") {
          print("✅ Transfer History Loaded Successfully");

          setState(() {
            transferList = transferHistory.data?.data ?? [];
            filteredTransferList = List.from(transferList);
            isLoading = false;
          });
        } else {
          print("❌ API returned failure: ${transferHistory.status}");
          setState(() {
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("❗ Exception occurred while fetching history: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
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
                'assets/images/transfer (2)/transferhistory/bank frame (3).png',
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 58),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                            "assets/images/transfer (2)/transferhistory/2nd layer (1).png"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Stack(
                                children: [
                                  Image.asset(
                                    width: width / 1.1,
                                    "assets/images/transfer (2)/transferhistory/search tab (1).png",
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25, left: 35, right: 35),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 18),
                                        Material(
                                          color: Colors.transparent,
                                          child: SizedBox(
                                            width: 67,
                                            height: 17,
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              controller: searchController,
                                              cursorColor: Colors.white,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10),
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "SEARCH",
                                                  hintStyle: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.white)),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 75),
                                        const BuildSubHeadingText(
                                          text: "time",
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 100),
                                        const BuildSubHeadingText(
                                          text: "date",
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 80),
                                        const BuildSubHeadingText(
                                          text: "amount",
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                width: width / 1.23,
                                height: height / 4.7,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.transparent,
                                ),
                                child: isLoading
                                    ? const Center(
                                        child: CircularProgressIndicator())
                                    : ListView.builder(
                                        padding: const EdgeInsets.only(top: 12),
                                        itemCount: filteredTransferList.length,
                                        itemBuilder: (context, index) {
                                          final item =
                                              filteredTransferList[index];
                                          final createdAt = item.createdAt;

                                          final formattedDate =
                                              createdAt != null
                                                  ? DateFormat('dd-MM-yyyy')
                                                      .format(createdAt)
                                                  : 'N/A';
                                          final formattedTime =
                                              createdAt != null
                                                  ? DateFormat('HH:mm:ss')
                                                      .format(createdAt)
                                                  : 'N/A';

                                          final nickname =
                                              item.nickname ?? 'Unknown';

                                          return Stack(
                                            children: [
                                              Image.asset(
                                                  "assets/images/transfer (2)/transferhistory/player frame (3).png"),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5, right: 20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: width / 9,
                                                          height: height / 17,
                                                          decoration: const BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      "assets/images/affiliate screen/winning player (1).png"))),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom: 3),
                                                            child: Center(
                                                              child: ClipOval(
                                                                child: Image
                                                                    .network(
                                                                  item.avatar ??
                                                                      "",
                                                                  width: width /
                                                                      14.5,
                                                                  height:
                                                                      height /
                                                                          22.6,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder: (context,
                                                                          error,
                                                                          stackTrace) =>
                                                                      const Icon(
                                                                          Icons
                                                                              .person),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: width / 8,
                                                          child: Column(
                                                            children: [
                                                              BuildSubHeadingText(
                                                                text: item
                                                                        .playerIdRef
                                                                        ?.toString() ??
                                                                    'N/A',
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                              ),
                                                              BuildSubHeadingText(
                                                                text: nickname,
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 15),
                                                    SizedBox(
                                                      width: width / 6,
                                                      child:
                                                          BuildSubHeadingText(
                                                        text: formattedTime,
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width / 7,
                                                      child:
                                                          BuildSubHeadingText(
                                                        text: formattedDate,
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    BuildSubHeadingText(
                                                      text:
                                                          "\$${item.chip ?? 0}",
                                                      color: (item.chip !=
                                                                  null &&
                                                              double.tryParse(item
                                                                      .chip!) !=
                                                                  null &&
                                                              double.parse(item
                                                                      .chip!) <
                                                                  0)
                                                          ? Colors.red
                                                          : Colors.green,
                                                      fontSize: 10,
                                                    ),
                                                    const SizedBox(width: 5),
                                                  ],
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          width: width / 2.4,
                          "assets/images/transfer (2)/transferhistory/history active (1).png",
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            "assets/images/transfer (2)/transferhistory/transfer passive (1).png",
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
