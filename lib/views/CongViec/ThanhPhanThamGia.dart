import 'package:app_eoffice/block/CongViecBloc.dart';
import 'package:app_eoffice/block/base/event.dart';
import 'package:app_eoffice/block/base/state.dart';
import 'package:app_eoffice/components/components.dart';
import 'package:app_eoffice/utils/ColorUtils.dart';
import 'package:app_eoffice/widget/CongViec/ThanhPhanThamGia/select_donvi.dart';
import 'package:app_eoffice/widget/CongViec/ThanhPhanThamGia/select_nguoidung.dart';
import 'package:app_eoffice/widget/CongViec/ThanhPhanThamGia/select_nhomnguoidung.dart';

import 'package:flutter/material.dart';
import 'package:app_eoffice/models/DonViItem.dart';
import 'package:app_eoffice/models/ModelForm/DanhMucCongViecItem.dart';
import 'package:app_eoffice/models/NguoiDungitem.dart';
import 'package:app_eoffice/models/NhomNguoiDungItem.dart';
import 'package:app_eoffice/services/CongViec_Api.dart';
import 'package:app_eoffice/utils/Base.dart';
import 'package:app_eoffice/views/DuThaoVanBan/VanBanDuThao_ChiTiet.dart';
import 'package:app_eoffice/widget/CongViec/ThemMoi/combo_DanhMuc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_router/simple_router.dart';
import 'package:toast/toast.dart';
import 'package:app_eoffice/models/WorkTaskItem.dart';
import 'package:date_format/date_format.dart';

class MyThanhPhanThamGia extends StatefulWidget {
  final int id;
  final List<int> lstselect;
  MyThanhPhanThamGia({@required this.id, this.lstselect});

  @override
  _MyThanhPhanThamGia createState() => new _MyThanhPhanThamGia();
}

Future<List<NhomNguoiDungItem>> objlanhdaotrinh;
Future<List<DonViItem>> lstdonvi;
Future<List<NguoiDungItem>> lstnguoidung;
CongViec_Api objapi = new CongViec_Api();
TextEditingController _noidung = new TextEditingController();
TextEditingController _mota = new TextEditingController();
TextEditingController _ngaybatdau = new TextEditingController();
TextEditingController _ngayketthuc = new TextEditingController();
TextEditingController _tags = new TextEditingController();
Future<WorkTaskItem> obj;
WorkTaskItem objcvadd = new WorkTaskItem();

class _MyThanhPhanThamGia extends State<MyThanhPhanThamGia> {
  // ignore: must_call_super
  void initState() {
    loaddata();
    if (widget.id <= 0) {
      _noidung.text = '';
      _mota.text = '';
      _ngaybatdau.text = '';
      _ngayketthuc.text = '';
      _tags.text = '';
    }
    BlocProvider.of<BlocCongViecAction>(context).add(ViewThanhPhanTGEvent());
  }

  final _formKeyadd = GlobalKey<FormState>();
  Future<DanhMucCongViecItem> getdanhmuc() async {
    var dataquery = {"ID": '' + widget.id.toString() + ''};
    DanhMucCongViecItem objnd = new DanhMucCongViecItem();
    objnd.lstdanhmuc = await objapi.getdanhmuc();
    if (widget.id > 0)
      objnd.obj = await objapi.getbyId(dataquery);
    else
      objnd.obj = new WorkTaskItem();
    return objnd;
  }

