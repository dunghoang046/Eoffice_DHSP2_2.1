import 'dart:async';
import 'package:app_eoffice/block/base/event.dart';
import 'package:app_eoffice/block/base/state.dart';
import 'package:app_eoffice/models/Chat/message_model.dart';
import 'package:app_eoffice/services/CongViec_Api.dart';
import 'package:app_eoffice/services/chat_api.dart';
import 'package:app_eoffice/utils/Base.dart';
import 'package:signalr_client/hub_connection.dart';
import 'base_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatGroupblock extends Blocdispose {
  int currentPageNow = 1;
  int currentPage = 1;
  int total = 0;
  int totaldelete = 0;
  bool isloadingdelete = true;
  var _lstobject = <MessageChat>[];
  final _repository = Chat_Api();

  var _isLoadingMore = false;

  var currentStoryIndex = 0;
  StreamController<List<MessageChat>> topStoriesStreamController =
      StreamController();
  Stream<List<MessageChat>> get topStories => topStoriesStreamController.stream;
  var dataquery = {
    "CurrentPage": '1',
    "RowPerPage": '10',
  };
  ChatGroupblock(roomid, userid) {
    _loadInitTopStories(roomid, userid);
  }

  void _loadInitTopStories(roomid, userid) async {
    loadMore(roomid, userid);
  }

  void loadtop(roomid, userid) async {
    topStoriesStreamController = new StreamController();
    _lstobject = <MessageChat>[];
    currentPage = 1;
    totaldelete = 0;
    isloadingdelete = true;
    loadMore(roomid, userid);
  }

  Future<Null> loadtopref(roomid, userid) async {
    topStoriesStreamController = new StreamController();
    _lstobject = <MessageChat>[];
    currentPage = 1;
    loadMore(roomid, userid);
  }

  bool inter = true;
  checkinter() async {
    inter = await checkinternet();
  }

  void loadMore(roomid, userid) async {
    inter = await checkinternet();
    dataquery = {
      "CurrentPage": "" + currentPage.toString() + "",
      "RowPerPage": '10',
      "roomID": '' + roomid + '',
      "userID": '' + userid + '',
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
        var lst = await _repository.getGroupChatMessage(dataquery, currentPage);
        if (lst.length > 0) {
          total = lst[0].totalRecord;
          lst.sort((a, b) => b.id.compareTo(a.id));
        }
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

class BlocChatGroupAction extends Bloc<ActionEvent, ActionState> {
  BlocChatGroupAction() : super(DoneState());
  get initialState => DoneState();

  bool isError = false;
  CongViec_Api objapi = new CongViec_Api();
  static get loginItem => loginItem;

  @override
  Stream<ActionState> mapEventToState(ActionEvent event) async* {
    try {
      isError = false;
      yield LoadingState();
      if (event is RenameChatGroupEvent) {
        hubConnection.invoke('methodName');
        yield ViewListChatGroupState();
      }
      if (event is AddUserChatGroupEvent) {
        if (hubConnection.state == HubConnectionState.Connected) {
          await hubConnection.invoke('AddUserToRoom', args: [
            event.data['strroomID'],
            event.data['strimplementUserID'],
            event.data['struserIDs']
          ]);
        }
        yield DoneState();
      }
      if (event is DetaildChatEvent) {
        yield ViewDetailChatState();
      }
      if (event is DetaildChatGroupEvent) {
        yield ViewDetailChatGroupState();
      }
    } catch (ex) {
      basemessage = "Đã có lỗi xảy ra vui lòng xem lai";
      yield ErrorState();
    }
  }
}
