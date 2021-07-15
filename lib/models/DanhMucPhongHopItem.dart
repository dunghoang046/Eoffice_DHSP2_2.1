class DanhMucPhongHopItem {
  int id;
  String ten;
  int thuTu;
  bool suDung;
  String diadiem;
  String dientich;
  DanhMucPhongHopItem(
      {this.id,
      this.ten,
      this.thuTu,
      this.suDung,
      this.diadiem,
      this.dientich});
  DanhMucPhongHopItem.fromMap(Map<String, dynamic> map) {
    id = map['ID'];
    ten = map['Ten'];
    thuTu = map['ThuTu'];
    diadiem = map['DiaDiem'];
    dientich = map['DienTich'];
  }
}
