
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/api/api_checker.dart';
import '../data/model/body/review_body.dart';
import '../data/model/response/all_product_model.dart';
import '../data/model/response/cart_model.dart';
import '../data/model/response/order_details_model.dart';
import '../data/model/response/product_model.dart';
import '../data/model/response/response_model.dart';
import '../data/repository/product_repo.dart';
import '../util/app_constants.dart';

class ProductController extends GetxController implements GetxService {
  final ProductRepo productRepo;
  ProductController({@required this.productRepo});

  TextEditingController searchController = TextEditingController();


  List<Product> _allproductList=[];
  // Latest products
  List<Product> _popularProductList;
  List<Product> _reviewedProductList;

  final scrollController = ScrollController();
  int _currentPage = 1;
  bool _isLoading = false;
  List<int> _variationIndex;
  int _quantity = 1;
  List<bool> _addOnActiveList = [];
  List<int> _addOnQtyList = [];
  String _popularType = 'all';
  String _reviewedType = 'all';
  static List<String> _productTypeList = ['all', 'veg', 'non_veg'];

  List<Product> get popularProductList => _popularProductList;
  List<Product> get reviewedProductList => _reviewedProductList;

  List<Product> get allproductList => _allproductList;

  bool get isLoading => _isLoading;
  List<int> get variationIndex => _variationIndex;
  int get quantity => _quantity;
  List<bool> get addOnActiveList => _addOnActiveList;
  List<int> get addOnQtyList => _addOnQtyList;
  String get popularType => _popularType;
  String get reviewType => _reviewedType;
  List<String> get productTypeList => _productTypeList;

  bool isLoadingMore = false;

  void loadingFunction(){
    _isLoading =! _isLoading;
    update();
  }

  Future<void> updateValue({bool load}) async {
    isLoadingMore = load;
    update();
  }