  void loaddata() async {
    var dataquery = {"ID": '' + widget.id.toString() + ''};
    if (widget.id != null && widget.id > 0) {
      obj = objapi.getbyId(dataquery);
      objcvadd = await objapi.getbyId(dataquery);
      _noidung.text = objcvadd.title;
      if (objcvadd.startDate != null)
        _ngaybatdau.text = formatDate(
            DateTime.parse(objcvadd.startDate), [dd, '/', mm, '/', yyyy]);
      if (objcvadd.endDate != null)
        _ngayketthuc.text = formatDate(
            DateTime.parse(objcvadd.endDate), [dd, '/', mm, '/', yyyy]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: BlocBuilder<BlocCongViecAction, ActionState>(
            buildWhen: (previousState, state) {
      if (state is ViewState) {
        // Toast.show(basemessage, context,
        //     duration: 2, gravity: Toast.TOP, backgroundColor: Colors.green);
        SimpleRouter.back();
      }
      if (state is ErrorState) {
        Toast.show(basemessage, context,
            duration: 2, gravity: Toast.TOP, backgroundColor: Colors.red);
      }
      return;
    }, builder: (context, state) {
      return SafeArea(
          child: Container(
              child: Scaffold(
                  backgroundColor: Colors.grey[350],
                  appBar: AppBar(
                    iconTheme: IconThemeData(color: Colors.white),
                    title: Text(
                      'C???p nh???t th??nh ph???n',
                      style: TextStyle(color: Colors.white),
                    ),
                    leading: new IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    backgroundColor: colorbartop,
                    actions: <Widget>[_onLoginClick1()],
                  ),
                  body: SingleChildScrollView(
                      child: Theme(
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300],
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(0.0, 8.0),
                            spreadRadius: 5,
                            blurRadius: 7,
                            // offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      // color: Colors.white,
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Form(
                          key: _formKeyadd,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Myselect_NhomNguoiDung(obj, widget.id),
                              Myselect_DonVi(
                                objword: obj,
                                id: widget.id,
                              ),
                              MySelect_NguoiDung(obj, widget.id),
                              Row(
                                children: [
                                  Container(
                                      margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                      child: MaterialButton(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 10, 5, 10),
                                          onPressed: () {
                                            _click_add();
                                          },
                                          color: Colors.blue,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.save,
                                                size: 17,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                'C???p nh???t',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: white),
                                              ),
                                            ],
                                          ))),
                                  Container(
                                      margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                                      child: MaterialButton(
                                          // padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyDuThaoVanBanChiTiet(
                                                          id: widget.id)),
                                            );
                                          },
                                          color: Colors.red,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.close,
                                                size: 17,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                'H???y',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(color: white),
                                              ),
                                            ],
                                          ))),
                                ],
                              )
                            ],
                          )),
                    ),
                    data: ThemeData(
                        buttonTheme:
                            ButtonThemeData(textTheme: ButtonTextTheme.accent),
                        accentColor: Colors.blue,
                        primaryColor: Colors.blue),
                  )))));
    }));
  }

  Widget _onLoginClick1() {
    // ignore: missing_return
    return BlocBuilder<BlocCongViecAction, ActionState>(
        builder: (context, state) {
      if (state is LoadingState) {
        return ButtonAction(
          backgroundColor: Colors.blue,
          labelColor: Colors.white,
          label: '??ang x??? l?? ...',
          mOnPressed: () => {},
        );
      } else if (state is ErrorState) {
        return ButtonAction(
          backgroundColor: Colors.blue,
          labelColor: Colors.white,
          icons: Icons.save,
          label: 'C???p nh???t',
          mOnPressed: () => {_click_add()},
        );
      } else {
        return ButtonAction(
          backgroundColor: Colors.blue,
          labelColor: Colors.white,
          icons: Icons.save,
          label: 'C???p nh???t',
          mOnPressed: () => _click_add(),
        );
        // }
      }
    });
  }

  // ignore: non_constant_identifier_names
  void _click_add() {
    if (_formKeyadd.currentState.validate()) {
      var data = {
        "ID": widget.id,
        "Title": _noidung.text,
        "StartDate": _ngaybatdau.text,
        "EndDate": _ngayketthuc.text,
        "UserPerform": lstnguoidungthuchien.toSet().toList(),
        "UserFollow": lstnguoidungtheodoi.toSet().toList(),
        "GroupPerform": lstdonvithuchien.toSet().toList(),
        "GroupFollow": lstdonvitheodoi.toSet().toList(),
        "UserGroupPerform": lstnhomnguoithuchien.toSet().toList(),
        "UserGroupFollow": lstnhomnguoitheodoi.toSet().toList(),
        "Description": _mota.text,
        "DanhMucGiaTriID":
            lstdanhmucgiatri.length > 0 ? lstdanhmucgiatri.join(',') : '',
      };
      AddThanhPhanTGEvent addEvent = new AddThanhPhanTGEvent();
      addEvent.data = data;
      BlocProvider.of<BlocCongViecAction>(context).add(addEvent);
    }
  }
}
