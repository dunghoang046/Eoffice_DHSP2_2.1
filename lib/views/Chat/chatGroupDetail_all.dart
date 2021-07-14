import 'package:app_eoffice/block/chatGroup_block.dart';
import 'package:app_eoffice/models/Chat/ChatRoomItem.dart';
import 'package:app_eoffice/widget/Chat/chatGroupDetaild_panel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:app_eoffice/main.dart';
import 'package:provider/provider.dart';

class ChatGroupAllpage extends StatefulWidget {
  final String fromid;
  final String toid;
  ChatGroupblock requestblock;
  final ChatRoomItem chatRoomItem;
  ChatGroupAllpage(
      {this.fromid, this.toid, this.requestblock, this.chatRoomItem});
  _ChatGroupAllpage createState() => _ChatGroupAllpage();
}

String keyword = '';
bool inter = true;

class _ChatGroupAllpage extends State<ChatGroupAllpage>
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
    widget.requestblock = Provider.of<ChatGroupblock>(context);
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
    return ChatGroupdetailpanel(
      objBloc: widget.requestblock,
      scrollController_rq: _scrollController,
      roomItem: widget.chatRoomItem,
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
