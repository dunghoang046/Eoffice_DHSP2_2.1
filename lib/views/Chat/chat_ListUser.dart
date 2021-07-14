import 'package:app_eoffice/block/base/event.dart';
import 'package:app_eoffice/block/base/state.dart';
import 'package:app_eoffice/block/chatGroup_block.dart';
import 'package:app_eoffice/components/components.dart';
import 'package:app_eoffice/models/Nguoidungitem.dart';
import 'package:app_eoffice/services/chat_api.dart';
import 'package:app_eoffice/utils/Base.dart';
import 'package:app_eoffice/utils/ColorUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:simple_router/simple_router.dart';
import 'package:toast/toast.dart';

// ignore: camel_case_types
class Mychat_Listuserpage extends StatefulWidget {
  final String roomid;
  Mychat_Listuserpage({this.roomid});
  @override
  _Mychat_Listuserpage createState() => _Mychat_Listuserpage();
}

List<NguoiDungItem> lstnguoidung1 = new List<NguoiDungItem>();
List<NguoiDungItem> lstnguoidung = new List<NguoiDungItem>();
bool isloadding = false;
List<int> lstNguoidungIDselect = new List<int>();
Chat_Api _chat_api = new Chat_Api();
var dataquery = {"RoomID": '0', "Keyword": '', "Loai": '3', "LoaiListID": '0'};

String keyword = '';

// ignore: camel_case_types
class _Mychat_Listuserpage extends State<Mychat_Listuserpage> {
  Widget cusSearchBar = Text('Chọn người dùng',
      style: TextStyle(
        color: Colors.white,
      ));
  Icon cusIcon = Icon(Icons.search, color: Colors.white);
  void initState() {
    BlocProvider.of<BlocChatGroupAction>(context).add(DetaildChatGroupEvent());
    super.initState();
    lstNguoidungIDselect = new List<int>();
    isloadding = false;
    keyword = '';
    List<NguoiDungItem> lstnguoidung1 = new List<NguoiDungItem>();
    List<NguoiDungItem> lstnguoidung = new List<NguoiDungItem>();
    loadnguoidung();
  }

  Future<void> loadnguoidung() async {
    dataquery = {
      "RoomID": widget.roomid,
      "Keyword": '' + keyword + '',
      "Loai": '3',
      "LoaiListID": '0'
    };
    lstnguoidung1 = await _chat_api.getAllNguoiDung(dataquery);
    if (mounted == true)
      setState(() {
        lstnguoidung = lstnguoidung1;
        var lstidnguoidung = lstnguoidung
            .where((element) => element.islargest == true)
            .map((e) => e.id);
        if (lstidnguoidung.length > 0)
          lstNguoidungIDselect.addAll(lstidnguoidung);
      });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<BlocChatGroupAction, ActionState>(
        buildWhen: (previousState, state) {
      if (state is DoneState) {
        Toast.show(basemessage, context,
            duration: 2, gravity: Toast.TOP, backgroundColor: Colors.green);
        BlocProvider.of<BlocChatGroupAction>(context)
            .add(DetaildChatGroupEvent());
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

                              loadnguoidung();
                            });
                          },
                          autofocus: true,
                        );
                      } else {
                        keyword = '';
                        loadnguoidung();
                        cusIcon = Icon(Icons.search, color: Colors.white);
                        cusSearchBar = Text('Chọn người dùng',
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
            itemCount: lstnguoidung.length,
            // ignore: missing_return
            itemBuilder: (BuildContext context, int index) {
              return Container(
                child: ListTile(
                  dense: true,
                  title: Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: lstnguoidung[index].islargest,
                        onChanged: (value) {
                          setState(() {
                            lstnguoidung[index].islargest = value;
                            if (value == true) {
                              lstNguoidungIDselect.add(lstnguoidung[index].id);
                            } else {
                              lstNguoidungIDselect = lstNguoidungIDselect
                                  .where((element) =>
                                      element != lstnguoidung[index].id)
                                  .toList();
                            }
                          });
                        },
                      ),
                      Text(
                        lstnguoidung1[index].tenhienthi,
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
              );
            }),
      ));
    });
  }

  Widget _onLoginClick() {
    return BlocBuilder<BlocChatGroupAction, ActionState>(
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
          icons: Icons.save,
          label: 'Cập nhật',
          mOnPressed: () => {_clickykien()},
        );
      } else {
        return ButtonAction(
          backgroundColor: Colors.blue,
          labelColor: Colors.white,
          icons: Icons.save,
          label: 'Cập nhật',
          mOnPressed: () => _clickykien(),
        );
        // }
      }
    });
  }

  _clickykien() async {
    if (hubConnection.state == HubConnectionState.Connected) {
      try {
        var data = {
          "strroomID": widget.roomid.toString(),
          "strimplementUserID": nguoidungsessionView.id.toString(),
          "struserIDs": lstNguoidungIDselect.join(","),
        };

        AddUserChatGroupEvent event = new AddUserChatGroupEvent();
        event.data = data;
        var s = event.data['strroomID'];
        BlocProvider.of<BlocChatGroupAction>(context).add(event);
      } catch (ex) {}
    }
  }

  loop() {
    List<int> lst = new List();
    for (var i = 0; i < 10000; i++) {
      lst.add(i);
    }
    setState(() {
      isloadding = false;
    });
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }
}
