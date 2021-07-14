import 'package:app_eoffice/block/chatGroup_block.dart';
import 'package:app_eoffice/models/Chat/ChatRoomItem.dart';
import 'package:app_eoffice/models/Chat/message_model.dart';
import 'package:app_eoffice/services/Base_service.dart';
import 'package:app_eoffice/utils/Base.dart';
import 'package:app_eoffice/views/Chat/chatGroupDetail.dart';
import 'package:date_format/date_format.dart';

import 'package:flutter/material.dart';

import 'package:app_eoffice/widget/Base_widget.dart';
import 'package:signalr_client/hub_connection.dart';

class ChatGroupdetailpanel extends StatefulWidget {
  ChatGroupblock objBloc;
  ScrollController scrollController_rq;
  final ChatRoomItem roomItem;

  ChatGroupdetailpanel(
      {@required this.objBloc, this.scrollController_rq, this.roomItem});

  _ChatGroupdetailpanel createState() => _ChatGroupdetailpanel();
}

bool inter = true;
bool check = true;
int totals = 0;

List<MessageChat> lstmsg = new List<MessageChat>();
TextEditingController textEditingController = new TextEditingController();

class _ChatGroupdetailpanel extends State<ChatGroupdetailpanel> {
  @override
  void initState() {
    super.initState();
    ispagechatgroup = true;
    hubConnection.on("sendGroupMessageClient", _sendPrivateMessage);
    hubConnection.on("onRenameRoomClient", _onRenameRoomClient);
    hubConnection.on("addUserToRoomClient", _addUserToRoomClient);

    lstmsg = [];
  }

  void dispose() {
    print('đóng ds cv panl');
    widget.objBloc.dispose();
    widget.scrollController_rq.dispose();
    super.dispose();
    ispagechatgroup = false;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.objBloc.topStories,
      builder:
          // ignore: missing_return
          (BuildContext context, AsyncSnapshot<List<MessageChat>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()));
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.data.length > 0) {
              lstmsg = snapshot.data;
              // lstmsg.sort((a, b) => b.id.compareTo(a.id));
              return _buildView();
            } else {
              return notrecord();
            }
            break;
        }
      },
    );
    // return _buildView();
  }

  Widget _buildView() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
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
                child: ListView.builder(
                  reverse: true,
                  controller: widget.scrollController_rq,
                  itemCount: widget.objBloc.hasMoreStories()
                      ? lstmsg.length + 1
                      : lstmsg.length,
                  // itemCount: lstmsg.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == lstmsg.length) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final bool isMe =
                        lstmsg[index].fromid == nguoidungsession.id;
                    return _buildMessage(lstmsg[index], isMe);
                  },
                )),
          ),
        ),
        _buildMessageComposer(),
      ],
    );
  }

  _buildMessage(MessageChat message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Colors.blue[200] : Colors.grey[200],
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: RichText(
                  softWrap: true,
                  text: TextSpan(children: <TextSpan>[
                    if (isMe != true)
                      TextSpan(
                          text: message.displayname + ' ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    TextSpan(
                        text: message.time != null
                            ? formatDate(DateTime.parse(message.time),
                                [dd, '/', mm, '/', yyyy, ":", HH, ":", nn])
                            : '',
                        style: TextStyle(color: Colors.black))
                  ]),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            message.content,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        IconButton(
          icon: message.isLiked
              ? Icon(Icons.favorite)
              : Icon(Icons.favorite_border),
          iconSize: 30.0,
          color: message.isLiked
              ? Theme.of(context).primaryColor
              : Colors.blueGrey,
          onPressed: () {},
        )
      ],
    );
  }

  _sendPrivateMessage(List<dynamic> args) {
    var objmsg = new MessageChat();
    objmsg.content = args[3];
    objmsg.isLiked = false;
    objmsg.id = 0;
    objmsg.username = args[1]["nguoiDungItem"]["tenTruyCap"];
    objmsg.displayname = args[1]["nguoiDungItem"]["tenHienThi"];
    objmsg.time = args[2] != null ? args[2] : DateTime.now().toString();
    objmsg.fromid = args[1]["id"];
    objmsg.roomid = args[0]["id"];
    if ((ispagechatgroup == true && objmsg.roomid == widget.roomItem.id)) {
      if (mounted == true) {
        setState(() {
          lstmsg.insert(0, objmsg);
        });
      }
    } else {
      showNotificationWithoutSound(objmsg.displayname, objmsg.content);
    }
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

    if ((ispagechat == true && objmsg.roomid == widget.roomItem.id)) {
      if (mounted == true) {
        setState(() {
          lstmsg.insert(0, objmsg);
          tennguoidung = args[0]["roomName"];
        });
      }
    } else {
      showNotificationWithoutSound(objmsg.displayname, objmsg.content);
    }
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

    if ((ispagechatgroup == true && objmsg.roomid == widget.roomItem.id)) {
      if (mounted == true) {
        setState(() {
          lstmsg.insert(0, objmsg);
          tennguoidung = args[0]["roomName"];
        });
      }
    } else {
      showNotificationWithoutSound(objmsg.displayname, objmsg.content);
    }
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: textEditingController,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Nhập nội dung...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              if (hubConnection.state != HubConnectionState.Connected) {
                await hubConnection.start();
              }
              if (hubConnection.state == HubConnectionState.Connected) {
                await hubConnection.invoke('SendGroupMessage', args: [
                  nguoidungsession.id.toString(),
                  widget.roomItem.id,
                  textEditingController.text,
                  "Click"
                ]);
              }
              var objmsg = new MessageChat();
              objmsg.content = textEditingController.text;
              objmsg.isLiked = false;
              objmsg.id = 0;
              objmsg.time = DateTime.now().toString();
              objmsg.fromid = nguoidungsession.id;
              objmsg.toid = widget.roomItem.id;
              if (mounted == true) {
                setState(() {
                  lstmsg.insert(0, objmsg);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