  Future<void> getPopularProductList(bool reload, String type, bool notify) async {
    _popularType = type;
    if (reload) {
      _popularProductList = null;
    }
    if (notify) {
      update();
    }
    if (_popularProductList == null || reload) {

      Response response = await productRepo.getPopularProductList(type);
      if (response.statusCode == 200) {
        if(kDebugMode){
          print("this is popular product ${response.body}");
        }

        _popularProductList = [];
        _popularProductList
            .addAll(ProductModel.fromJson(response.body).products);
        if(kDebugMode){
          print("this is popular product ${_popularProductList[0].description}");
        }

        _isLoading = false;
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  Future<void> getAllProductList() async {
    _isLoading = true;
    Response response = await productRepo.allProduct(offset: _currentPage);

    if (response.statusCode == 200) {
      List<Product> newProducts =
          ProductModel.fromJson(response.body).products;

      if (_currentPage == 1) {
        _allproductList.clear();
      }

      _allproductList.addAll(newProducts);

      _currentPage++;

      _isLoading = false;
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }
  void getListenerPaginationCall() {
    scrollController.addListener(getListenerPaginationData);
  }
  // Future<void> getAllProductList() async {
  //
  //   // _popularType = type;
  //   _isLoading = true;
  //   Response response = await productRepo.allProduct(offset: AppConstants.productPagination);
  //   print('pagination is ${AppConstants.productPagination}');
  //   if (response.statusCode == 200) {
  //     if(kDebugMode){
  //       print("this is ALl product ${response.body}");
  //     }
  //
  //     _allproductList = [];
  //     _allproductList.addAll(ProductModel.fromJson(response.body).products);
  //     if(kDebugMode){
  //       print("this is all product ${_allproductList.length}");
  //     }
  //
  //     _isLoading = false;
  //   } else {
  //     ApiChecker.checkApi(response);
  //     if(kDebugMode){
  //       print("this is ALl product ${response.body}");
  //     }
  //
  //   }
  //   update();
  //
  // }
  //Pagination Call function
  // void getListenerPaginationCall() {
  //   scrollController.addListener(getListenerPaginationData);
  // }

  //Pagination get data function
  Future<void> getListenerPaginationData() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      updateValue(load: true);

      await getAllProductList();

      updateValue(load: false);
    }
  }

  Future<void> getReviewedProductList(
      bool reload, String type, bool notify) async {
    _reviewedType = type;
    if (reload) {
      _reviewedProductList = null;
    }
    if (notify) {
      update();
    }
    if (_reviewedProductList == null || reload) {
      Response response = await productRepo.getReviewedProductList(type);
      if (response.statusCode == 200) {
        _reviewedProductList = [];
        _reviewedProductList
            .addAll(ProductModel.fromJson(response.body).products);
        _isLoading = false;
      } else {
        ApiChecker.checkApi(response);
      }
      update();
    }
  }

  void showBottomLoader() {
    _isLoading = true;
    update();
  }

  void initData(Product product, CartModel cart) {
    _variationIndex = [];
    _addOnQtyList = [];
    _addOnActiveList = [];
    if (cart != null) {
      _quantity = cart.quantity;
      List<String> _variationTypes = [];
      if (cart.variation.length != null &&
          cart.variation.length > 0 &&
          cart.variation[0].type != null) {
        _variationTypes.addAll(cart.variation[0].type.split('-'));
      }
      int _varIndex = 0;
      product.choiceOptions.forEach((choiceOption) {
        for (int index = 0; index < choiceOption.options.length; index++) {
          if (choiceOption.options[index].trim().replaceAll(' ', '') ==
              _variationTypes[_varIndex].trim()) {
            _variationIndex.add(index);
            break;
          }
        }
        _varIndex++;
      });
      List<int> _addOnIdList = [];
      cart.addOnIds.forEach((addOnId) => _addOnIdList.add(addOnId.id));
      product.addOns.forEach((addOn) {
        if (_addOnIdList.contains(addOn.id)) {
          _addOnActiveList.add(true);
          _addOnQtyList
              .add(cart.addOnIds[_addOnIdList.indexOf(addOn.id)].quantity);
        } else {
          _addOnActiveList.add(false);
          _addOnQtyList.add(1);
        }
      });
    } else {
      _quantity = 1;
      product.choiceOptions.forEach((element) => _variationIndex.add(0));
      product.addOns.forEach((addOn) {
        _addOnActiveList.add(false);
        _addOnQtyList.add(1);
      });
    }
  }

  void setAddOnQuantity(bool isIncrement, int index) {
    if (isIncrement) {
      _addOnQtyList[index] = _addOnQtyList[index] + 1;
    } else {
      _addOnQtyList[index] = _addOnQtyList[index] - 1;
    }
    update();
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = _quantity + 1;
    } else {
      _quantity = _quantity - 1;
    }
    update();
  }

  void setCartVariationIndex(int index, int i) {
    _variationIndex[index] = i;
    update();
  }

  void addAddOn(bool isAdd, int index) {
    _addOnActiveList[index] = isAdd;
    update();
  }

  List<int> _ratingList = [];
  List<String> _reviewList = [];
  List<bool> _loadingList = [];
  List<bool> _submitList = [];
  int _deliveryManRating = 0;

  List<int> get ratingList => _ratingList;
  List<String> get reviewList => _reviewList;
  List<bool> get loadingList => _loadingList;
  List<bool> get submitList => _submitList;
  int get deliveryManRating => _deliveryManRating;

  void initRatingData(List<OrderDetailsModel> orderDetailsList) {
    _ratingList = [];
    _reviewList = [];
    _loadingList = [];
    _submitList = [];
    _deliveryManRating = 0;
    orderDetailsList.forEach((orderDetails) {
      _ratingList.add(0);
      _reviewList.add('');
      _loadingList.add(false);
      _submitList.add(false);
    });
  }

  void setRating(int index, int rate) {
    _ratingList[index] = rate;
    update();
  }

  void setReview(int index, String review) {
    _reviewList[index] = review;
  }

  void setDeliveryManRating(int rate) {
    _deliveryManRating = rate;
    update();
  }

  Future<ResponseModel> submitReview(int index, ReviewBody reviewBody) async {
    _loadingList[index] = true;
    update();

    Response response = await productRepo.submitReview(reviewBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      _submitList[index] = true;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      update();
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _loadingList[index] = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> searchProduct(String value) async {
    Response response = await productRepo.searchProduct(value);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }

  Future<ResponseModel> submitDeliveryManReview(ReviewBody reviewBody) async {
    _isLoading = true;
    update();
    Response response = await productRepo.submitDeliveryManReview(reviewBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      _deliveryManRating = 0;
      responseModel = ResponseModel(true, 'Review submitted successfully');
      update();
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }
}
