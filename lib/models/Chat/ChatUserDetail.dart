import 'package:app_eoffice/models/Nguoidungitem.dart';

class ChatUserDetail {
  String connectionID;
  int userID;
  bool connected;
  String connectTime;
  String disconnectTime;
  NguoiDungItem nguoiDungItem;

  ChatUserDetail({
    this.connectionID,
    this.userID,
    this.connected,
    this.connectTime,
    this.disconnectTime,
    this.nguoiDungItem,
  });
  ChatUserDetail.fromMap(Map<String, dynamic> map) {
    connectionID = map['connectionID'];
    userID = map['userID'];
    connected = map['connected'];
    connectTime = map['connectTime'];
    // if (map['nguoiDungItem'] != null && map['nguoiDungItem'].length > 0) {
    //   var vbData = map['nguoiDungItem'];
    //   nguoiDungItem = NguoiDungItem.fromMap(vbData);
    // } else
    //   nguoiDungItem = new NguoiDungItem();
  }

  factory ChatUserDetail.fromJson(Map<String, dynamic> usersjson) =>
      ChatUserDetail(
        connectionID: usersjson["connectionID"],
        userID: usersjson["userID"],
        connected: usersjson["connected"],
        connectTime: usersjson["connectTime"],
      );
}
