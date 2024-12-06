import 'dart:async';

import 'package:ansarbazzarweb/controller/location_controller.dart';
import 'package:ansarbazzarweb/data/api/api_client.dart';
import 'package:ansarbazzarweb/data/model/body/send_message_model.dart';
import 'package:ansarbazzarweb/data/model/body/signup_body.dart';
import 'package:ansarbazzarweb/data/model/body/social_log_in_body.dart';
import 'package:ansarbazzarweb/util/app_constants.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendRepo {
  final ApiClient apiClient;

  SendRepo({@required this.apiClient});

  bool _isLoading = false;


  bool get isLoading => _isLoading;

  Future<Response> sendMessageRepo({

    String message,
    String userId,
  }) async {
    print("repo is working now");
    return await apiClient.postData(AppConstants.sendMessage_URI,
      {
        "sender_id": '1',
        "content": message,
        // "password": password,
        // "confirm_password": confirmPassword
      },
      // headers: {
      //   'Content-Type':'multipart/form-data'
      // }
    );
  }



  // Future<String> _saveDeviceToken() async {
  //   String _deviceToken = '';
  //   if(!GetPlatform.isWeb) {
  //     // _deviceToken = await FirebaseMessaging.instance.getToken();
  //   }
  //   if (_deviceToken != null) {
  //     print('--------Device Token---------- '+_deviceToken);
  //   }
  //   return _deviceToken;
  // }

  //
  // // for  user token
  // Future<bool> saveUserToken(String token) async {
  //   apiClient.token = token;
  //   apiClient.updateHeader(token, null, sharedPreferences.getString(AppConstants.LANGUAGE_CODE));
  //   return await sharedPreferences.setString(AppConstants.TOKEN, token);
  // }
  //



  //
  // Future<bool> clearUserNumberAndPassword() async {
  //   await sharedPreferences.remove(AppConstants.USER_PASSWORD);
  //   await sharedPreferences.remove(AppConstants.USER_COUNTRY_CODE);
  //   return await sharedPreferences.remove(AppConstants.USER_NUMBER);
  // }
}
