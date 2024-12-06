import 'package:ansarbazzarweb/data/api/api_client.dart';
import 'package:ansarbazzarweb/data/model/body/review_body.dart';
import 'package:ansarbazzarweb/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductRepo extends GetxService {
  final ApiClient apiClient;
  ProductRepo({@required this.apiClient});

  Future<Response> getPopularProductList(String type) async {
    return await apiClient.getData('${AppConstants.POPULAR_PRODUCT_URI}?type=$type');
  }

  Future<Response> getReviewedProductList(String type) async {
    return await apiClient
        .getData('${AppConstants.REVIEWED_PRODUCT_URI}?type=$type');
  }

  // Future<Response> allProduct() async {
  //   return await apiClient.getData('${AppConstants.All_PRODUCT_API}');
  // }
  Future<Response> allProduct({int offset = 1}) async {
    return await apiClient.getData('${AppConstants.All_PRODUCT_API}?offset=$offset&limit=10');
  }

  Future<Response> submitReview(ReviewBody reviewBody) async {
    return await apiClient.postData(
        AppConstants.REVIEW_URI, reviewBody.toJson());
  }

  Future<Response> searchProduct(String name) async {
    return await apiClient.postData(AppConstants.PRODUCT_SEARCH_URI1, name);
  }

  Future<Response> submitDeliveryManReview(ReviewBody reviewBody) async {
    return await apiClient.postData(
        AppConstants.DELIVER_MAN_REVIEW_URI, reviewBody.toJson());
  }
}
