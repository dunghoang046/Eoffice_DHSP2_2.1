import 'package:app_eoffice/block/chat_block.dart';
import 'package:app_eoffice/models/Chat/ChatUserDetail.dart';
import 'package:app_eoffice/models/Chat/message_model.dart';
import 'package:app_eoffice/services/Base_service.dart';
import 'package:app_eoffice/utils/Base.dart';

import 'package:flutter/material.dart';

import 'package:app_eoffice/widget/Base_widget.dart';
import 'package:signalr_client/hub_connection.dart';

class Chat_detailpanel extends StatefulWidget {
  Chatblock objBloc;
  ScrollController scrollController_rq;
  final ChatUserDetail user;

  Chat_detailpanel(
      {@required this.objBloc, this.scrollController_rq, this.user});

  _Chat_detailpanel createState() => _Chat_detailpanel();
}

bool inter = true;
bool check = true;
int totals = 0;

List<MessageChat> lstmsg = new List<MessageChat>();
TextEditingController textEditingController = new TextEditingController();

class _Chat_detailpanel extends State<Chat_detailpanel> {
  @override
  void initState() {
    super.initState();
    ispagechat = true;
    hubConnection.on("SendPrivateMessage", _sendPrivateMessage);
    lstmsg = [];
  }

  void dispose() {
    print('đóng ds cv panl');
    widget.objBloc.dispose();
    // hubConnection.off("SendPrivateMessage");
    widget.scrollController_rq.dispose();
    super.dispose();
    ispagechat = false;
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
          Text(
            message.time,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
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
    objmsg.content = args[2];
    objmsg.isLiked = false;
    objmsg.id = 0;
    objmsg.time = args[3] != null ? args[3] : DateTime.now().toString();
    objmsg.fromid = args[0]["id"];
    objmsg.toid = args[1]["id"];
    objmsg.displayname = args[0]["tenHienThi"];
    if ((ispagechat == true && objmsg.fromid == widget.user.nguoiDungItem.id)) {
      // showNotificationWithoutSound(objmsg.content);
      if (mounted == true) {
        setState(() {
          lstmsg.insert(0, objmsg);
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
                hintText: 'Send a message...',
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
                await hubConnection.invoke('SendPrivateMessage', args: [
                  nguoidungsession.id.toString(),
                  widget.user.nguoiDungItem.id.toString(),
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
              objmsg.toid = widget.user.nguoiDungItem.id;
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
