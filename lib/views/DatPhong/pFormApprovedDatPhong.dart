import 'package:app_eoffice/block/base/event.dart';
import 'package:app_eoffice/block/base/state.dart';
import 'package:app_eoffice/block/chatGroup_block.dart';
import 'package:app_eoffice/block/datphongblock.dart';
import 'package:app_eoffice/services/DatPhong_Api.dart';
import 'package:app_eoffice/components/components.dart';
import 'package:app_eoffice/models/DanhMucPhongHopItem.dart';
import 'package:app_eoffice/utils/Base.dart';
import 'package:app_eoffice/utils/ColorUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_router/simple_router.dart';
import 'package:toast/toast.dart';

// ignore: camel_case_types
class MyFormApprovedDatPhongpage extends StatefulWidget {
  final String id;
  final int phonghopid;
  MyFormApprovedDatPhongpage({this.id, this.phonghopid});
  @override
  _MyFormApprovedDatPhongpage createState() => _MyFormApprovedDatPhongpage();
}

List<DanhMucPhongHopItem> lstphonghop = new List<DanhMucPhongHopItem>();
bool isloadding = false;
List<int> lstNguoidungIDselect = new List<int>();
DatPhong_Api _datPhong_Api = new DatPhong_Api();
var dataquery = {"RoomID": '0', "Keyword": '', "Loai": '3', "LoaiListID": '0'};

String keyword = '';
int idselect = 0;
enum SingingCharacter { lafayette, jefferson }

// ignore: camel_case_types
class _MyFormApprovedDatPhongpage extends State<MyFormApprovedDatPhongpage> {
  SingingCharacter _character = SingingCharacter.lafayette;
  Widget cusSearchBar = Text('Chọn phòng họp',
      style: TextStyle(
        color: Colors.white,
      ));
  Icon cusIcon = Icon(Icons.search, color: Colors.white);
  void initState() {
    // BlocProvider.of<BlocDatPhongAction>(context).add(DetaildChatGroupEvent());
    super.initState();
    lstNguoidungIDselect = new List<int>();
    isloadding = false;
    keyword = '';
    idselect = 0;
    lstphonghop = new List<DanhMucPhongHopItem>();
    loadphonghop();
  }

  Future<void> loadphonghop() async {
    dataquery = {
      "ID": widget.id,
      "Keyword": '' + keyword + '',
      "Loai": '3',
      "LoaiListID": '0'
    };
    lstphonghop = await _datPhong_Api.getdanhmucphong(dataquery);
    if (mounted == true)
      setState(() {
        lstphonghop = lstphonghop;
      });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<BlocDatPhongAction, ActionState>(
        buildWhen: (previousState, state) {
      if (state is DoneState) {
        Toast.show(basemessage, context,
            duration: 2, gravity: Toast.TOP, backgroundColor: Colors.green);
        // BlocProvider.of<BlocDatPhongAction>(context).add(ViewEven());
        SimpleRouter.back();
      }
      if (state is ErrorState) {
        Toast.show(basemessage, context,
            duration: 2, gravity: Toast.TOP, backgroundColor: Colors.red);
      }
      return;
    }, builder: (context, state) {
      return SafeArea(
          child: Scaffold(
        appBar: PreferredSize(
          child: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: colorbar,
              actions: <Widget>[
                IconButton(
                  icon: cusIcon,
                  onPressed: () {
                    setState(() {
                      if (this.cusIcon.icon == Icons.search) {
                        this.cusIcon = Icon(Icons.cancel, color: Colors.white);
                        this.cusSearchBar = TextField(
                          decoration:
                              new InputDecoration(labelText: "Nhập từ khóa"),
                          textInputAction: TextInputAction.go,
                          onSubmitted: (String str) {
                            setState(() async {
                              keyword = str;

                              loadphonghop();
                            });
                          },
                          autofocus: true,
                        );
                      } else {
                        keyword = '';
                        loadphonghop();
                        cusIcon = Icon(Icons.search, color: Colors.white);
                        cusSearchBar = Text('Chọn phòng họp',
                            style: TextStyle(
                              color: Colors.white,
                            ));
                      }
                    });
                  },
                ),
                _onLoginClick()
              ],
              title: cusSearchBar),
          preferredSize: Size.fromHeight(50),
        ),
        body: ListView.builder(
            itemCount: lstphonghop.length,
            // ignore: missing_return
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: ListTile(
                  dense: true,
                  leading: Radio<int>(
                    value: lstphonghop[index].id,
                    groupValue: idselect,
                    onChanged: (value) {
                      setState(() {
                        idselect = value;
                      });
                    },
                  ),
                  title: Row(
                    children: [
                      Text(
                        lstphonghop[index].ten +
                            (lstphonghop[index].diadiem != null
                                ? (" (" + lstphonghop[index].diadiem + ")")
                                : ''),
                        style: TextStyle(fontSize: 15),
                      ),
                      widgetselect(lstphonghop[index].id)
                    ],
                  ),
                ),
              );
            }),
      ));
    });
  }

  Widget widgetselect(phonghopid) {
    if (widget.phonghopid == phonghopid)
      return Container(
        margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
        child: Text(
          'x',
          style: TextStyle(fontSize: 15),
        ),
      );
    return Text(
      '',
      style: TextStyle(fontSize: 15),
    );
  }

  Widget _onLoginClick() {
    return BlocBuilder<BlocDatPhongAction, ActionState>(
        builder: (context, state) {
      if (state is LoadingState) {
        return ButtonAction(
          backgroundColor: Colors.blue,
          labelColor: Colors.white,
          label: 'Đang xử lý ...',
          mOnPressed: () => {},
        );
      } else if (state is ErrorState) {
        return ButtonAction(
          backgroundColor: Colors.blue,
          labelColor: Colors.white,
          icons: Icons.approval,
          label: 'Duyệt',
          mOnPressed: () => {_onclick()},
        );
      } else {
        return ButtonAction(
          backgroundColor: Colors.blue,
          labelColor: Colors.white,
          icons: Icons.approval,
          label: 'Duyệt',
          mOnPressed: () => _onclick(),
        );
        // }
      }
    });
  }

  _onclick() async {
    if (idselect > 0) {
      try {
        var data = {
          "DatPhongID": widget.id.toString(),
          "PhongHopID": idselect.toString(),
        };
        ApproverEvent event = new ApproverEvent();
        event.data = data;
        BlocProvider.of<BlocDatPhongAction>(context).add(event);
      } catch (ex) {}
    } else {
      Toast.show('Bạn chưa chọn phòng họp', context,
          duration: 2, gravity: Toast.TOP, backgroundColor: Colors.red);
    }
  }
}
