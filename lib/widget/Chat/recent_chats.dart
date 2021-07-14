import 'package:app_eoffice/block/base/state.dart';
import 'package:app_eoffice/block/chat_block.dart';
import 'package:app_eoffice/models/Chat/ChatRoomItem.dart';
import 'package:app_eoffice/models/Chat/ChatUserDetail.dart';
import 'package:app_eoffice/models/Chat/message_model.dart';
import 'package:app_eoffice/models/Nguoidungitem.dart';
import 'package:app_eoffice/services/Base_service.dart';
import 'package:app_eoffice/utils/Base.dart';
import 'package:app_eoffice/views/Chat/chatGroupDetail.dart';
import 'package:app_eoffice/views/Chat/chat_detaild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_client/hub_connection.dart';

class MyRecentChats extends StatefulWidget {
  final int tabindex;
  MyRecentChats({this.tabindex});
  @override
  _RecentChats createState() => _RecentChats();
}

List<ChatUserDetail> lstuser = new List<ChatUserDetail>();

List<ChatRoomItem> lstgroupchat = new List<ChatRoomItem>();

class _RecentChats extends State<MyRecentChats> {
  @override
  void initState() {
    // initSignalR();
    connect();
    hubConnection.on("OnConnectClient", _handleOnclient);
    hubConnection.on("SendPrivateMessage", _sendPrivateMessage);
    hubConnection.on("onRenameRoomClient", _onRenameRoomClient);
    hubConnection.on("addUserToRoomClient", _addUserToRoomClient);
    lstgroupchat = new List<ChatRoomItem>();
    settingpushnotification();
    super.initState();
  }

  @override
  void dispose() {
    print(hubConnection.state.toString());
    super.dispose();
  }

  _addUserToRoomClient(List<dynamic> args) {
    var objmsg = new MessageChat();
    objmsg.content = args[4]['messageContent'];
    objmsg.isLiked = false;
    objmsg.id = 0;
    // objmsg.username = args[1]["nguoiDungItem"]["tenTruyCap"];
    objmsg.displayname = args[2];
    objmsg.time = args[4]['sendDate'] != null
        ? args[4]['sendDate']
        : DateTime.now().toString();
    objmsg.fromid = args[1];
    objmsg.roomid = args[0]["id"];

    if (ispagechatgroup != true) {
      showNotificationWithoutSound(objmsg.displayname, objmsg.content);
    }
  }

  void connect() async {
    if (hubConnection.state == HubConnectionState.Disconnected) {
      try {
        await hubConnection.start();
      } catch (e) {
        print(e.toString());
      }
    }
    if (hubConnection.state == HubConnectionState.Connected) {
      await hubConnection.invoke('Connect', args: [
        nguoidungsession.id.toString(),
      ]);
      print('Đã connect');
    }
    print('Đã connnect');
  }

