import 'package:app_eoffice/block/base/state.dart';
import 'package:app_eoffice/block/chat_block.dart';
import 'package:app_eoffice/models/Chat/ChatUserDetail.dart';
import 'package:app_eoffice/widget/Chat/chat_Detaild_panel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:app_eoffice/main.dart';
import 'package:provider/provider.dart';

class ChatAllpage extends StatefulWidget {
  final String fromid;
  final String toid;
  Chatblock requestblock;
  final ChatUserDetail user;
  ChatAllpage({this.fromid, this.toid, this.requestblock, this.user});
  _ChatAllpage createState() => _ChatAllpage();
}

String keyword = '';
bool inter = true;

class _ChatAllpage extends State<ChatAllpage>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController(
    keepScrollOffset: true,
  );

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMoreTopStoriesIfNeed);
  }

  @override
  void dispose() {
    print('Đóng ds cv');
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.requestblock = Provider.of<Chatblock>(context);
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  loadrefresh() {
    setState(() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Mymain(
                  datatabindex: 3,
                )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Chat_detailpanel(
      objBloc: widget.requestblock,
      scrollController_rq: _scrollController,
      user: widget.user,
    );
  }

  void _loadMoreTopStoriesIfNeed() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.requestblock.loadMore(widget.fromid, widget.toid);
    }
  }

  Future<Null> loadtop() async {
    // if (_scrollController.position.atEdge) {
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent) {
      setState(() {
        widget.requestblock.loadtop(widget.fromid, widget.toid);
      });
    }
    // }
    return null;
  }
}
