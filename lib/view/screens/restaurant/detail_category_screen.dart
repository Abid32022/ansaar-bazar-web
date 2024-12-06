import 'package:ansarbazzarweb/util/app_colors.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../controller/category_controller.dart';
import '../../../controller/product_controller.dart';
import '../../../controller/restaurant_controller.dart';
import '../../../data/model/response/restaurant_model.dart';
import '../../../helper/responsive_helper.dart';
import '../../base/product_view.dart';
class DetailCategoryScreen extends StatefulWidget {
  String productname;
  DetailCategoryScreen(this.productname);

  @override
  State<DetailCategoryScreen> createState() => _DetailCategoryScreenState();
}

class _DetailCategoryScreenState extends State<DetailCategoryScreen> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<RestaurantController>(builder: (restController) {
        return GetBuilder<CategoryController>(builder: (categoryController) {
          Restaurant _restaurant;
          if (restController.restaurant != null &&
              restController.restaurant.name != null &&
              categoryController.categoryList != null) {
            _restaurant = restController.restaurant;
          }
          restController.setCategoryList();

          return (restController.restaurant != null && restController.restaurant.name != null && categoryController.categoryList != null)
          ? SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: 50,
                      color: AppColors.primarycolor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          GestureDetector(
                              onTap: (){
                                Get.back();
                              },
                              child: Icon(Icons.arrow_back,color: Colors.white,)),
                          Text("Grocery",style: robotoRegular.copyWith(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 20),),
                          SizedBox(),

                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(height: 20,),



                          SizedBox(height: 20,),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(widget.productname,style: robotoRegular.copyWith(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.black),),
                          //     Padding(
                          //       padding: const EdgeInsets.only(top: 5),
                          //       child: GestureDetector(
                          //           onTap: (){
                          //             Get.to(()=> ProductDetailScreen());
                          //           },
                          //           child: Text("See All",style: robotoRegular.copyWith(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xff373491)),)),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height: 20,),

                          ProductView(
                            isRestaurant: false,
                            restaurants: null,
                            products: restController.categoryList.length > 0
                                ? restController.restaurantProducts
                                : null,
                            inRestaurantPage: true,
                            type: restController.type,
                            onVegFilterTap: (String type) {
                              restController.getRestaurantProductList(restController.restaurant.id, 1, true);
                            },
                            padding: EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: ResponsiveHelper.isDesktop(context)
                                  ? Dimensions.PADDING_SIZE_SMALL
                                  : 0,
                            ),
                          ),
                        ],
                      ),
                    ),

                    //    GridView.builder(
                    //        itemCount: 8,
                    //        scrollDirection: Axis.vertical,
                    //        padding: EdgeInsets.zero,
                    //        physics: NeverScrollableScrollPhysics(),
                    //        shrinkWrap: true,
                    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //         childAspectRatio: 8/7,
                    //         crossAxisCount: 2,
                    //         crossAxisSpacing: 14,
                    //         mainAxisExtent: 200,
                    //         mainAxisSpacing: 10
                    //     ),
                    //     itemBuilder: (context,index){
                    //
                    //     return   Container(
                    //     padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL+6,vertical: Dimensions.PADDING_SIZE_SMALL+2),
                    //     height: 202,
                    //     width: 163,
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         boxShadow: [
                    //           BoxShadow(color: Colors.black.withOpacity(0.10),
                    //               spreadRadius: 0,
                    //               blurRadius: 23,
                    //               offset: Offset(0,1)
                    //           ),
                    //         ]
                    //     ),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Stack(
                    //           clipBehavior: Clip.none,
                    //           children: [
                    //             Image.asset("assets/image/img_7.png",height: 98,width: 112,),
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.end,
                    //               children: [
                    //                 Icon(Icons.favorite,color: Colors.red,size: 20,),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //         SizedBox(height: 8,),
                    //
                    //         Text("Bell Pepper Red",style: robotoRegular.copyWith(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),
                    //         Text("1kg, Rs.125",style: robotoRegular.copyWith(fontSize: 13,fontWeight: FontWeight.w600,color: Color(0xff373491)),),
                    //
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.end,
                    //           children: [
                    //             GestureDetector(
                    //               onTap: (){
                    //                 Get.to(()=> ProductDetailScreen());
                    //               },
                    //               child: Container(
                    //                 height: 36,
                    //                 width: 36,
                    //                 decoration: BoxDecoration(
                    //                     shape: BoxShape.circle,
                    //                     color: Color(0xff189084)
                    //                 ),
                    //                 child: Icon(Icons.add),
                    //               ),
                    //             ),
                    //           ],
                    //         )
                    //       ],
                    //     ),
                    //   );
                    // })

                  ],
                ),
              ),
            ),
          )
              : Center(child: CircularProgressIndicator());
        });
      }),



    );
  }
}
