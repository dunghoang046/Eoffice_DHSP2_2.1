import 'package:app_eoffice/models/ModelForm/NguoiDungThucHienCongViecItem.dart';
import 'package:app_eoffice/models/Nguoidungitem.dart';
import 'package:app_eoffice/models/WorkTaskItem.dart';
import 'package:app_eoffice/services/CongViec_Api.dart';
import 'package:app_eoffice/utils/Base.dart';
import 'package:app_eoffice/widget/Base_widget.dart';
import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

Future<NguoiDungThucHienCongViecItem> lstobj;
Future<NguoiDungThucHienCongViecItem> nguoidungtheodoi;
Future<NguoiDungThucHienCongViecItem> nguoidungthuchien;
CongViec_Api objapi = new CongViec_Api();
List<String> lstnguoidungthuchien = <String>[];

List<int> selectedItemsndthuchien = [];
List<int> selectedItemsndtd = [];
List<String> lstnguoidungtheodoi = <String>[];
bool isloading = false;
bool isloadingtd = false;

// ignore: camel_case_types
class MySelect_NguoiDung extends StatefulWidget {
  Future<WorkTaskItem> objword;
  final id;
  MySelect_NguoiDung(this.objword, this.id);
  @override
  _MySelect_NguoiDung createState() => _MySelect_NguoiDung();
}

Future<List<NguoiDungItem>> lstnd;

class _MySelect_NguoiDung extends State<MySelect_NguoiDung> {
  @override
  // ignore: must_call_super
  void initState() {
    isloading = false;
    isloadingtd = false;
    selectedItemsndthuchien = [];
    selectedItemsndtd = [];
    lstnguoidungthuchien = [];
    lstnguoidungtheodoi = [];
    nguoidungthuchien = null;
    nguoidungtheodoi = null;
    loadnd();
  }

