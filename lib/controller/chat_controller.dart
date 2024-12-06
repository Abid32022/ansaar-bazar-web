import 'dart:async';

import 'package:ansarbazzarweb/data/api/api_checker.dart';
import 'package:ansarbazzarweb/data/model/response/category_model.dart';
import 'package:ansarbazzarweb/data/model/response/product_model.dart';
import 'package:ansarbazzarweb/data/model/response/restaurant_model.dart';
import 'package:ansarbazzarweb/data/repository/category_repo.dart';
import 'package:ansarbazzarweb/data/repository/chat_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/body/chat_model.dart';

class ReciverMsgController extends GetxController implements GetxService {
  final ChatRepo chatRepo;
  ReciverMsgController({@required this.chatRepo});

  final _chatStreamController = StreamController<ChatModel>.broadcast();

  // Expose the stream to external widgets
  Stream<ChatModel> get chatStream => _chatStreamController.stream;
  ChatModel chatModel;

  Future<void> fetchChatData() async {
    try {
      final response = await chatRepo.getChatRepo();
      if (response.statusCode == 200) {
        chatModel = ChatModel.fromJson(response.body);
        _chatStreamController.add(chatModel);

        print('response is coming  ${_chatStreamController}');
        print('response is ${chatModel.mesages.length}');
        update();
      } else {
        throw Exception('Failed to load chat data');
      }
    } catch (e) {
      debugPrint('Error fetching chat data: $e');
    }
  }

}
