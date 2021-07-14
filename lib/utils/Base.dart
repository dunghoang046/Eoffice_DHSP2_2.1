import 'package:app_eoffice/services/Base_service.dart';
import 'package:app_eoffice/views/Nguoidung/HoSoCaNhan.dart';
import 'package:app_eoffice/views/PDFScreen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:app_eoffice/models/LookupItem.dart';
import 'package:app_eoffice/models/Nguoidungitem.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:load/load.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:signalr_client/http_connection_options.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';
import 'package:simple_router/simple_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logging/logging.dart';
import 'package:app_eoffice/models/Chat/message_model.dart';

bool islogin = false;
bool ischeckurl = true;
String keyword = '';
String tokenview = '';
String basemessage = '';
// dynamic lstfile;
int tabIndex = 0;
bool isautologin = true;
bool isSelectedremember = false;
bool connectionIsOpen = false;
NguoiDungItem nguoidungsessionView = new NguoiDungItem();
String strurlviewfile = "http://hpu2.e-office.vn/";
final serverUrlhub = "http://192.168.0.103:8082/chathub";
HubConnection hubConnection;
final transportProtLogger = Logger("SignalR - transport");
bool ispagechat = false;
bool ispagechatgroup = false;
final httpOptions = new HttpConnectionOptions(
  logger: transportProtLogger,
  accessTokenFactory: () {
    // ignore: unnecessary_statements
    nguoidungsession.token;
  },
  // accessTokenFactory: () async => await getAccessToken()
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
void settingpushnotification() {
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = new IOSInitializationSettings();

  var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  // if (nguoidungsessionView != null)
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: onClickNotification);
}

// ignore: unused_element
Future showNotificationWithoutSound(String title, String noidung) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    playSound: false,
    importance: Importance.Max,
    priority: Priority.High,
  );
  var iOSPlatformChannelSpecifics =
      new IOSNotificationDetails(presentSound: false);
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.show(
    1,
    title,
    noidung != null
        ? noidung
        : 'Đây là thông báo không có sound và default icon',
    platformChannelSpecifics,
    payload: 'Destination Screen (Simple Notification)',
  );
}

Future onClickNotification(String payload) {
  SimpleRouter.forward(HoSoCaNhanPage());
}

Future<void> closeChatConnection() async {
  if (hubConnection.state == HubConnectionState.Connected) {
    await hubConnection.stop();
  }
}

Future<void> openChatConnection() async {
  if (hubConnection == null) {
    hubConnection = HubConnectionBuilder()
        .withUrl(serverUrlhub + "?token=" + nguoidungsession.token,
            options: httpOptions)
        .configureLogging(transportProtLogger)
        .build();
    hubConnection.serverTimeoutInMilliseconds = 10 * 60 * 60 * 1000;
    hubConnection.keepAliveIntervalInMilliseconds = 10 * 60 * 60 * 1000;
    hubConnection.onclose((error) => connectionIsOpen = false);
  }
}

void connectServerHub() async {
  if (hubConnection.state == HubConnectionState.Disconnected) {
    try {
      await hubConnection.start();
    } catch (e) {
      print(e.toString());
    }
  }
  if (hubConnection.state == HubConnectionState.Connected)
    await hubConnection.invoke('Connect', args: [
      nguoidungsession.id.toString(),
    ]);
  print('Đã connnect');
}

Future<void> initSignalR() async {
  if (hubConnection == null ||
      (hubConnection != null &&
          hubConnection.state != HubConnectionState.Connected)) {
    hubConnection = HubConnectionBuilder().withUrl(serverUrlhub).build();
    hubConnection.serverTimeoutInMilliseconds = 120000;
    hubConnection.on("SendPrivateMessage", _sendPrivateMessageHome);
    hubConnection.on("onRenameRoomClient", _onRenameRoomClientHome);
    hubConnection.on("addUserToRoomClient", _addUserToRoomClientHome);

    await hubConnection.start();
    // hubConnection.
  }
  // hubConnection.onclose((error) {
  //   print('Connection close');
  // });
  // hubConnection.on("OnConnectClient", _handleOnclient);
}

