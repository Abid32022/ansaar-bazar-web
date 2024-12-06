import 'package:ansarbazzarweb/controller/search_controller.dart';
import 'package:ansarbazzarweb/util/dimensions.dart';
import 'package:ansarbazzarweb/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../restaurant/product_detail_screen.dart';

class ItemView extends StatelessWidget {
  final bool isRestaurant;
  // dynamic deliveryfee;
  ItemView({@required this.isRestaurant,});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<SearchController>(builder: (searchController) {
        return SingleChildScrollView(
          child: Center(child: SizedBox(width: Dimensions.WEB_MAX_WIDTH,
              child:
              //     ProductView(
              //       // deliveryfee: ,
              //   isRestaurant: isRestaurant, products: searchController.searchProductList,
              //       restaurants: searchController.searchRestList,
              // )
              Container(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                height: 500,

                // color: Colors.red,
                child: searchController.searchProductList== null? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/image/dataNotFound.svg",color: Colors.black,height: 100,width: 100,),
                    ],
                  ),
                ) :  GridView.builder(

                  // itemCount: getUserNotificationData.isLoadingMore
                  //     ? data!.length + 1
                  //     : data!.length,
                  itemCount: searchController.searchProductList.length ?? 0,
                  //     :
                  // productcontroller.allproductList.length,
                  scrollDirection:
                  Axis.vertical,
                  padding: EdgeInsets.zero,
                  // controller: productcontroller.scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 8 / 7,
                    crossAxisCount: GetPlatform.isAndroid || GetPlatform.isIOS? 2:4,
                    crossAxisSpacing: 14,
                    mainAxisExtent: 230,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder:
                      (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => ProductDetailScreen(
                            deliveryCharges: [double.parse(searchController.searchProductList[index].delivery_price)],
                            // deliveryCharges: [double.parse(productcontroller.allproductList[index].delivery_price)],
                            product: searchController.searchProductList[index],
                            inRestaurantPage: true,
                            isCampaign: false));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 202,
                        width: 163,
                        decoration:
                        BoxDecoration(
                          color: Color(0xFF009f67),
                          borderRadius:
                          BorderRadius
                              .circular(
                              10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                  0.24),
                              spreadRadius: 0,
                              blurRadius: 23,
                              offset: Offset(
                                  0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Container(
                              height: 120,
                              width: double.infinity,
                              // color: Colors.black,
                              decoration:
                              BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image:
                                DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                  NetworkImage(
                                    "https://ansaarbazar.com/api/storage/app/public/product/${searchController.searchProductList[index].image}",
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(

                              searchController.searchProductList[index].name,
                              style:
                              TextStyle(
                                fontSize: 14,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                                fontWeight:
                                FontWeight
                                    .w500,
                                color: Colors
                                    .white,
                              ),
                              maxLines: 2,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              "${searchController.searchProductList[index].unit} , RS: ${searchController.searchProductList[index].price}",
                              style:
                              TextStyle(
                                fontSize: 13,
                                fontWeight:
                                FontWeight
                                    .w600,
                                // color: Color(0xff373491),
                                color: Colors.white,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                              ),
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .end,
                              children: [
                                Container(
                                  height: 36,
                                  width: 36,
                                  decoration:
                                  BoxDecoration(
                                    shape: BoxShape
                                        .circle,
                                    color: Colors.white,
                                    // color: Color(0xff189084),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors
                                        .black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          )),
        );
      }),
    );
  }
}