  _sendPrivateMessage(List<dynamic> args) {
    if (ispagechat != true) {
      var objmsg = new MessageChat();
      objmsg.content = args[2];
      objmsg.isLiked = false;
      objmsg.id = 0;
      objmsg.time = args[3] != null ? args[3] : DateTime.now().toString();
      objmsg.fromid = args[0]["id"];
      objmsg.toid = args[1]["id"];
      objmsg.displayname = args[0]["tenHienThi"];
      showNotificationWithoutSound(objmsg.displayname, objmsg.content);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: BlocBuilder<BlocChatAction, ActionState>(
      buildWhen: (previousState, state) {
        if (state is ViewListChatState) {
          lstuser = [];
          connect();
        }
        return;
      },
      builder: (context, state) {
        return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: widget.tabindex == 0
                  ? ListView.builder(
                      itemCount: lstuser.length,
                      itemBuilder: (BuildContext context, int index) {
                        final ChatUserDetail chat = lstuser[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatDetailpage(
                                user: chat,
                                fromid: nguoidungsession.id.toString(),
                                toid: chat.nguoiDungItem.id.toString(),
                              ),
                            ),
                          ),
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 5.0, bottom: 5.0, right: 20.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              color: chat.connected
                                  ? Color(0xFFFFEFEE)
                                  : Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 15.0,
                                      backgroundImage: AssetImage(
                                          "assets/images/avatar.jpg"),
                                    ),
                                    SizedBox(width: 10.0),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          chat.nguoiDungItem.tenhienthi,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5.0),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.45,
                                          // child: Text(
                                          //   chat.text,
                                          //   style: TextStyle(
                                          //     color: Colors.blueGrey,
                                          //     fontSize: 15.0,
                                          //     fontWeight: FontWeight.w600,
                                          //   ),
                                          //   overflow: TextOverflow.ellipsis,
                                          // ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    // Text(
                                    //   chat.time,
                                    //   style: TextStyle(
                                    //     color: Colors.grey,
                                    //     fontSize: 15.0,
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    SizedBox(height: 5.0),
                                    // chat.unread
                                    //     ? Container(
                                    //         width: 40.0,
                                    //         height: 20.0,
                                    //         decoration: BoxDecoration(
                                    //           color: Theme.of(context).primaryColor,
                                    //           borderRadius: BorderRadius.circular(30.0),
                                    //         ),
                                    //         alignment: Alignment.center,
                                    //         child: Text(
                                    //           'NEW',
                                    //           style: TextStyle(
                                    //             color: Colors.white,
                                    //             fontSize: 12.0,
                                    //             fontWeight: FontWeight.bold,
                                    //           ),
                                    //         ),
                                    //       )
                                    //     : Text(''),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 10),
                      child: ListView.builder(
                        itemCount: lstgroupchat.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ChatRoomItem chat = lstgroupchat[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MyChatGroupDetailpage(
                                  roomItem: lstgroupchat[index],
                                  roomid: lstgroupchat[index].id.toString(),
                                  userid: nguoidungsession.id.toString(),
                                ),
                              ),
                            ),
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: 5.0, bottom: 0.0, right: 20.0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 3.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(child: Text(chat.roomName))
                                      ],
                                    )
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
            ));
      },
    ));
  }

  _onRenameRoomClient(List<dynamic> args) {
    var objmsg = new MessageChat();
    objmsg.content = args[1]['messageContent'];
    objmsg.isLiked = false;
    objmsg.id = 0;
    // objmsg.username = args[1]["nguoiDungItem"]["tenTruyCap"];
    objmsg.displayname = args[2];
    objmsg.time = args[1]['sendDate'] != null
        ? args[1]['sendDate']
        : DateTime.now().toString();
    objmsg.fromid = args[1]["fromUserID"];
    objmsg.roomid = args[0]["id"];
    if (ispagechatgroup != true)
      showNotificationWithoutSound(objmsg.displayname, objmsg.content);
  }

  _handleOnclient(List<dynamic> args) {
    if (lstuser.length <= 0) {
      var lst = args[0];
      for (var i = 0; i < lst.length; i++) {
        ChatUserDetail obj = new ChatUserDetail();
        obj.connectionID = lst[i]["connectionID"];
        obj.userID = lst[i]["userID"];
        obj.connectTime = lst[i]["connectTime"];
        obj.connected = lst[i]["connected"];
        if (lst[i]["nguoiDungItem"] != null) {
          obj.nguoiDungItem = new NguoiDungItem();
          if (lst[i]["nguoiDungItem"]["tenHienThi"] != null)
            obj.nguoiDungItem.tenhienthi =
                lst[i]["nguoiDungItem"]["tenHienThi"];
          if (lst[i]["nguoiDungItem"]["id"] != null)
            obj.nguoiDungItem.id = lst[i]["nguoiDungItem"]["id"];
        }
        if (mounted == true) {
          setState(() {
            lstuser.add(obj);
          });
        }
      }
    }
    if (lstgroupchat.length <= 0) {
      var lstgr = args[1];
      if (args[1] != null) {
        for (var i = 0; i < lstgr.length; i++) {
          ChatRoomItem obj = new ChatRoomItem();
          obj.id = lstgr[i]["id"];
          obj.roomKey = lstgr[i]["roomKey"];
          obj.roomName = lstgr[i]["roomName"];
          obj.creatorID = lstgr[i]["creatorID"];
          obj.type = lstgr[i]["type"];
          if (mounted == true) {
            setState(() {
              lstgroupchat.add(obj);
            });
          }
        }
      }
    }
  }
}
