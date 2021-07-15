import 'package:app_eoffice/block/DatXeBloc.dart';
import 'package:app_eoffice/block/base/event.dart';
import 'package:app_eoffice/block/base/state.dart';
import 'package:app_eoffice/block/datphongblock.dart';
import 'package:app_eoffice/models/ThongTinDatPhongItem.dart';
import 'package:app_eoffice/services/Base_service.dart';
import 'package:app_eoffice/services/DatPhong_Api.dart';
import 'package:app_eoffice/utils/Base.dart';
import 'package:app_eoffice/utils/ColorUtils.dart';
import 'package:app_eoffice/utils/quyenhan.dart';
import 'package:app_eoffice/views/DatPhong/pFormApprovedDatPhong.dart';
import 'package:app_eoffice/views/DatXe/DatXe_GuiNhan.dart';
import 'package:app_eoffice/views/DatXe/Reject.dart';
import 'package:app_eoffice/views/DatXe/pFormApproved.dart';
import 'package:app_eoffice/widget/DatPhong/DatPhongViewPanel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:simple_router/simple_router.dart';
import 'package:toast/toast.dart';

class MyDatPhongChiTiet extends StatefulWidget {
  final int id;
  MyDatPhongChiTiet({this.id});
  _MyDatPhongChiTiet createState() => _MyDatPhongChiTiet();
}

Future<ThongTinDatPhongItem> obj =
    new ThongTinDatPhongItem() as Future<ThongTinDatPhongItem>;
ThongTinDatPhongItem objvb = new ThongTinDatPhongItem();
DatPhong_Api objapi = new DatPhong_Api();
bool issend = false;
bool isDuyet = false;
bool isTuChoi = false;
bool isvanbandi = false;
ThongTinDatPhongItem objcv;
int phonghopid = 0;

class _MyDatPhongChiTiet extends State<MyDatPhongChiTiet> {
  // ignore: must_call_super
  @override
  void initState() {
    issend = false;
    isTuChoi = false;
    isDuyet = false;
    loaddata();
  }

  @override
  void dispose() {
    print('Đóng chi tiết đắt phòng');
    super.dispose();
  }

  void loaddata() async {
    if (widget.id != null && widget.id > 0) {
      var dataquery = {"ID": '' + widget.id.toString() + ''};
      obj = objapi.getbyId(dataquery);
      var objdx = await obj;
      setState(() {
        if (objdx.nguoitaoid == nguoidungsession.id &&
            (objdx.trangthaiid == 4 || objdx.trangthaiid == 2)) {
          issend = true;
        }
        if (objdx.trangthaiid != 3 &&
            checkquyen(
                nguoidungsessionView.quyenhan, new QuyenHan().Pheduyetdatphong))
          isDuyet = true;
        if (checkquyen(
            nguoidungsessionView.quyenhan, new QuyenHan().Duyetthongtindatxe))
          isTuChoi = true;
        phonghopid = objdx.phonghopid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Thông tin đặt phòng',
          style: TextStyle(color: Colors.white),
        ),
        leading: new IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              BlocProvider.of<BlocDatPhongAction>(context).add(ViewEvent());
              SimpleRouter.back();
            }),
        backgroundColor: colorbartop,
      ),
      body: BlocBuilder<BlocDatPhongAction, ActionState>(
          buildWhen: (previousState, state) {
        if (state is DoneState) {
          Toast.show(basemessage, context,
              duration: 2, gravity: Toast.TOP, backgroundColor: Colors.green);
          loaddata();
        }
        if (state is ErrorState) {
          Toast.show(basemessage, context,
              duration: 2, gravity: Toast.TOP, backgroundColor: Colors.red);
        }
        return;
      }, builder: (context, state) {
        return SingleChildScrollView(
          child: contentbody(),
        );
      }),
      floatingActionButton: buildSpeedDial(),
    ));
  }

  Widget contentbody() => Center(
          child: FutureBuilder(
        future: obj,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Đã có lỗi xảy ra'),
            );
          }
          if (snapshot.hasData) {
            ThongTinDatPhongItem list = snapshot.data;
            return DatPhongViewPanel(obj: list);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ));
  SpeedDial buildSpeedDial() {
    return SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        onOpen: () => print('Mở'),
        onClose: () => print('Đóng'),
        visible: true,
        curve: Curves.bounceIn,
        children: [
          if (issend == true)
            SpeedDialChild(
              child: Icon(Icons.send, color: Colors.white),
              backgroundColor: Colors.blue,
              onTap: () {
                var dataquery = {"DatPhongID": '' + widget.id.toString() + ''};
                SendEvent addEvent = new SendEvent();
                addEvent.data = dataquery;
                BlocProvider.of<BlocDatPhongAction>(context).add(addEvent);
              },
              label: 'Gửi đặt phòng',
              labelStyle:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              labelBackgroundColor: Colors.blue,
            ),
          if (isDuyet == true)
            SpeedDialChild(
              child: Icon(Icons.approval, color: Colors.white),
              backgroundColor: Colors.blue,
              onTap: () {
                SimpleRouter.forward(MyFormApprovedDatPhongpage(
                  id: widget.id.toString(),
                  phonghopid: phonghopid,
                ));
              },
              label: 'Duyệt',
              labelStyle:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              labelBackgroundColor: Colors.blue,
            ),
          if (isTuChoi == true)
            SpeedDialChild(
              child: Icon(Icons.cancel, color: Colors.white),
              backgroundColor: Colors.red,
              onTap: () {
                SimpleRouter.forward(MyFormReject(
                  id: widget.id,
                ));
              },
              label: 'Từ chối',
              labelStyle:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              labelBackgroundColor: Colors.red,
            ),
        ]);
  }
}