_addUserToRoomClientHome(List<dynamic> args) {
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

_onRenameRoomClientHome(List<dynamic> args) {
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
  objmsg.displayname = args[2]["tenHienThi"];
  if (ispagechatgroup != true)
    showNotificationWithoutSound(objmsg.displayname, objmsg.content);
}

_sendPrivateMessageHome(List<dynamic> args) {
  if (ispagechat != true) {
    var objmsg = new MessageChat();
    objmsg.content = args[2];
    objmsg.isLiked = false;
    objmsg.id = 0;
    objmsg.time = args[3] != null ? args[3] : DateTime.now().toString();
    objmsg.fromid = args[0]["id"];
    objmsg.displayname = args[0]["tenHienThi"];
    objmsg.toid = args[1]["id"];
    showNotificationWithoutSound(objmsg.displayname, objmsg.content);
  } else {}
}

checkinternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}

var alertStyle = AlertStyle(
  animationType: AnimationType.fromTop,
  isCloseButton: false,
  isOverlayTapDismiss: false,
  descStyle: TextStyle(fontWeight: FontWeight.bold),
  titleStyle: TextStyle(color: Colors.red, fontSize: 14),
);

Future<List<LookupItem>> getlookupnguoidung(
    List<NguoiDungItem> lstnguoidung) async {
  var lstitems = <LookupItem>[];
  for (var i = 0; i < lstnguoidung.length; i++) {
    var obj = new LookupItem(0, '');
    obj.id = lstnguoidung[i].id;
    obj.text = lstnguoidung[i].tenhienthi;
    lstitems.add(obj);
  }
  return lstitems;
}

TextStyle textStylelabelform = TextStyle(
    fontStyle: FontStyle.italic,
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: Colors.black);
Widget rowlabel(title) => Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10, 7, 0, 7),
          child: Text(title, style: textStylelabelform),
        )
      ],
    );
Widget rowlabelValidate(title) => Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.fromLTRB(10, 7, 0, 7),
          child: RichText(
            text: TextSpan(
                text: title,
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                      text: ' *',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                ]),
          ),
        )
      ],
    );
Future<void> loadding() async {
  await EasyLoading.show(
    status: 'Đang xử lý...',
    maskType: EasyLoadingMaskType.custom,
  );
}

Future<void> dismiss() async {
  await EasyLoading.dismiss();
}

Widget containerRowViewfile(String value, int id, String filelink) => Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black26,
          ),
          // right: BorderSide(color: Colors.green, width: 6),
        ),
      ),
      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: InkWell(
              child: RichText(
                  softWrap: true,
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(text: value, style: TextStyle(color: Colors.black))
                  ])),
              onTap: () async {
                if (filelink.contains('.pdf') || filelink.contains('.PDF')) {
                  var urlfile = strurlviewfile + filelink;
                  SimpleRouter.forward(MyPDFSceen(pathfile: urlfile));
                } else {
                  var urlfile =
                      strurlviewfile + "view_file.aspx?FileID=" + id.toString();
                  _launchURL(urlfile);
                }
              },
            ),
          )
        ],
      ),
    );
void _launchURL(_url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
Widget buildRow() => Container(
      margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: Image.asset("assets/images/logo.png"),
    );
const MaterialColor white = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);
const cusIcon = Icon(Icons.search, color: Colors.white);
Widget cusSearchBarr = Text('Văn bản đến');
TextStyle stylebottomnav = new TextStyle(fontSize: 13);

class StarWarsStyles {
  static final double titleFontSize = 16.0;
  static final double subTitleFontSize = 14.0;
  static final Color titleColor = Colors.black.withAlpha(220);
  static final Color subTitleColor = Colors.black87;
}

bool checkquyen(String dsQuyen, int idQuyen) {
  dsQuyen = ',' + dsQuyen + ',';
  return dsQuyen.contains(',' + idQuyen.toString() + ',');
}

Widget buildDefaultDialog() {
  return IconButton(
    icon: Icon(Icons.slideshow),
    onPressed: () {
      showLoadingDialog();
    },
  );
}

Widget loaddataerror() =>
    Center(child: SizedBox(width: 30, height: 30, child: Text('load')));
Widget on_alter(context, noidung) {
  Alert(
    context: context,
    title: "Thông báo",
    style: AlertStyle(isCloseButton: false),
    desc: noidung,
  ).show();
}

Widget containerRowHtml(String label, String value) => Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black26,
          ),
          // right: BorderSide(color: Colors.green, width: 6),
        ),
      ),
      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
      child: Row(
        children: <Widget>[
          Expanded(child: Html(data: "<b>" + label + "</b>" + value)),
        ],
      ),
    );
