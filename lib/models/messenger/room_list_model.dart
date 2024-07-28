import 'package:startup_boilerplate/models/common/common_link_model.dart';

class RoomListModel {
  Rooms? rooms;

  RoomListModel({
    this.rooms,
  });

  factory RoomListModel.fromJson(Map<String, dynamic> json) => RoomListModel(
        rooms: json["rooms"] == null ? null : Rooms.fromJson(json["rooms"]),
      );
}

class Rooms {
  int? currentPage;
  List<RoomData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<CommonLink>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Rooms({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory Rooms.fromJson(Map<String, dynamic> json) => Rooms(
        currentPage: json["current_page"],
        data: json["data"] == null ? [] : List<RoomData>.from(json["data"]!.map((x) => RoomData.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: json["links"] == null ? [] : List<CommonLink>.from(json["links"]!.map((x) => CommonLink.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );
}

class RoomData {
  int? id;
  dynamic name;
  dynamic image;
  int? status;
  int? type;
  dynamic creatorId;
  dynamic kidId;
  dynamic storeId;
  int? lastMessageId;
  int? lastMessageSenderId;
  DateTime? updatedAt;
  String? roomName;
  List<String>? roomImage;
  int? roomUserId;
  List<Participant>? participants;

  RoomData(
      {this.id,
      this.name,
      this.image,
      this.status,
      this.type,
      this.creatorId,
      this.kidId,
      this.storeId,
      this.lastMessageId,
      this.lastMessageSenderId,
      this.roomName,
      this.roomImage,
      this.roomUserId,
      this.participants,
      this.updatedAt});

  factory RoomData.fromJson(Map<String, dynamic> json) => RoomData(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        status: json["status"],
        type: json["type"],
        creatorId: json["creator_id"],
        kidId: json["kid_id"],
        storeId: json["store_id"],
        lastMessageId: json["last_message_id"],
        lastMessageSenderId: json["last_message_sender_id"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        roomName: json["room_name"],
        roomImage: json["room_image"] == null ? [] : List<String>.from(json["room_image"]!.map((x) => x)),
        roomUserId: json["room_user_id"],
        participants: json["participants"] == null ? [] : List<Participant>.from(json["participants"]!.map((x) => Participant.fromJson(x))),
      );
}

class Participant {
  int? id;
  int? mRoomId;
  int? userId;
  String? userNickname;
  dynamic deletedMessageId;
  int? isDeleted;
  int? isArchived;
  dynamic archivedAt;

  Participant({
    this.id,
    this.mRoomId,
    this.userId,
    this.userNickname,
    this.deletedMessageId,
    this.isDeleted,
    this.isArchived,
    this.archivedAt,
  });

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        id: json["id"],
        mRoomId: json["m_room_id"],
        userId: json["user_id"],
        userNickname: json["user_nickname"],
        deletedMessageId: json["deleted_message_id"],
        isDeleted: json["is_deleted"],
        isArchived: json["is_archived"],
        archivedAt: json["archived_at"],
      );
}
