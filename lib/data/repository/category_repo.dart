import 'package:ansarbazzarweb/data/api/api_client.dart';
import 'package:ansarbazzarweb/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class CategoryRepo {
  final ApiClient apiClient;
  CategoryRepo({@required this.apiClient});

  Future<Response> getCategoryList() async {
    return await apiClient.getData(AppConstants.CATEGORY_URI);
  }

  Future<Response> getSubCategoryList(String parentID) async {
    return await apiClient.getData('${AppConstants.SUB_CATEGORY_URI}$parentID');
  }

  Future<Response> getCategoryProductList(dynamic categoryID, int offset, String type) async {
    return await apiClient.getData('${AppConstants.CATEGORY_PRODUCT_URI}$categoryID?limit=10&offset=$offset&type=$type');
  }

  Future<Response> getCategoryRestaurantList(String categoryID, int offset, String type) async {
    return await apiClient.getData('${AppConstants.CATEGORY_RESTAURANT_URI}$categoryID?limit=10&offset=$offset&type=$type');
  }

  Future<Response> getSearchData(String query, String categoryID, bool isRestaurant, String type) async {
    return await apiClient.getData(
      '${AppConstants.SEARCH_URI}${isRestaurant ? 'restaurants' : 'products'}/search?name=$query&category_id=$categoryID&type=$type',
    );
  }

  Future<Response> saveUserInterests(List<int> interests) async {
    return await apiClient.postData(AppConstants.INTEREST_URI, {"interest": interests});
  }

}