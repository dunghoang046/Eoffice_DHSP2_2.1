import 'package:app_eoffice/block/base/state.dart';
import 'package:app_eoffice/block/chat_block.dart';
import 'package:app_eoffice/models/Chat/message_model.dart';
import 'package:app_eoffice/utils/Base.dart';
// import 'package:app_eoffice/widget/Chat/category_selector.dart';
import 'package:app_eoffice/widget/Chat/recent_chats.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_router/simple_router.dart';

class Home_ChatScreen extends StatefulWidget {
  @override
  _Home_ChatScreen createState() => _Home_ChatScreen();
}

final List<String> categories = ['Cá nhân', 'Nhóm'];
int selectedIndex = 0;
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _Home_ChatScreen extends State<Home_ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  _sendPrivateMessage(List<dynamic> args) {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: new IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              SimpleRouter.back();
            }),
        title: Text(
          'Chats',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 30.0,
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<BlocChatAction, ActionState>(
          buildWhen: (previousState, state) {
        if (state is ViewListChatState) {}
        return;
      }, builder: (context, state) {
        return Column(
          children: <Widget>[
            Container(
              height: 90.0,
              color: Theme.of(context).primaryColor,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 30.0,
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: index == selectedIndex
                              ? Colors.white
                              : Colors.white60,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    //  FavoriteContacts(),
                    MyRecentChats(tabindex: selectedIndex),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      // bottomNavigationBar: ,
      floatingActionButton: FloatingActionButton(
          onPressed: () {}, child: Icon(Icons.group_add_sharp)),
    ));
  }
}
