class ChatRoomItem {
  String roomKey;
  String roomName;
  int type;
  int creatorID;
  int roomMasterID;
  String createdDate;
  bool isRename;
  int totalNewMessage;
  int id;
  ChatRoomItem({
    this.roomKey,
    this.roomName,
    this.type,
    this.creatorID,
    this.roomMasterID,
    this.createdDate,
    this.isRename,
    this.totalNewMessage,
    this.id,
  });
  ChatRoomItem.fromMap(Map<String, dynamic> map) {
    roomKey = map['RoomKey'];
    roomName = map['RoomName'];
    type = map['Type'];
    creatorID = map['CreatorID'];
    roomMasterID = map['RoomMasterID'];
    createdDate = map['CreatedDate'];
    isRename = map['IsRename'];
    totalNewMessage = map['TotalNewMessage'];
    id = map["ID"];
  }
}