  Future<void> loadnd() async {
    lstnd = getnguoidung();
    nguoidungthuchien = getnguoidungth(lstnd);
    nguoidungtheodoi = getnguoitheodoi(lstnd, selectedItemsndthuchien);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          rowlabel('Người dùng thực hiện'),
          combonguoithuchien(),
          rowlabel('Người dùng theo dõi'),
          combonguoitheodoi(),
        ],
      ),
    );
  }

  Future<List<NguoiDungItem>> getnguoidung() async {
    var lstnguoidung = await objapi.getnguoidung();
    return lstnguoidung;
  }

  Future<NguoiDungThucHienCongViecItem> getnguoidungth(
      Future<List<NguoiDungItem>> lst) async {
    NguoiDungThucHienCongViecItem objnd = new NguoiDungThucHienCongViecItem();
    objnd.obj = new WorkTaskItem();
    objnd.lstnguoidung = await lst;
    if (widget.id > 0) {
      var objcv = await widget.objword;
      if (objcv != null &&
          objcv.ltsUserPerform != null &&
          objcv.ltsUserPerform.length > 0) {
        objnd.obj.ltsUserPerform = objcv.ltsUserPerform.toList();
        // lstnguoidungthuchien = objcv.ltsUserPerform.map((e) => e.id).toList();
      }
    }
    return objnd;
  }

  Future<NguoiDungThucHienCongViecItem> getnguoitheodoi(
      Future<List<NguoiDungItem>> lst, List<int> lstid) async {
    NguoiDungThucHienCongViecItem objnd = new NguoiDungThucHienCongViecItem();
    objnd.obj = new WorkTaskItem();
    objnd.lstnguoidung = await lst;
    if (lstid.length > 0)
      objnd.lstnguoidung =
          objnd.lstnguoidung.where((p) => !lstid.contains(p.id)).toList();
    if (widget.id > 0) {
      var objcv = await widget.objword;
      if (objcv != null && objcv.ltsUserPerform.length > 0) {
        var lstuser = new List<String>();
        lstuser.addAll(objcv.ltsUserPerform
            .map((e) => e.id.toString() + "|" + e.donviid.toString()));
        objnd.lstnguoidung = objnd.lstnguoidung
            .where((p) => !lstuser.contains(p.strNguoiDungDonVi))
            .toList();
      }
      if (objcv != null &&
          objcv.ltsUserFollow != null &&
          objcv.ltsUserFollow.length > 0) {
        objnd.obj.ltsUserFollow = objcv.ltsUserFollow.toList();
        lstnguoidungtheodoi = objcv.ltsUserFollow
            .map((e) => e.id.toString() + "|" + e.donviid.toString())
            .toList();
      }
    }
    return objnd;
  }

  Future<NguoiDungThucHienCongViecItem> getnguoithuchienchange(
      List<NguoiDungItem> lst,
      List<int> lstid,
      List<String> lstnguoidungdonvi) async {
    NguoiDungThucHienCongViecItem objnd = new NguoiDungThucHienCongViecItem();
    objnd.obj = new WorkTaskItem();
    objnd.lstnguoidung = lst;
    if (lstnguoidungdonvi.length > 0)
      objnd.lstnguoidung = objnd.lstnguoidung
          .where((p) => !lstnguoidungdonvi.contains(p.strNguoiDungDonVi))
          .toList();
    return objnd;
  }

  Widget combonguoithuchien() => Center(
          child: FutureBuilder(
        future: nguoidungthuchien,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Đã có lỗi xảy ra'),
            );
          }
          if (snapshot.hasData) {
            NguoiDungThucHienCongViecItem list = snapshot.data;
            List<String> lstitemselect = (isloading != true &&
                    list.obj != null &&
                    list.obj.ltsUserPerform != null &&
                    list.obj.ltsUserPerform.length > 0)
                ? list.obj.ltsUserPerform
                    .map((e) => (e.id.toString() + "|" + e.donviid.toString()))
                    .toList()
                : <String>[];
            if (list.lstnguoidung.length > 0) {
              List<DropdownMenuItem> lst = [];
              for (var i = 0; i < list.lstnguoidung.length; i++) {
                if (lstitemselect
                    .contains(list.lstnguoidung[i].strNguoiDungDonVi)) {
                  selectedItemsndthuchien.add(i);
                  lstnguoidungthuchien
                      .add(list.lstnguoidung[i].strNguoiDungDonVi);
                }
                lst.add(DropdownMenuItem(
                  child: Text(list.lstnguoidung[i].tenhienthi +
                      " - " +
                      list.lstnguoidung[i].tendonvi),
                  value: list.lstnguoidung[i].strNguoiDungDonVi,
                ));
              }
              return SearchableDropdown.multiple(
                items: lst,
                selectedItems: selectedItemsndthuchien.toSet().toList(),
                hint: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Chọn người thực hiện"),
                ),
                searchHint: "Chọn người thực hiện",
                onChanged: (value) {
                  lstnguoidungthuchien = <String>[];
                  setState(() {
                    isloading = true;
                    selectedItemsndthuchien = value;
                    selectedItemsndthuchien.forEach((element) {
                      lstnguoidungthuchien.add(lst[element].value);
                    });
                    lstnguoidungtheodoi = [];
                    selectedItemsndtd = [];
                    nguoidungtheodoi = getnguoithuchienchange(list.lstnguoidung,
                        new List<int>(), lstnguoidungthuchien);
                  });
                },
                doneButton: 'Hoàn thành',
                closeButton: (selectedItems) {
                  return ("Đồng ý");
                },
                isExpanded: true,
              );
            } else
              return notrecord();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ));
  Widget combonguoitheodoi() => Center(
          child: FutureBuilder(
        future: nguoidungtheodoi,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Đã có lỗi xảy ra'),
            );
          }
          if (snapshot.hasData) {
            NguoiDungThucHienCongViecItem list = snapshot.data;
            if (lstnguoidungthuchien.length > 0) {
              list.lstnguoidung = list.lstnguoidung
                  .where((p) =>
                      !lstnguoidungthuchien.contains(p.strNguoiDungDonVi))
                  .toList();
            }
            List<String> lstitemselect = (isloading != true &&
                    isloadingtd != true &&
                    list.obj != null &&
                    list.obj.ltsUserFollow != null &&
                    list.obj.ltsUserFollow.length > 0)
                ? list.obj.ltsUserFollow
                    .map((e) => (e.id.toString() + "|" + e.donviid.toString()))
                    .toList()
                : <String>[];
            if (list.lstnguoidung.length > 0) {
              List<DropdownMenuItem> lst = [];
              for (var i = 0; i < list.lstnguoidung.length; i++) {
                if (lstitemselect
                    .contains(list.lstnguoidung[i].strNguoiDungDonVi)) {
                  selectedItemsndtd.add(i);
                  lstnguoidungtheodoi
                      .add(list.lstnguoidung[i].strNguoiDungDonVi);
                }
                lst.add(DropdownMenuItem(
                  child: Text(list.lstnguoidung[i].tenhienthi +
                      " - " +
                      list.lstnguoidung[i].tendonvi),
                  value: list.lstnguoidung[i].strNguoiDungDonVi,
                ));
              }
              return SearchableDropdown.multiple(
                items: lst,
                selectedItems: selectedItemsndtd.toSet().toList(),
                hint: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Chọn người theo doi"),
                ),
                searchHint: "Chọn người theo dõi",
                onChanged: (value) {
                  lstnguoidungtheodoi = <String>[];
                  setState(() {
                    isloadingtd = true;
                    selectedItemsndtd = value;
                    selectedItemsndtd.forEach((element) {
                      lstnguoidungtheodoi.add(lst[element].value);
                    });
                  });
                },
                doneButton: 'Hoàn thành',
                closeButton: (selectedItems) {
                  return ("Đồng ý");
                },
                isExpanded: true,
              );
            } else
              return notrecord();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ));
}
