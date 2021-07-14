// import 'package:app_eoffice/utils/Base.dart';
import 'package:app_eoffice/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:signalr_client/hub_connection.dart';
import 'package:signalr_client/hub_connection_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePageTesstChat(title: 'Flutter Demo Home Page'),
    );
  }
}

final TextEditingController _textchat = TextEditingController();
final TextEditingController _txtnoidung = TextEditingController();
final TextEditingController _txtConnectID = TextEditingController();

class MyHomePageTesstChat extends StatefulWidget {
  MyHomePageTesstChat({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageTesstChat> {
  final serverUrlhub = "http://192.168.0.119:8082/chathub";
  // final serverUrl = "http://192.168.0.119:8082/chathub";
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  @override
  initState() {
    super.initState();
    hubConnection.on("ClientSendnotification", _onshownotification);
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    // If you have skipped STEP 3 then change app_icon to @mipmap/ic_launcher
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future _showNotificationWithoutSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        playSound: false, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Notification',
      'Đây là thông báo không có sound và default icon',
      platformChannelSpecifics,
      payload: 'No_Sound',
    );
  }

  _onshownotification(List<dynamic> args) {
    var noidung = args[0];
    _showNotificationWithoutSound();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('widget.title'),
      ),
      body:
          // stack(),
          Column(
        children: [
          _buildMessageComposer(),
          Expanded(
              child: Container(
            height: 300,
            child: Text(_txtConnectID.text),
          )),
          Expanded(
              child: Container(
            height: 300,
            child: Text(_txtnoidung.text),
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(hubConnection.state.toString());
          // _showNotificationWithoutSound();
          if (hubConnection.state != HubConnectionState.Connected) {
            await hubConnection.start();
          }
          if (hubConnection.state == HubConnectionState.Connected) {
            await hubConnection.invoke("Sendnotification",
                args: <Object>["13835", "Nội dung"]);
          }
          setState(() {
            print(hubConnection.state == HubConnectionState.Disconnected
                ? 'stop'
                : 'start');
          });
        },
        tooltip: 'Start/Stop',
        child: hubConnection.state == HubConnectionState.Disconnected
            ? Icon(Icons.play_arrow)
            : Icon(Icons.stop),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void startConnection() async {
    await hubConnection.start();
  }

  Widget _buildMessage(Message message, bool isMe) {
    final msg = Container(
      width: MediaQuery.of(context).size.width * 0.75,
      margin: isMe
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
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
        children: [
          Text(message.time,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              )),
          SizedBox(height: 8.0),
          Text(message.text,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
              )),
        ],
      ),
    );

    if (isMe) return msg;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        msg,
        IconButton(
          icon: Icon(
            message.isLiked ? Icons.favorite : Icons.favorite_border_outlined,
            size: 30.0,
            color: message.isLiked
                ? Theme.of(context).primaryColor
                : Colors.blueGrey,
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessageComposer() {
    return Container(
      height: 70.0,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.photo),
            color: Theme.of(context).primaryColor,
            iconSize: 25.0,
            onPressed: () {},
          ),
          Expanded(
              child: TextFormField(
            // onChanged: (value) {
            //   setState(() {
            //     _textchat.text = value;
            //   });
            // },
            // textCapitalization: TextCapitalization.sentences,
            controller: _textchat,
            decoration: InputDecoration(
              hintText: "Send a message ...",
              border: InputBorder.none,
            ),
          )),
          IconButton(
            icon: Icon(Icons.stop),
            color: Theme.of(context).primaryColor,
            iconSize: 25.0,
            onPressed: () async {
              if (hubConnection.state == HubConnectionState.Connected) {
                await hubConnection.stop();
              }
            },
          ),
        ],
      ),
    );
  }

  void initSignalR() {
    hubConnection = HubConnectionBuilder().withUrl(serverUrlhub).build();
    hubConnection.onclose((error) {
      print('Connection close');
    });
    hubConnection.on("ChatClientUser", _handlechat);
    hubConnection.on("OnconnectClient", _handleOnclient);
  }

  _handleOnclient(List<Object> args) {
    setState(() {
      _txtConnectID.text = args[0].toString();
    });
  }

  _handlechat(List<Object> args) {
    setState(() {
      _txtnoidung.text = args[0].toString() + "ConnectID: " + args[1];
    });
  }

  Future onSelectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (_) {
        return new AlertDialog(
          title: Text("Thông báo"),
          content: Text("Push Notification : $payload"),
        );
      },
    );
  }
}

class Message {
  final User sender;
  final String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.isLiked,
    this.unread,
  });
}

class User {
  final int id;
  final String name;
  final String imageUrl;

  User({
    this.id,
    this.name,
    this.imageUrl,
  });
}
