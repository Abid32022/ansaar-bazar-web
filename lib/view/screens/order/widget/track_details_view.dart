import 'package:ansarbazzarweb/controller/splash_controller.dart';
import 'package:ansarbazzarweb/data/model/response/order_model.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/images.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/custom_divider.dart';
import 'package:ansarbazzarweb/view/base/custom_image.dart';
import 'package:ansarbazzarweb/view/base/custom_snackbar.dart';
import 'package:ansarbazzarweb/view/base/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../util/app_colors.dart';

class TrackDetailsView extends StatelessWidget {
  final OrderModel track;
  TrackDetailsView({@required this.track});

  @override
  Widget build(BuildContext context) {
    double _distance = 0;
    bool _takeAway = track.orderType == 'take_away';
    if (track.orderStatus == 'picked_up' && track.deliveryMan != null) {
      _distance = Geolocator.distanceBetween(
            double.parse(track.deliveryAddress.latitude),
            double.parse(track.deliveryAddress.longitude),
            double.parse(track.deliveryMan.lat ?? '0'),
            double.parse(track.deliveryMan.lng ?? '0'),
          ) /
          1000;
    }
    return Container(
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
        color: Colors.white,
      ),
      alignment: Alignment.center,
      child: (!_takeAway && track.deliveryMan == null)
          ? Padding(
              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: Text(
                'delivery_man_not_assigned'.tr,
                style: robotoMedium,
                textAlign: TextAlign.center,
              ),
            )
          : Column(children: [
              Text('trip_route'.tr, style: robotoMedium),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Row(children: [
                Expanded(
                  child: Text(
                    _takeAway
                        ? track.deliveryAddress?.address ?? 'N/A'
                        : track.deliveryMan?.location ?? 'N/A',
                    style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall,),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                // Expanded(
                //     child: Text(
                //   _takeAway
                //       ? track.deliveryAddress.address
                //       : track.deliveryMan.location,
                //   style: robotoRegular.copyWith(
                //       fontSize: Dimensions.fontSizeSmall),
                //   maxLines: 2,
                //   overflow: TextOverflow.ellipsis,
                // )),
                
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                SizedBox(
                    width: 100,
                    child: CustomDivider(
                        color:AppColors.primarycolor, height: 2)),
                Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:Color(0xFF009f67))),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Expanded(
                    child: Text(
                  _takeAway
                      ? track.restaurant.address
                      : track.deliveryAddress.address,
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeSmall),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              _takeAway
                  ? InkWell(
                      onTap: () async {
                        String url =
                            'https://www.google.com/maps/dir/?api=1&destination=${track.restaurant.latitude}'
                            ',${track.restaurant.longitude}&mode=d';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          showCustomSnackBar('unable_to_launch_google_map'.tr);
                        }
                      },
                      child: Column(children: [
                        Icon(Icons.directions,
                            size: 25, color:Color(0xFF009f67)),
                        Text(
                          'direction'.tr,
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall,
                              color: Theme.of(context).disabledColor),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      ]),
                    )
                  : Column(children: [
                      Image.asset(
                          Images.route,
                          height: 20,
                          width: 20,
                          color:Color(0xFF009f67)),
                      Text(
                        '$_distance ${'km'.tr}',
                        style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall,
                            color: Theme.of(context).disabledColor),
                      ),
                      SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    ]),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _takeAway ? 'restaurant'.tr : 'delivery_man'.tr,
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeSmall),
                  )),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Row(children: [
                ClipOval(
                    child: CustomImage(
                  image:
                      '${_takeAway ? Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl : Get.find<SplashController>().configModel.baseUrls.deliveryManImageUrl}/${_takeAway ? track.restaurant.logo : track.deliveryMan.image}',
                  height: 35,
                  width: 35,
                  fit: BoxFit.cover,
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(
                        _takeAway
                            ? track.restaurant.name
                            : '${track.deliveryMan.fName} ${track.deliveryMan.lName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeExtraSmall),
                      ),
                      RatingBar(
                        rating: _takeAway
                            ? track.restaurant.avgRating
                            : track.deliveryMan.avgRating,
                        size: 10,
                        ratingCount: _takeAway
                            ? track.restaurant.ratingCount
                            : track.deliveryMan.ratingCount,
                      ),
                    ])),
                InkWell(
                  onTap: () async {
                    if (await canLaunch(
                        'tel:${_takeAway ? track.restaurant.phone : track.deliveryMan.phone}')) {
                      launch(
                          'tel:${_takeAway ? track.restaurant.phone : track.deliveryMan.phone}');
                    } else {
                      showCustomSnackBar(
                          '${'can_not_launch'.tr} ${_takeAway ? track.restaurant.phone : track.deliveryMan.phone}');
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                        horizontal: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      color: Colors.green,
                    ),
                    child: Text(
                      'call'.tr,
                      style: robotoRegular.copyWith(
                          fontSize: Dimensions.fontSizeExtraSmall,
                          color: Theme.of(context).cardColor),
                    ),
                  ),
                ),
              ]),
            ]),
    );
  }
}
