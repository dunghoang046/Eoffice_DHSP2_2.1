import 'package:app_eoffice/block/chat_block.dart';
import 'package:app_eoffice/models/Chat/ChatUserDetail.dart';
import 'package:app_eoffice/views/Chat/chat_ListUser.dart';
import 'package:app_eoffice/views/Chat/chat_detaild_all.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:app_eoffice/utils/Base.dart';
import 'package:provider/provider.dart';
import 'package:app_eoffice/utils/ColorUtils.dart';
import 'package:simple_router/simple_router.dart';

int currentPage = 0;
int currentPageNow = 1;

class ChatDetailpage extends StatelessWidget {
  final String fromid;
  final String toid;
  final ChatUserDetail user;
  ChatDetailpage({@required this.fromid, this.toid, this.user});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MyChatDetailpage(fromid: fromid, toid: toid, user: user);
  }
}

TabController _tabController;
String keyword = '';
int indexselect = 0;
bool inter = true;
String tennguoidung = '';

class MyChatDetailpage extends StatefulWidget {
  final String fromid;
  final String toid;
  final ChatUserDetail user;
  MyChatDetailpage({@required this.fromid, this.toid, this.user});
  GlobalKey<ScaffoldState> globalKey;
  @override
  _MyChatDetailpage createState() => _MyChatDetailpage();
}

class _MyChatDetailpage extends State<MyChatDetailpage>
    with SingleTickerProviderStateMixin {
  List<Tab> lsttab = <Tab>[];
  List<StatefulWidget> lsttabview = <StatefulWidget>[];
  @override
  void initState() {
    super.initState();
    keyword = '';
    setState(() {
      tennguoidung = widget.user.nguoiDungItem.tenhienthi;
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
                    SimpleRouter.forward(Mychat_Listuserpage(roomid: "0"));
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
            ],
            title: cusSearchBar),
        preferredSize: Size.fromHeight(50),
      ),
      body: Center(
        child: Provider<Chatblock>(
          child: ChatAllpage(
            fromid: widget.fromid,
            toid: widget.toid,
            user: widget.user,
            requestblock: new Chatblock(widget.fromid, widget.toid),
          ),
          create: (context) => new Chatblock(widget.fromid, widget.toid),
          dispose: (context, bloc) => bloc.dispose(),
        ),
      ),
    ));
  }
}
