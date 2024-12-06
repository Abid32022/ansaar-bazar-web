import 'package:ansarbazzarweb/controller/auth_controller.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:ansarbazzarweb/view/base/custom_app_bar.dart';
import 'package:ansarbazzarweb/view/base/not_logged_in_screen.dart';
import 'package:ansarbazzarweb/view/screens/favourite/widget/fav_item_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/app_colors.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'favourite'.tr, isBackButtonExist: false),
      body: Get.find<AuthController>().isLoggedIn()
          ? SafeArea(
              child: Column(children: [
                SizedBox(height: 20,),
                Expanded(child: FavItemView(isRestaurant: false)),
              // Container(
              //   width: Dimensions.WEB_MAX_WIDTH,
              //   color: Colors.white,
              //   child: TabBar(
              //     controller: _tabController,
              //     indicatorColor:AppColors.primarycolor,
              //
              //     indicatorWeight: 3,
              //
              //     labelColor:AppColors.primarycolor,
              //     unselectedLabelColor: Colors.grey,
              //
              //     unselectedLabelStyle: robotoRegular.copyWith(
              //         color: Colors.grey,
              //         fontSize: Dimensions.fontSizeSmall),
              //
              //     labelStyle: robotoBold.copyWith(
              //         fontSize: Dimensions.fontSizeSmall,
              //         color:Color(0xFF009f67)),
              //
              //     tabs: [
              //       Tab(text: 'food'.tr),
              //       Tab(text: 'restaurants'.tr),
              //
              //     ],
              //   ),
              // ),
              // Expanded(
              //     child: TabBarView(
              //   controller: _tabController,
              //   children: [
              //     FavItemView(isRestaurant: false),
              //     FavItemView(isRestaurant: true),
              //
              //   ],
              // )),
            ]))
          : NotLoggedInScreen(),
    );
  }
}
