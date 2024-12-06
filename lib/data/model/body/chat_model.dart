class ChatModel {
  List<Mesages> mesages;

  ChatModel({this.mesages});

  ChatModel.fromJson(Map<String, dynamic> json) {
    if (json['mesages'] != null) {
      mesages = <Mesages>[];
      json['mesages'].forEach((v) {
        mesages.add(new Mesages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mesages != null) {
      data['mesages'] = this.mesages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Mesages {
  int id;
  String receiverId;
  String senderId;
  String content;
  String createdAt;
  String updatedAt;

  Mesages(
      {
        this.id,
        this.receiverId,
        this.senderId,
        this.content,
        this.createdAt,
        this.updatedAt});

  Mesages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiverId = json['receiver_id'];
    senderId = json['sender_id'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['receiver_id'] = this.receiverId;
    data['sender_id'] = this.senderId;
    data['content'] = this.content;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
