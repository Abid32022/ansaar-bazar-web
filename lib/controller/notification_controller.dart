import 'package:ansarbazzarweb/data/api/api_checker.dart';
import 'package:ansarbazzarweb/data/model/response/notification_model.dart';
import 'package:ansarbazzarweb/data/repository/notification_repo.dart';
import 'package:ansarbazzarweb/helper/date_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepo notificationRepo;
  NotificationController({@required this.notificationRepo});

  List<NotificationModel> _notificationList;
  List<NotificationModel> get notificationList => _notificationList;

  Future<int> getNotificationList(bool reload) async {
    if(_notificationList == null || reload) {
      Response response = await notificationRepo.getNotificationList();
      if (response.statusCode == 200) {
        print("notification${response.body}");
        _notificationList = [];
        response.body.forEach((notification) => _notificationList.add(NotificationModel.fromJson(notification)));
        _notificationList.sort((a, b) {
          return DateConverter.isoStringToLocalDate(a.updatedAt).compareTo(DateConverter.isoStringToLocalDate(b.updatedAt));
        });
        Iterable iterable = _notificationList.reversed;
        _notificationList = iterable.toList();

      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
    return _notificationList.length;
  }

  void saveSeenNotificationCount(int count) {
    notificationRepo.saveSeenNotificationCount(count);
  }

  int getSeenNotificationCount() {
    return notificationRepo.getSeenNotificationCount();
  }

  void clearNotification() {
    _notificationList = null;
  }

}
