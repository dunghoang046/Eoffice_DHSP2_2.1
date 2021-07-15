abstract class ActionEvent {
  dynamic data;
  dynamic donviid;
}

class NoEvent extends ActionEvent {}

class ViewEvent extends ActionEvent {}

class AddEvent extends ActionEvent {}

class ViewThanhPhanTGEvent extends ActionEvent {}

class AddThanhPhanTGEvent extends ActionEvent {}

class ListEvent extends ActionEvent {}

class ViewYKienEvent extends ActionEvent {}

class EditEvent extends ActionEvent {}

class DeleteEvent extends ActionEvent {}

class FinshEvent extends ActionEvent {}

class RejectEvent extends ActionEvent {}

class HoanThanhEvent extends ActionEvent {}

class YKienEvent extends ActionEvent {}

class ChuyenVanBanEvent extends ActionEvent {}

class TrinhLDEvent extends ActionEvent {}

class PhatHanhEvent extends ActionEvent {}

class TuChoiEvent extends ActionEvent {}

class ApproverEvent extends ActionEvent {}

class UploadfileEvent extends ActionEvent {}

class SettingNhanNotificationEvent extends ActionEvent {}

class SendEvent extends ActionEvent {}

class LoginSwitchEvent extends ActionEvent {}

class LoginSwitchPBEvent extends ActionEvent {}

class RefreshEvent extends ActionEvent {}

class ListChatEvent extends ActionEvent {}

class DetaildChatEvent extends ActionEvent {}

class DetaildChatGroupEvent extends ActionEvent {}

class RenameChatGroupEvent extends ActionEvent {}

class AddUserChatGroupEvent extends ActionEvent {}
