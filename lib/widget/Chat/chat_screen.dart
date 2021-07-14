import 'package:app_eoffice/block/base/event.dart';
import 'package:app_eoffice/block/chat_block.dart';
import 'package:app_eoffice/models/Chat/ChatUserDetail.dart';
import 'package:app_eoffice/models/Chat/message_model.dart';
import 'package:app_eoffice/services/Base_service.dart';
import 'package:app_eoffice/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_client/hub_connection.dart';
// Import theses libraries.
import 'package:signalr_client/signalr_client.dart';
import 'package:simple_router/simple_router.dart';

class ChatScreen extends StatefulWidget {
  final ChatUserDetail user;

  ChatScreen({this.user});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    ispagechat = true;
    getcontent();
    super.initState();
  }

  void dispose() {
    ispagechat = false;
    print(hubConnection.state.toString());
    super.dispose();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  var lst = [];
  List<MessageChat> lstmsg = new List<MessageChat>();
  TextEditingController textEditingController = new TextEditingController();
  void getcontent() async {
    // await hubConnection.stop();
    if (hubConnection.state == HubConnectionState.Disconnected) {
      try {
        await hubConnection.start();
      } catch (e) {
        await hubConnection.start();
      }
    }
    if (hubConnection.state == HubConnectionState.Connected) {
      hubConnection.on("SendPrivateMessage", _sendPrivateMessage);
      final result = await hubConnection.invoke("GetPrivateMessage",
          args: <Object>[
            nguoidungsession.id.toString(),
            widget.user.nguoiDungItem.id.toString(),
            "10"
          ]);
      lst = result;
      if (mounted == true) {
        setState(() {
          if (result != null) {
            for (var i = 0; i < lst.length; i++) {
              MessageChat obj = new MessageChat();
              obj.content = lst[i]["messageContent"].toString();
              obj.fromid = lst[i]["fromID"];
              obj.toid = lst[i]["toID"];
              obj.time = lst[i]["sendDate"];
              obj.status = lst[i]["status"];
              obj.isLiked = false;
              obj.id = lst[i]["id"];
              lstmsg.add(obj);
            }
            lstmsg.sort((a, b) => b.id.compareTo(a.id));
          }
        });
      }
    }
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
    if (ispagechatgroup != true) {
      showNotificationWithoutSound(objmsg.displayname, objmsg.content);
    } else {
      if (mounted == true) {
        setState(() {
          lstmsg.insert(0, objmsg);
        });
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          widget.user.nguoiDungItem.tenhienthi,
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: new IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              closeChatConnection();
              ListChatEvent listChatEvent = new ListChatEvent();
              BlocProvider.of<BlocChatAction>(context).add(listChatEvent);
              SimpleRouter.back();
            }),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
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
                    padding: EdgeInsets.only(top: 15.0),
                    itemCount: lstmsg.length,
                    itemBuilder: (BuildContext context, int index) {
                      final MessageChat message = lstmsg[index];
                      final bool isMe = message.fromid == nguoidungsession.id;
                      return _buildMessage(message, isMe);
                    },
                  ),
                ),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
