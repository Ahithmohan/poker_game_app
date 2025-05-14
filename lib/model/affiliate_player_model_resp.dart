// // To parse this JSON data, do
// //
// //     final affiliatePlayerModelResp = affiliatePlayerModelRespFromJson(jsonString);
//
// import 'dart:convert';
//
// AffiliatePlayerModelResp affiliatePlayerModelRespFromJson(String str) =>
//     AffiliatePlayerModelResp.fromJson(json.decode(str));
//
// String affiliatePlayerModelRespToJson(AffiliatePlayerModelResp data) =>
//     json.encode(data.toJson());
//
// class AffiliatePlayerModelResp {
//   String? status;
//   List<Datum>? data;
//
//   AffiliatePlayerModelResp({
//     this.status,
//     this.data,
//   });
//
//   factory AffiliatePlayerModelResp.fromJson(Map<String, dynamic> json) =>
//       AffiliatePlayerModelResp(
//         status: json["status"],
//         data: json["data"] == null
//             ? []
//             : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": data == null
//             ? []
//             : List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }
//
// class Datum {
//   Name? name;
//   DateTime? regDate;
//   String? playerNickname;
//   String? balance;
//   DateTime? lastLogin;
//   int? playerId;
//   String? email;
//   int? isVip;
//   String? avatar;
//   String? commission;
//   String? totalBet;
//   String? totalWon;
//   String? totalRake;
//
//   Datum({
//     this.name,
//     this.regDate,
//     this.playerNickname,
//     this.balance,
//     this.lastLogin,
//     this.playerId,
//     this.email,
//     this.isVip,
//     this.avatar,
//     this.commission,
//     this.totalBet,
//     this.totalWon,
//     this.totalRake,
//   });
//
//   factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         name: nameValues.map[json["name"]]!,
//         regDate:
//             json["reg_date"] == null ? null : DateTime.parse(json["reg_date"]),
//         playerNickname: json["player_nickname"],
//         balance: json["balance"],
//         lastLogin: json["last_login"] == null
//             ? null
//             : DateTime.parse(json["last_login"]),
//         playerId: json["player_id"],
//         email: json["email"],
//         isVip: json["is_vip"],
//         avatar: json["avatar"],
//         commission: json["commission"],
//         totalBet: json["total_bet"],
//         totalWon: json["total_won"],
//         totalRake: json["total_rake"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "name": nameValues.reverse[name],
//         "reg_date": regDate?.toIso8601String(),
//         "player_nickname": playerNickname,
//         "balance": balance,
//         "last_login": lastLogin?.toIso8601String(),
//         "player_id": playerId,
//         "email": email,
//         "is_vip": isVip,
//         "avatar": avatar,
//         "commission": commission,
//         "total_bet": totalBet,
//         "total_won": totalWon,
//         "total_rake": totalRake,
//       };
// }
//
// enum Name { A1 }
//
// final nameValues = EnumValues({"A1": Name.A1});
//
// class EnumValues<T> {
//   Map<String, T> map;
//   late Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }

import 'dart:convert';

AffiliatePlayerModelResp affiliatePlayerModelRespFromJson(String str) =>
    AffiliatePlayerModelResp.fromJson(json.decode(str));

String affiliatePlayerModelRespToJson(AffiliatePlayerModelResp data) =>
    json.encode(data.toJson());

class AffiliatePlayerModelResp {
  String? status;
  List<Datum>? data;

  AffiliatePlayerModelResp({
    this.status,
    this.data,
  });

  factory AffiliatePlayerModelResp.fromJson(Map<String, dynamic> json) =>
      AffiliatePlayerModelResp(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  String? name;
  DateTime? regDate;
  String? playerNickname;
  String? balance;
  DateTime? lastLogin;
  int? playerId;
  String? email;
  int? isVip;
  String? avatar;
  String? avatarThumb;
  String? commission;
  String? totalBet;
  String? totalWon;
  String? totalRake;

  Datum({
    this.name,
    this.regDate,
    this.playerNickname,
    this.balance,
    this.lastLogin,
    this.playerId,
    this.email,
    this.isVip,
    this.avatar,
    this.avatarThumb,
    this.commission,
    this.totalBet,
    this.totalWon,
    this.totalRake,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json["name"], // ✅ Now plain string, avoids enum null crash
        regDate:
            json["reg_date"] == null ? null : DateTime.parse(json["reg_date"]),
        playerNickname: json["player_nickname"],
        balance: json["balance"],
        lastLogin: json["last_login"] == null
            ? null
            : DateTime.parse(json["last_login"]),
        playerId: json["player_id"],
        email: json["email"],
        isVip: json["is_vip"],
        avatar: json["avatar"],
        avatarThumb: json["avatar_thumb"],
        commission: json["commission"],
        totalBet: json["total_bet"],
        totalWon: json["total_won"],
        totalRake: json["total_rake"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "reg_date": regDate?.toIso8601String(),
        "player_nickname": playerNickname,
        "balance": balance,
        "last_login": lastLogin?.toIso8601String(),
        "player_id": playerId,
        "email": email,
        "is_vip": isVip,
        "avatar": avatar,
        "avatar_thumb": avatarThumb,
        "commission": commission,
        "total_bet": totalBet,
        "total_won": totalWon,
        "total_rake": totalRake,
      };
}
