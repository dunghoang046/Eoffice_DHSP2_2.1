import 'dart:async';
import 'package:app_eoffice/block/base/event.dart';
import 'package:app_eoffice/block/base/state.dart';
import 'package:app_eoffice/models/ThongTinDatPhongItem.dart';
import 'package:app_eoffice/services/DatPhong_Api.dart';
import 'package:app_eoffice/utils/Base.dart';
import 'base_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DatPhongblock extends Blocdispose {
  int currentPageNow = 1;
  int currentPage = 1;
  int total = 0;
  int totaldelete = 0;
  bool isloadingdelete = true;
  var _lstobject = <ThongTinDatPhongItem>[];
  final _repository = DatPhong_Api();

  var _isLoadingMore = false;

  var currentStoryIndex = 0;
  StreamController<List<ThongTinDatPhongItem>> topStoriesStreamController =
      StreamController();
  Stream<List<ThongTinDatPhongItem>> get topStories =>
      topStoriesStreamController.stream;
  var dataquery = {
    "CurrentPage": '1',
    "RowPerPage": '10',
    "SearchIn": 'MoTa',
    "Keyword": '',
  };
  DatPhongblock(keyword, type) {
    _loadInitTopStories(keyword, type);
  }

  void _loadInitTopStories(keyword, type) async {
    loadMore(keyword, type);
  }

  void loadtop(keyword, type) async {
    topStoriesStreamController = new StreamController();
    _lstobject = <ThongTinDatPhongItem>[];
    currentPage = 1;
    totaldelete = 0;
    isloadingdelete = true;
    loadMore(keyword, type);
  }

  Future<Null> loadtopref(keyword, type) async {
    topStoriesStreamController = new StreamController();
    _lstobject = <ThongTinDatPhongItem>[];
    currentPage = 1;
    loadMore(keyword, type);
  }

  bool inter = true;
  checkinter() async {
    inter = await checkinternet();
  }

  void loadMore(keyword, type) async {
    inter = await checkinternet();
    dataquery = {
      "CurrentPage": "" + currentPage.toString() + "",
      "RowPerPage": '15',
      "SearchIn": 'NoiDung',
      "Keyword": '' + keyword + '',
    };

    if (currentPage > 1) {
      if (currentPage > 1) currentPageNow = currentPage - 1;
      if (currentPage == 1) currentPage = 2;
      if ((currentPageNow * 10) < total) {
        _isLoadingMore = true;
      } else
        _isLoadingMore = false;
    }
    if (currentPage == 1) _isLoadingMore = true;
    if (_isLoadingMore == true) {
      try {
        var lst = await _repository.getdatphong(dataquery, currentPage);
        if (lst.length > 0) total = lst[0].totalRecord;
        _lstobject.addAll(lst);
        currentStoryIndex = totaldelete + _lstobject.length;
        if (!topStoriesStreamController.isClosed)
          topStoriesStreamController.sink.add(_lstobject);
        currentPage = currentPage + 1;
      } catch (e) {
        throw Exception('Lỗi lấy dữ liệu: ' + e.toString());
      }
    }
  }

  bool hasMoreStories() => currentStoryIndex < total;
  bool checkinternetNo() => checkinternet();
  @override
  void dispose() {
    topStoriesStreamController.close();
  }
}

class BlocDatPhongAction extends Bloc<ActionEvent, ActionState> {
  BlocDatPhongAction() : super(DoneState());
  get initialState => DoneState();

  bool isError = false;
  DatPhong_Api objapi = new DatPhong_Api();
  static get loginItem => loginItem;
  @override
  Stream<ActionState> mapEventToState(ActionEvent event) async* {
    try {
      isError = false;
      yield LoadingState();
      if (event is SendEvent) {
        await objapi.postsend(event.data).then((objdata) {
          if (objdata["Error"] == true) isError = true;
          basemessage = objdata["Title"];
        });
        if (isError)
          yield ErrorState();
        else
          yield DoneState();
      }
      if (event is ListEvent) {
        yield ViewState();
      }
      if (event is ApproverEvent) {
        await objapi.postapproved(event.data).then((objdata) {
          if (objdata["Error"] == true) isError = true;
          basemessage = objdata["Title"];
        });
        if (isError)
          yield ErrorState();
        else
          yield DoneState();
      }
      if (event is ListEvent) {
        yield ViewState();
      }
      if (event is ViewEvent) {
        yield ViewState();
      }
      if (event is RejectEvent) {
        await objapi.postReject(event.data).then((objdata) {
          if (objdata["Error"] == true) isError = true;
          basemessage = objdata["Title"];
        });
        yield DoneState();
      }
    } catch (ex) {
      yield ErrorState();
    }
  }
}
