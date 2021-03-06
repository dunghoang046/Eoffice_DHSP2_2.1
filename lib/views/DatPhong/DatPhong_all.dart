import 'package:app_eoffice/block/DatXeBloc.dart';
import 'package:app_eoffice/block/base/state.dart';
import 'package:app_eoffice/block/datphongblock.dart';
import 'package:app_eoffice/views/DatPhong/DatPhong.dart';
import 'package:app_eoffice/widget/DatPhong/DatPhongPanel.dart';
import 'package:app_eoffice/widget/DatXe/DatXePanel.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:app_eoffice/main.dart';
import 'package:app_eoffice/widget/NoInternetConnection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:simple_router/simple_router.dart';

class MyDatPhongAllpage extends StatefulWidget {
  final String requestkeyword;
  DatPhongblock requestblock;
  MyDatPhongAllpage({this.requestkeyword, this.requestblock});
  _MyDatPhongAllpage createState() => _MyDatPhongAllpage();
}

String keyword = '';
bool inter = true;

class _MyDatPhongAllpage extends State<MyDatPhongAllpage>
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
    widget.requestblock = Provider.of<DatPhongblock>(context);
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

// load width click
  loadrefresh() {
    setState(() {
      SimpleRouter.forward(DatPhongpage());
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: loadtop,
        child: FutureBuilder(
            future: check(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Đã có lỗi xảy ra'),
                );
              }
              if (snapshot.hasData && snapshot.data) {
                return BlocBuilder<BlocDatPhongAction, ActionState>(
                    // ignore: missing_return
                    buildWhen: (previousState, state) {
                  if (state is ViewState) {
                    loadtop();
                  }
                }, builder: (context, state) {
                  return DatPhongpanel(
                    objBloc: widget.requestblock,
                    scrollController_rq: _scrollController,
                  );
                });
              } else {
                return Center(
                  child: NoInternetConnection(action: loadrefresh),
                );
              }
            }));
  }

  Future<Null> loadtop() async {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels <=
          _scrollController.position.minScrollExtent) {
        setState(() {
          widget.requestblock.loadtop(
              widget.requestkeyword != null ? widget.requestkeyword : '', 0);
        });
      }
    }
    return null;
  }

  Future<Null> _loadMoreTopStoriesIfNeed() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.requestblock.loadMore(
          widget.requestkeyword != null ? widget.requestkeyword : '', 0);
    }
  }
}
