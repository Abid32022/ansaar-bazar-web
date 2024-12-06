import 'package:ansarbazzarweb/controller/search_controller.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/screens/search/widget/item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/app_colors.dart';

class SearchResultWidget extends StatefulWidget {
  final String searchText;
  SearchResultWidget({@required this.searchText});

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    // _tabController = TabController(length: 1, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

      GetBuilder<SearchController>(builder: (searchController) {
        bool _isNull = true;
        int _length = 0;
        if(searchController.isRestaurant) {
          _isNull = searchController.searchRestList == null;
          if(!_isNull) {
            _length = searchController.searchRestList.length;

          }
        }else {
          _isNull = searchController.searchProductList == null;
          if(!_isNull) {
            _length = searchController.searchProductList.length;
          }
        }
        return _isNull ? SizedBox() : Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH, child: Padding(
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          child: Row(children: [
            Text(
              _length.toString(),
              style: robotoBold.copyWith(color:AppColors.primarycolor ,fontSize: Dimensions.fontSizeSmall),
            ),
            SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

              Text(
              'results_found'.tr,
              style: robotoRegular.copyWith(color: Colors.black, fontSize: Dimensions.fontSizeSmall),
            ),
          ]),
        )));
      }),
      Expanded(child: ItemView(isRestaurant: false)),
      // Center(child: Container(
      //   width: Dimensions.WEB_MAX_WIDTH,
      //   color: Theme.of(context).cardColor,
      //   child: TabBar(
      //     controller: _tabController,
      //     indicatorColor:AppColors.primarycolor
      //     ,indicatorWeight: 3,
      //     labelColor:AppColors.primarycolor
      //     ,unselectedLabelColor: Theme.of(context).disabledColor,
      //     unselectedLabelStyle: robotoRegular.copyWith(color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeSmall),
      //     labelStyle: robotoBold.copyWith(fontSize: Dimensions.fontSizeSmall, color:Color(0xFF009f67)),
      //     tabs: [
      //       Tab(text: 'food'.tr),
      //       // Tab(text: 'restaurants'.tr),
      //     ],
      //   ),
      // )),
      //
      // Expanded(
      //     child: NotificationListener(
      //       onNotification: (scrollNotification) {
      //         if (scrollNotification is ScrollEndNotification) {
      //           Get.find<SearchController>().setRestaurant(_tabController.index == 1);
      //           Get.find<SearchController>().searchData(widget.searchText);
      //         }
      //         return false;
      //       },
      //       child: TabBarView(
      //         controller: _tabController,
      //         children: [
      //           ItemView(isRestaurant: false),
      //           ItemView(isRestaurant: true),
      //         ],
      //       ),
      //     )),

    ]);
  }
}

