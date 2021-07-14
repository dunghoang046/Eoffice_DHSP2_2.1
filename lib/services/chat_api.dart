import 'package:app_eoffice/models/Chat/message_model.dart';
import 'package:app_eoffice/models/Nguoidungitem.dart';
import 'Base_service.dart';

// ignore: camel_case_types
class Chat_Api {
  Base_service base_service = new Base_service();

  Future<List<MessageChat>> getPrivateMessage(dataquery, currentPage) async {
    try {
      var url = "/Chat/GetPrivateMessage";
      List<dynamic> vbData = await base_service.getbase(dataquery, url);
      var lst = vbData.map((f) => MessageChat.fromMap(f)).toList();
      return lst;
    } catch (e) {
      throw Exception('Failed to get data');
    }
  }

  Future<List<MessageChat>> getGroupChatMessage(dataquery, currentPage) async {
    try {
      var url = "/Chat/GetGroupChatData";
      List<dynamic> vbData = await base_service.getbase(dataquery, url);
      var lst = vbData.map((f) => MessageChat.fromMap(f)).toList();
      return lst;
    } catch (e) {
      throw Exception('Failed to get data');
    }
  }

  Future<List<NguoiDungItem>> getAllNguoiDung(dataquery) async {
    try {
      var url = "/Chat/GetallNguoiDung";
      List<dynamic> vbData = await base_service.getbase(dataquery, url);
      var lst = vbData.map((f) => NguoiDungItem.fromMap(f)).toList();
      return lst;
    } catch (e) {
      throw Exception('Failed to get data');
    }
  }
}
