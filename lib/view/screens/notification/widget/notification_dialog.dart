import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/data/model/response/notification_model.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/app_colors.dart';

class NotificationDialog extends StatelessWidget {
  final NotificationModel notificationModel;
  NotificationDialog({@required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Dimensions.RADIUS_SMALL))),
      insetPadding: EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child:  SizedBox(
        width: 600,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),

              Container(
                height: 150, width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL), color:Color(0xFF009f67).withOpacity(0.20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  child: CustomImage(
                    image: '${Get.find<SplashController>().configModel.baseUrls.notificationImageUrl}/${notificationModel.data.image}',
                    height: 150, width: MediaQuery.of(context).size.width, fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                child: Text(
                  notificationModel.data.title,
                  textAlign: TextAlign.center,
                  style: robotoMedium.copyWith(
                    color:AppColors.primarycolor,
                    fontSize: Dimensions.fontSizeLarge,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Text(
                  notificationModel.data.description,
                  textAlign: TextAlign.center,
                  style: robotoRegular.copyWith(
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
