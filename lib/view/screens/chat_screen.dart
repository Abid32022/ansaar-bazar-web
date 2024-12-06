import 'dart:async';
import 'package:ansarbazzarweb/controller/sendController.dart';
import 'package:ansarbazzarweb/data/model/body/chat_model.dart';
import 'package:ansarbazzarweb/data/model/body/send_message_model.dart';
import 'package:ansarbazzarweb/util/messages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/chat_controller.dart';
import '../../data/api/api_client.dart';
import '../../data/repository/chat_repo.dart';
import '../../util/app_constants.dart';
import '../../util/styles.dart';

class ChatScreen2 extends StatefulWidget {
  //const ChatScreen2(@required this.b);
  // final ChatsModel b;

  @override
  _ChatScreen2State createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> {
  final TextEditingController _textController = TextEditingController();
  final List<Widget> _messages = [];
  ScrollController _scrollController; // Add this line


  // @override
  // void initState() {
  //   Get.find<ReciverMsgController>().fetchChatData();
  //   // TODO: implement initState
  //   super.initState();
  // }
  Timer _timer;
  @override
  void initState() {
    _scrollController = ScrollController();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      Get.find<ReciverMsgController>().fetchChatData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black12,
        body: GetBuilder<ReciverMsgController>(
          builder: (reciverControllers) {
            return Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  height: 110,
                  width: Get.width,
                  decoration: const BoxDecoration(
                    //  color: AppColors.white,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 45,
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9.34),
                                border: Border.all(
                                  color: Colors.grey,
                                )),
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Icon(Icons.arrow_back),
                            ),
                          ),
                          SizedBox(
                            width: 18,
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  // backgroundImage: AssetImage("assets/images/gallery4.png"),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //  SizedBox(height:  30,),
                                    Text(
                                      "Bellamy Nich…",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                StreamBuilder<ChatModel>(
                  stream: reciverControllers.chatStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      ChatModel chatModel = snapshot.data;
                      chatModel.mesages.sort((a, b) => a.id.compareTo(b.id));

                      return Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          reverse: false, // Set reverse to true
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: chatModel.mesages.length ?? 0,
                          itemBuilder: (context, index) {
                            // Messages message = chatModel.messages[index]; // Correct the typo here
                            Mesages message = chatModel.mesages[index];
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                message.senderId == '44' ?      Padding(
                                  padding: EdgeInsets.only(top: 20, left: 10),
                                  child: CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.blue,
                                  ),
                                ):SizedBox(),
                                Expanded(
                                  child: Container(
                                    margin:message.senderId == '44' ?  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 120):const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 100),
                                    padding:message.senderId == '44' ?  EdgeInsets.symmetric(horizontal: 20, vertical: 20): const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

                                    // margin: const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 100),
                                    // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

                                    decoration: BoxDecoration(
                                      color: message.senderId == '44' ? Colors.lightGreen : Colors.grey,
                                      borderRadius:message.senderId == '44' ?  BorderRadius.only(

                                        topRight: Radius.circular(15),
                                        topLeft:Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ):BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                      ),
                                    ),
                                    child: Text(
                                      message.content,
                                      style: robotoBold,

                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    } else {
                      // Handle the case when there is no data (e.g., loading indicator)
                      return Expanded(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    }
                  },
                ),



                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  //  color: Colors.red,
                  height: 80,
                  width: Get.width,
                  child: Row(
                    children: [
                      InkWell(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              // gradient: ,
                              color: Colors.grey),
                          child: Icon(Icons.cut),
                          // child: Image.asset("assets/icons/cross.png",scale: 3.8,),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GetBuilder<ReciverMsgController>(
                              builder: (reciverController) {
                                return GetBuilder<SendMessageController>(
                                  builder: (sendController) {
                                    return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: 1,
                                        itemBuilder: (context, index) {
                                          return TextField(
                                            controller: _textController,
                                            decoration: InputDecoration(
                                              hintText: 'Type here...',
                                              filled: true,
                                              fillColor: Colors.grey,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                              prefixIcon:
                                              null, // Assuming you don't need a prefix icon
                                              suffixIcon: InkWell(
                                                  onTap: () {
                                                    sendController.sendMessageController(message: _textController.text, userId: '1');

                                                    setState(() {
                                                      Mesages message = reciverController.chatModel.mesages[index];

                                                      if (message.senderId == AppConstants.userID) {_messages.add(SenderMessage(text: message.content));

                                                      _messages.add(SenderMessage(text: reciverController.chatModel.mesages.toString()));
                                                      _scrollController.animateTo(
                                                        _scrollController.position.maxScrollExtent,
                                                        duration: Duration(milliseconds: 300),
                                                        curve: Curves.easeOut,
                                                      );

                                                        // } else {
                                                        //   _messages.add(
                                                        //       ReceiverMessage(text: message.content));
                                                        //
                                                        //   // _messages.add(SenderMessage(text: reciverController.chatModel.mesages.toString()));
                                                        // }

                                                      }
                                                    });
                                                    _textController.clear();

                                                  },
                                                  child: Icon(Icons
                                                      .arrow_circle_right_outlined)
                                                // Image.asset("assets/icons/arrowfarward2.png", scale: 4),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                );
                              },
                            )),
                      )
                    ],
                  ),
                ),
              ],
            );
          },
        ));
  }
}

class SenderMessage extends StatelessWidget {
  final String text;

  const SenderMessage({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20, left: 10),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue,
            // backgroundImage: AssetImage("assets/images/beard2.png"),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 120),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Text(
              text, style: robotoBold,
              // GoogleFonts.dmSans(textStyle:  TextStyle(fontSize: MySize.scaleFactorHeight*13,fontWeight: FontWeight.w400,color: const Color(0xff524B6B)),)),
            ),
          ),
        )
      ],
    );
  }
}

class ReceiverMessage extends StatelessWidget {
  final String text;

  const ReceiverMessage({@required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 10, right: 20, left: 100),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: const BoxDecoration(
              color: Colors.blue,
              // gradient: blu,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: Text(
              text, style: robotoBold,
              // GoogleFonts.dmSans(textStyle: GoogleFonts.dmSans(textStyle:  TextStyle(fontSize: MySize.scaleFactorHeight*13,fontWeight: FontWeight.w400,color: Colors.white),),),textAlign: TextAlign.center,),
            ),
          )
        ]);
  }
}

class ChatsModel {
  String title;
  String subtitle;
  String images;
  ChatsModel(this.title, this.subtitle, this.images);
}
