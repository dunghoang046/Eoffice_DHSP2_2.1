import 'package:app_eoffice/block/base/event.dart';
import 'package:app_eoffice/block/chatGroup_block.dart';
import 'package:app_eoffice/components/components.dart';
import 'package:app_eoffice/models/Chat/ChatRoomItem.dart';
import 'package:app_eoffice/views/Chat/chatGroupDetail_all.dart';
import 'package:app_eoffice/views/Chat/chat_ListUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:app_eoffice/utils/Base.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:app_eoffice/utils/ColorUtils.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:simple_router/simple_router.dart';
import 'package:toast/toast.dart';

int currentPage = 0;
int currentPageNow = 1;
bool isrenamegroup = false;

class ChatGroupDetailpage extends StatelessWidget {
  final String roomid;
  final String userid;
  final ChatRoomItem roomItem;
  ChatGroupDetailpage({@required this.roomid, this.userid, this.roomItem});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyChatGroupDetailpage(
        roomid: roomid, userid: userid, roomItem: roomItem);
  }
}

TabController _tabController;
String keyword = '';
int indexselect = 0;
bool inter = true;
String tennguoidung = '';
TextEditingController textEditingController = new TextEditingController();

class MyChatGroupDetailpage extends StatefulWidget {
  final String roomid;
  final String userid;
  final ChatRoomItem roomItem;
  MyChatGroupDetailpage({@required this.roomid, this.userid, this.roomItem});
  GlobalKey<ScaffoldState> globalKey;
  @override
  _MyChatGroupDetailpage createState() => _MyChatGroupDetailpage();
}

class _MyChatGroupDetailpage extends State<MyChatGroupDetailpage>
    with SingleTickerProviderStateMixin {
  List<Tab> lsttab = <Tab>[];
  List<StatefulWidget> lsttabview = <StatefulWidget>[];
  @override
  void initState() {
    super.initState();
    keyword = '';
    isrenamegroup = false;
    setState(() {
      tennguoidung = widget.roomItem.roomName;
      textEditingController.text = widget.roomItem.roomName;
      cusSearchBar = Text(tennguoidung,
          style: TextStyle(
            color: Colors.white,
          ));
    });
  }

  Icon cusIcon = Icon(Icons.search, color: Colors.white);
  Widget cusSearchBar = Text(tennguoidung,
      style: TextStyle(
        color: Colors.white,
      ));
  @override
  void dispose() {
    super.dispose();
  }

  checkinter() async {
    inter = await checkinternet();
    if (!inter) {
      on_alter(context, 'Vui lòng check lại internet');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      // drawer: lstmenu(context),
      appBar: PreferredSize(
        child: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: colorbartop,
            leading: new IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  SimpleRouter.back();
                }),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.group_add),
                  onPressed: () {
                    SimpleRouter.forward(
                        Mychat_Listuserpage(roomid: widget.roomid));
                  }),
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
                          setState(() {
                            keyword = str;
                          });
                        },
                        autofocus: true,
                      );
                    } else {
                      keyword = '';
                      currentPage = 1;
                      cusIcon = Icon(Icons.search, color: Colors.white);
                      cusSearchBar = Text(tennguoidung,
                          style: TextStyle(
                            color: Colors.white,
                          ));
                    }
                  });
                },
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                  PopupMenuItem(
                      child: ListTile(
                    dense: true,
                    onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Đổi tên nhóm'),
                        content: TextField(
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: 5,
                          controller: textEditingController,
                          onChanged: (value) {},
                          decoration: InputDecoration.collapsed(
                            hintText: 'Nhập nội dung...',
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Huỷ'),
                            child: const Text('Huỷ'),
                          ),
                          _onClick()
                        ],
                      ),
                    ),
                    contentPadding: EdgeInsets.only(
                        left: 0.0, right: 0.0, bottom: 0.0, top: 0.0),
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.edit,
                          color: Colors.black,
                          size: 14,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Đổi tên",
                          style: TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  )),
                  PopupMenuItem(
                      child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.only(
                        left: 0.0, right: 0.0, bottom: 0.0, top: 0.0),
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.person_add,
                          color: Colors.black,
                          size: 14,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Thêm người dùng",
                          style: TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  )),
                  PopupMenuItem(
                      child: ListTile(
                    dense: true,
                    // leading: Icon(Icons.edit, size: 20),
                    contentPadding: EdgeInsets.only(
                        left: 0.0, right: 0.0, bottom: 0.0, top: 0.0),
                    visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    title: Row(
                      children: <Widget>[
                        Icon(
                          Icons.person_add_disabled_outlined,
                          color: Colors.black,
                          size: 14,
                        ),
                        SizedBox(
                          width:
                              5, // here put the desired space between the icon and the text
                        ),
                        Text(
                          "Rời nhóm",
                          style: TextStyle(fontSize: 13),
                        ) // here we could use a column widget if we want to add a subtitle
                      ],
                    ),
                  )),
                ],
                onSelected: (value) {
                  setState(() {});
                },
                color: Colors.white,
              )
            ],
            title: cusSearchBar),
        preferredSize: Size.fromHeight(50),
      ),
      body: Center(
        child: Provider<ChatGroupblock>(
          child: ChatGroupAllpage(
            fromid: widget.roomid,
            toid: widget.userid,
            chatRoomItem: widget.roomItem,
            requestblock: new ChatGroupblock(widget.roomid, widget.userid),
          ),
          create: (context) => new ChatGroupblock(widget.roomid, widget.userid),
          dispose: (context, bloc) => bloc.dispose(),
        ),
      ),
    ));
  }

  Widget _onClick() {
    // if (isrenamegroup == true) {
    //   return TextButtonAction(
    //     label: 'Đang xử lý ...',
    //     mOnPressed: () => {},
    //   );
    // } else if (isrenamegroup == false) {
    //   return TextButtonAction(
    //     label: 'Cập nhật',
    //     mOnPressed: () => {_onclick()},
    //   );
    // } else {
    return TextButtonAction(
      label: 'Cập nhật',
      mOnPressed: () => _onclick(),
    );
    // }
    // }
  }

  Future<void> _onclick() async {
    var data = {
      "strroomID": widget.roomItem.id,
      "roomName": textEditingController.text,
      "strimplementUserID": nguoidungsessionView.id,
      "implementName": nguoidungsessionView.tenhienthi,
    };
    // RenameChatGroupEvent yKienEvent = new RenameChatGroupEvent();
    // yKienEvent.data = data;
    // BlocProvider.of<BlocChatGroupAction>(context).add(yKienEvent);
    if (hubConnection.state == HubConnectionState.Connected) {
      try {
        await hubConnection.invoke('RenameRoom', args: [
          widget.roomItem.id.toString(),
          textEditingController.text,
          nguoidungsessionView.id,
          nguoidungsessionView.tenhienthi
        ]);
        setState(() {
          isrenamegroup = true;
          tennguoidung = textEditingController.text;
          cusSearchBar = Text(tennguoidung,
              style: TextStyle(
                color: Colors.white,
              ));
        });
        Navigator.pop(context, 'Huỷ');
      } catch (ex) {
        isrenamegroup = false;
        Toast.show('Có lỗi xảy ra: ' + ex.toString(), context,
            duration: 4, gravity: Toast.TOP, backgroundColor: Colors.green);
      }
    }
  }
}
