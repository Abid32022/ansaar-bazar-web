import 'package:ansarbazzarweb/data/api/api_checker.dart';
import 'package:ansarbazzarweb/data/model/body/send_message_model.dart';
import 'package:ansarbazzarweb/data/model/response/product_model.dart';
import 'package:ansarbazzarweb/data/model/response/restaurant_model.dart';
import 'package:ansarbazzarweb/data/repository/search_repo.dart';
import 'package:ansarbazzarweb/data/repository/send_message_repo.dart';
import 'package:ansarbazzarweb/helper/date_converter.dart';
import 'package:ansarbazzarweb/view/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/response/response_model.dart';

class SendMessageController extends GetxController implements GetxService {
  final SendRepo sendRepo;

  SendMessageController({@required this.sendRepo});

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<ResponseModel> sendMessageController(
      {String userId, String message}) async {
    _isLoading = true;
    update();
    Response response = await sendRepo.sendMessageRepo(message: message,userId: userId);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      print("response is ${response.body}");
      // sendRepo.saveUserToken(response.body['token']);
      // if(Get.find<SplashController>().configModel.customerVerification && response.body['is_phone_verified'] == 0) {
      //   // Get.to(()=>)
      // }else {
      //   authRepo.saveUserToken(response.body['token']);
      //   // await authRepo.updateToken();
      // }
      // responseModel = ResponseModel(true, '${response.body['is_phone_verified']}${response.body['token']}');
    } else {
      print("reponse reje${response.statusText}");
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
  // Future<SendMessageModel> sendFunction(SendMessageModel senderMessage) async {
  //   _isLoading = true;
  //   update();
  //   // Response response = await authRepo.registration(senderMessage);
  //   Response response = await sendRepo.sendRepoMessage(senderMessage);
  //   SendMessageModel sendMessageModel;
  //   if (response.statusCode == 200) {
  //     // if(!Get.find<SplashController>().configModel.customerVerification) {
  //     //   // SendRepo.saveUserToken(response.body["token"]);
  //     //   // await authRepo.updateToken();
  //     // }
  //     // sendMessageModel = sendMessageModel(true, response.body["token"]);
  //   } else {
  //     // sendMessageModel = sendMessageModel(false, response.statusText);
  //   }
  //   _isLoading = false;
  //   update();
  //   return sendMessageModel;
  // }


}
