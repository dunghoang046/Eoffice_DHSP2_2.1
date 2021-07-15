import 'FileAttachItem.dart';

class ThongTinDatPhongItem {
  int id;
  String thoigianbatdau;
  String thoigianketthuc;
  String noidung;
  String nguoidangky;
  int trangthaiid;
  int donviid;
  String tendonvi;
  String donvidangky;
  String sodienthoai;
  String email;
  int nguoitaoid;
  String lanhdaochutri;
  List<FileAttachItem> lstfile;
  int totalRecord;
  String songuoi;
  int phonghopid;
  String lydo;
  String tenphonghopmongmuon;
  String yeucau;
  String thanhphanthamgia;
  ThongTinDatPhongItem(
      {this.id,
      this.thoigianbatdau,
      this.thoigianketthuc,
      this.noidung,
      this.nguoidangky,
      this.trangthaiid,
      this.donviid,
      this.tendonvi,
      this.sodienthoai,
      this.email,
      this.lanhdaochutri,
      this.lstfile,
      this.totalRecord,
      this.songuoi,
      this.donvidangky,
      this.phonghopid,
      this.nguoitaoid,
      this.tenphonghopmongmuon,
      this.thanhphanthamgia,
      this.yeucau,
      this.lydo});
  ThongTinDatPhongItem.fromMap(Map<String, dynamic> map) {
    id = map['ID'];
    totalRecord = map['TotalRecord'];
    thoigianbatdau = map['ThoiGianBatDau'];
    thoigianketthuc = map['ThoiGianKetThuc'];
    sodienthoai = map['SoDienThoai'];
    email = map['Email'];
    lanhdaochutri = map['LanhDaoChuTri'];
    noidung = map['NoiDung'];
    trangthaiid = map['TrangThaiID'];
    nguoidangky = map['NguoiDangKy'];
    songuoi = map['SoNguoi'];
    phonghopid = map['PhongHopID'];
    lydo = map['LyDoTuChoi'];
    tendonvi = map['TenDonVi'];
    nguoitaoid = map['NguoiTaoID'];
    thanhphanthamgia = map['ThanhPhanThamDu'];
    donvidangky = map['DonViDangKy'];
    yeucau = map['YeuCau'];
    if (map['LtsFileAttach'] != null && map['LtsFileAttach'].length > 0) {
      List<dynamic> vbData = map['LtsFileAttach'];
      lstfile = vbData.map((f) => FileAttachItem.fromMap(f)).toList();
    } else
      lstfile = <FileAttachItem>[];
  }
}
