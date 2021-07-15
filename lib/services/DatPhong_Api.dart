import 'package:app_eoffice/models/DanhMucPhongHopItem.dart';
import 'package:app_eoffice/models/Nguoidungitem.dart';
import 'package:app_eoffice/models/ThongTinDatPhongItem.dart';
import 'Base_service.dart';

// ignore: camel_case_types
class DatPhong_Api {
  Base_service base_service = new Base_service();
  Future<List<ThongTinDatPhongItem>> getdatphong(dataquery, currentPage) async {
    try {
      var url = "/datphong/Getthongtindatphong";
      List<dynamic> vbData = await base_service.getbase(dataquery, url);
      var lst = vbData.map((f) => ThongTinDatPhongItem.fromMap(f)).toList();
      return lst;
    } catch (e) {
      // return new List<WorkTaskItem>();
      throw Exception('Failed to get data');
    }
  }

  Future<List<NguoiDungItem>> getlaixe(dataquery) async {
    try {
      var url = "/datphong/getlaixe";
      List<dynamic> vbData = await base_service.getbase(dataquery, url);
      var lst = vbData.map((f) => NguoiDungItem.fromMap(f)).toList();
      return lst;
    } catch (e) {
      // return new List<WorkTaskItem>();
      throw Exception('Failed to get data');
    }
  }

  Future<List<DanhMucPhongHopItem>> getdanhmucphong(dataquery) async {
    try {
      var url = "/datphong/getdanhmucphonghop";
      List<dynamic> vbData = await base_service.getbase(dataquery, url);
      var lst = vbData.map((f) => DanhMucPhongHopItem.fromMap(f)).toList();
      return lst;
    } catch (e) {
      throw Exception('Failed to get data');
    }
  }

  // lấy chi tiết
  Future<ThongTinDatPhongItem> getbyId(dataquery) async {
    try {
      var url = "/datphong/GetByID";
      var vbData = await base_service.getbase(dataquery, url);
      var obj = ThongTinDatPhongItem.fromMap(vbData);
      return obj;
    } catch (ex) {
      return new ThongTinDatPhongItem();
    }
  }

  // post gửi đặt xe
  Future<dynamic> postsend(dataquery) async {
    try {
      var url = "/datphong/Send";
      var message = await base_service.post(dataquery, url);
      return message;
    } catch (ex) {
      return ex;
    }
  }

  Future<dynamic> postapproved(dataquery) async {
    try {
      var url = "/datphong/Approved";
      var message = await base_service.post(dataquery, url);
      return message;
    } catch (ex) {
      return ex;
    }
  }

  Future<dynamic> postReject(dataquery) async {
    try {
      var url = "/datxe/Reject";
      var message = await base_service.post(dataquery, url);
      return message;
    } catch (ex) {
      return ex;
    }
  }
}
