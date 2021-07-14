import 'package:app_eoffice/models/Chat/user_model.dart';

class MessageChat {
  User sender;
  String avatar;
  int status;
  int id;
  String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  String content;
  String formname;
  bool isLiked;
  bool unread;
  int fromid;
  int toid;
  int totalRecord;
  String username;
  String displayname;
  int roomid;
  MessageChat(
      {this.sender,
      this.time,
      this.content,
      this.isLiked,
      this.unread,
      this.fromid,
      this.toid,
      this.status,
      this.id,
      this.formname,
      this.totalRecord,
      this.username,
      this.displayname,
      this.roomid,
      this.avatar});

  MessageChat.fromMap(Map<String, dynamic> map) {
    id = map['ID'];
    fromid = map['FromID'];
    toid = map['ToID'];
    time = map['SendDate'];
    isLiked = false;
    content = map['MessageContent'];
    totalRecord = map['TotalRecord'];
    if (map['UserName'] != null) username = map['UserName'];
    if (map['DisplayName'] != null) displayname = map['DisplayName'];
  }
}

// YOU - current user
final User currentUser = User(
  id: 0,
  name: 'Current User',
  imageUrl: 'assets/images/greg.jpg',
);

// USERS
final User greg = User(
  id: 1,
  name: 'Greg',
  imageUrl: 'assets/images/greg.jpg',
);
final User james = User(
  id: 2,
  name: 'James',
  imageUrl: 'assets/images/james.jpg',
);
final User john = User(
  id: 3,
  name: 'John',
  imageUrl: 'assets/images/john.jpg',
);
final User olivia = User(
  id: 4,
  name: 'Olivia',
  imageUrl: 'assets/images/olivia.jpg',
);
final User sam = User(
  id: 5,
  name: 'Sam',
  imageUrl: 'assets/images/sam.jpg',
);
final User sophia = User(
  id: 6,
  name: 'Sophia',
  imageUrl: 'assets/images/sophia.jpg',
);
final User steven = User(
  id: 7,
  name: 'Steven',
  imageUrl: 'assets/images/steven.jpg',
);

// FAVORITE CONTACTS
List<User> favorites = [sam, steven, olivia, john, greg];

// EXAMPLE CHATS ON HOME SCREEN
List<MessageChat> chats = [
  MessageChat(
    sender: james,
    time: '5:30 PM',
    content: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  MessageChat(
    sender: olivia,
    time: '4:30 PM',
    content: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  MessageChat(
    sender: john,
    time: '3:30 PM',
    content: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  MessageChat(
    sender: sophia,
    time: '2:30 PM',
    content: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: true,
  ),
  MessageChat(
    sender: steven,
    time: '1:30 PM',
    content: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  MessageChat(
    sender: sam,
    time: '12:30 PM',
    content: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
  MessageChat(
    sender: greg,
    time: '11:30 AM',
    content: 'Hey, how\'s it going? What did you do today?',
    isLiked: false,
    unread: false,
  ),
];

// EXAMPLE MESSAGES IN CHAT SCREEN
List<MessageChat> messages = [
  MessageChat(
    sender: james,
    time: '5:30 PM',
    content: 'Hey, how\'s it going? What did you do today?',
    isLiked: true,
    unread: true,
  ),
  MessageChat(
    sender: currentUser,
    time: '4:30 PM',
    content: 'Just walked my doge. She was super duper cute. The best pupper!!',
    isLiked: false,
    unread: true,
  ),
  MessageChat(
    sender: james,
    time: '3:45 PM',
    content: 'How\'s the doggo?',
    isLiked: false,
    unread: true,
  ),
  MessageChat(
    sender: james,
    time: '3:15 PM',
    content: 'All the food',
    isLiked: true,
    unread: true,
  ),
  MessageChat(
    sender: currentUser,
    time: '2:30 PM',
    content: 'Nice! What kind of food did you eat?',
    isLiked: false,
    unread: true,
  ),
  MessageChat(
    sender: james,
    time: '2:00 PM',
    content: 'I ate so much food today.',
    isLiked: false,
    unread: true,
  ),
];
