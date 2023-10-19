class Message{
    final String content;
    final DateTime time;
    final String senderId;
    final String receiverId;

    Message({
      required this.content,
      required this.senderId,
      required this.receiverId,
      required this.time
    });

    Map<String,dynamic> toJson(){
      return {
        "content": content,
        "time" : time,
        "receiverId" : receiverId,
        "senderId" : senderId
      };
    }

    factory Message.fromJson(Map<String,dynamic> json) =>
        Message(
            content: json["content"],
            senderId: json["senderId"],
            receiverId: json["receiverId"],
            time: json["time"].toDate()
        );


}