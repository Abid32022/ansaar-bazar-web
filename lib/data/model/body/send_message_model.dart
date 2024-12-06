class SendMessageModel {
  double sender_id;
  String content;
  // String phone;
  // String email;
  // String password;

  SendMessageModel({this.sender_id, this.content,});

  SendMessageModel.fromJson(Map<String, dynamic> json) {
    sender_id = json['f_name'];
    content = json['v'];
    // phone = json['phone'];
    // email = json['email'];
    // password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender_id'] = this.sender_id;
    data['content'] = this.content;
    // data['phone'] = this.phone;
    // data['email'] = this.email;
    // data['password'] = this.password;
    return data;
  }
}
