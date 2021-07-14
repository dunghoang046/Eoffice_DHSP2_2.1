class UserItem {
  int id;
  String username;
  String fullName;
  int donviid;
  UserItem(
    this.id,
    this.username,
    this.fullName,
    this.donviid,
  );
  UserItem.fromMap(Map<String, dynamic> map) {
    id = map['Id'];
    username = map['Username'];
    fullName = map['FullName'];
    if (map['DonViID'] != null) {
      donviid = map['DonViID'];
    }
  }
}
