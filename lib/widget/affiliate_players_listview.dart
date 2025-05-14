import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/affiliate_player_model_resp.dart';
import '../model/login_response_model.dart';
import '../view/affiliate_transfer_popUp.dart';
import 'build_sub_heading_text.dart';

class AffiliatePlayersListviews extends StatefulWidget {
  final LoginResponseModel? playerResponse;

  final String searchQuery;
  final String? sortField;
  final bool isAscending;

  const AffiliatePlayersListviews({
    super.key,
    required this.searchQuery,
    this.sortField,
    this.isAscending = true,
    this.playerResponse,
  });

  @override
  State<AffiliatePlayersListviews> createState() =>
      _AffiliatePlayersListviewsState();
}

class _AffiliatePlayersListviewsState extends State<AffiliatePlayersListviews> {
  late Future<List<Datum>> _futurePlayers;
  bool isMarked = false;
  bool isLoading = false;
  bool isTransferLoading = false;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController playerIdController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _futurePlayers = fetchAffiliatePlayers();
  }

  Future<List<Datum>> fetchAffiliatePlayers() async {
    final affiliate_id =
        widget.playerResponse?.data?.selfAffiliateId.toString();
    final url =
        'http://3.6.170.253:1080/server.php/api/v1/affiliate-players/$affiliate_id';
    print("affiliate player:$url");
    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      print("0000000000000000000000000000");
      final data = affiliatePlayerModelRespFromJson(response.body);
      print(data.data);
      return data.data ?? [];
    } else {
      throw Exception('Failed to fetch players');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;

    return FutureBuilder<List<Datum>>(
      future: _futurePlayers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        List<Datum> players = snapshot.data ?? [];

        List<Datum> filteredPlayers = players
            .where((p) => (p.playerNickname ?? "")
                .toLowerCase()
                .contains(widget.searchQuery.toLowerCase()))
            .toList();

        if (widget.sortField != null) {
          filteredPlayers.sort((a, b) {
            final aVal = _getSortValue(a, widget.sortField!);
            final bVal = _getSortValue(b, widget.sortField!);
            if (aVal is Comparable && bVal is Comparable) {
              return widget.isAscending
                  ? aVal.compareTo(bVal)
                  : bVal.compareTo(aVal);
            }
            return 0;
          });
        } else {
          filteredPlayers.sort((a, b) {
            final aId = a.playerId ?? 0;
            final bId = b.playerId ?? 0;
            return aId.compareTo(bId);
          });
        }

        if (filteredPlayers.isEmpty) {
          return const Center(
            child: BuildSubHeadingText(
              text: "No players found",
              color: Colors.white70,
              fontSize: 12,
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
            ),
            height: height / 1.678,
            width: width,
            child: ListView.builder(
              itemCount: filteredPlayers.length,
              itemBuilder: (context, index) {
                final player = filteredPlayers[index];

                return Column(
                  children: [
                    ClipRRect(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          width: width,
                          height: height / 16,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  "assets/images/affiliate screen/player frame.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        print(
                                            "Avatar tapped: ${player.playerNickname}");
                                        // showDialog(
                                        //                   context: context,
                                        //                   builder: (context) {
                                        //                    return const ChartLineWidget(
                                        //                     );
                                        //                   },
                                        //                 );
                                      },
                                      child: SizedBox(
                                        width: width / 10,
                                        height: width / 10,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.asset(
                                              "assets/images/affiliate screen/losing player (1).png",
                                              width: width / 10,
                                              height: width / 10,
                                              fit: BoxFit.cover,
                                            ),
                                            ClipOval(
                                              child: (player.avatar != null &&
                                                      player.avatar!.isNotEmpty)
                                                  ? Image.network(
                                                      player.avatar!,
                                                      width: width / 13,
                                                      height: width / 13,
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (context,
                                                              error,
                                                              stackTrace) =>
                                                          const Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                        size: 16,
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 13),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BuildSubHeadingText(
                                          text: "ID:#${player.playerId}",
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                        BuildSubHeadingText(
                                          text: player.playerNickname ?? '',
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AffiliateTransferPopup(
                                        playerResponse: widget.playerResponse,
                                        playerId: player.playerId,
                                      );
                                    },
                                  );
                                  print(
                                      "Transfer button clicked for ${player.playerNickname}");
                                },
                                child: Image.asset(
                                  "assets/images/affiliate screen/aff_transfer button.png",
                                  width: 40,
                                ),
                              ),
                              _buildPlayerStat(
                                  player.balance ?? "-", Colors.white70, 9),
                              _buildPlayerStat("\$${player.totalWon ?? '0'}",
                                  Colors.green, 9),
                              _buildPlayerStat("\$${player.totalRake ?? '0'}",
                                  Colors.white70, 9),
                              _buildPlayerStat("\$${player.commission ?? '0'}",
                                  Colors.white70, 9),
                              const SizedBox(width: 15),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  dynamic _getSortValue(Datum player, String field) {
    String cleanNumeric(String? value) {
      return value?.replaceAll(RegExp(r'[^\d.-]'), '') ?? '0';
    }

    switch (field) {
      case 'playerNickname':
        return player.playerNickname?.toLowerCase() ?? '';
      case 'totalWon':
        return double.tryParse(cleanNumeric(player.totalWon)) ?? 0.0;
      case 'totalRake':
        return double.tryParse(cleanNumeric(player.totalRake)) ?? 0.0;
      case 'commission':
        return double.tryParse(cleanNumeric(player.commission)) ?? 0.0;
      case 'balance':
        return double.tryParse(cleanNumeric(player.balance)) ?? 0.0;
      default:
        return 0;
    }
  }

  Widget _buildPlayerStat(String text, Color color, double fontSize) {
    return BuildSubHeadingText(
      text: text,
      color: color,
      fontSize: fontSize,
    );
  }
}
