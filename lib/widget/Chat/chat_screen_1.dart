// import 'package:app_eoffice/block/base/event.dart';
// import 'package:app_eoffice/block/chat_block.dart';
// import 'package:app_eoffice/models/Chat/ChatUserDetail.dart';
// import 'package:app_eoffice/models/Chat/message_model.dart';
// import 'package:app_eoffice/services/Base_service.dart';
// import 'package:app_eoffice/utils/Base.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:signalr_client/hub_connection.dart';
// // Import theses libraries.
// import 'package:signalr_client/signalr_client.dart';
// import 'package:simple_router/simple_router.dart';

// class ChatScreen extends StatefulWidget {
//   final ChatUserDetail user;

//   ChatScreen({this.user});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   void initState() {
//     ispagechat = true;
//     getcontent();
//     super.initState();
//   }

//   void dispose() {
//     ispagechat = false;
//     // closeChatConnection();
//     // openChatConnection();
//     print(hubConnection.state.toString());
//     super.dispose();
//   }

//   @override
//   void deactivate() {
//     super.deactivate();
//   }

//   var lst = [];
//   List<Message> lstmsg = new List<Message>();
//   TextEditingController textEditingController = new TextEditingController();
//   void getcontent() async {
//     // await hubConnection.stop();
//     if (hubConnection.state == HubConnectionState.Disconnected) {
//       try {
//         await hubConnection.start();
//       } catch (e) {
//         await hubConnection.start();
//       }
//     }
//     if (hubConnection.state == HubConnectionState.Connected) {
//       hubConnection.on("SendPrivateMessage", _sendPrivateMessage);
//       final result = await hubConnection.invoke("GetPrivateMessage",
//           args: <Object>[
//             nguoidungsession.id.toString(),
//             widget.user.nguoiDungItem.id.toString(),
//             "10"
//           ]);
//       lst = result;
//       if (mounted == true) {
//         setState(() {
//           if (result != null) {
//             for (var i = 0; i < lst.length; i++) {
//               Message obj = new Message();
//               obj.content = lst[i]["messageContent"].toString();
//               obj.fromid = lst[i]["fromID"];
//               obj.toid = lst[i]["toID"];
//               obj.time = lst[i]["sendDate"];
//               obj.status = lst[i]["status"];
//               obj.isLiked = false;
//               obj.id = lst[i]["id"];
//               lstmsg.add(obj);
//             }
//             lstmsg.sort((a, b) => b.id.compareTo(a.id));
//           }
//         });
//       }
//     }
//   }

//   _sendPrivateMessage(List<dynamic> args) {
//     var objmsg = new Message();
//     objmsg.content = args[2];
//     objmsg.isLiked = false;
//     objmsg.id = 0;
//     objmsg.time = args[3] != null ? args[3] : DateTime.now().toString();
//     objmsg.fromid = args[0]["id"];
//     objmsg.toid = args[1]["id"];
//     if (ispagechat != true) {
//       showNotificationWithoutSound(objmsg.content);
//     } else {
//       if (mounted == true) {
//         setState(() {
//           lstmsg.insert(0, objmsg);
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       appBar: AppBar(
//         title: Text(
//           widget.user.nguoiDungItem.tenhienthi,
//           style: TextStyle(
//             fontSize: 28.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         leading: new IconButton(
//             icon: Icon(Icons.arrow_back),
//             onPressed: () async {
//               closeChatConnection();
//               ListChatEvent listChatEvent = new ListChatEvent();
//               BlocProvider.of<BlocChatAction>(context).add(listChatEvent);
//               SimpleRouter.back();
//             }),
//         elevation: 0.0,
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.more_horiz),
//             iconSize: 30.0,
//             color: Colors.white,
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: GestureDetector(
//         onTap: () => FocusScope.of(context).unfocus(),
//         child: Column(
//           children: <Widget>[
//             Expanded(
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30.0),
//                     topRight: Radius.circular(30.0),
//                   ),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30.0),
//                     topRight: Radius.circular(30.0),
//                   ),
//                   child: ListView.builder(
//                     reverse: true,
//                     padding: EdgeInsets.only(top: 15.0),
//                     itemCount: lstmsg.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final Message message = lstmsg[index];
//                       final bool isMe = message.fromid == nguoidungsession.id;
//                       return _buildMessage(message, isMe);
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             _buildMessageComposer(),
//           ],
//         ),
//       ),
//     );
//   }
// }
