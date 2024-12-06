// import 'package:efood_multivendor/data/model/response/cart_model.dart';
// import 'package:efood_multivendor/data/repository/cart_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/response/cart_model.dart';
import '../data/repository/cart_repo.dart';

class CartController extends GetxController implements GetxService {
  final CartRepo cartRepo;
  CartController({@required this.cartRepo});

  List<CartModel> _cartList = [];
  double _amount = 0.0;

  List<CartModel> get cartList => _cartList;
  List<double> _deliveryFeeList = [];
  List<String>_sizeList = [];
  double get amount => _amount;
  List<double> get deliveryFeeList => _deliveryFeeList; // Getter for delivery fee list
  List<String> get sizeList => _sizeList; // Getter for delivery fee list


  void getCartData() {

    _cartList = [];
    _deliveryFeeList = []; // Clear the delivery fee list
    _sizeList = []; // Clear the delivery fee list
    _cartList.addAll(cartRepo.getCartList());
    _cartList.forEach((cart) {
      _amount = _amount + (cart.discountedPrice * cart.quantity);
      _deliveryFeeList.addAll(cart.deliveryFees); // Add delivery fees to the list
      // _sizeList.addAll(cart.sizeList); // Add delivery fees to the list
      if (cart.sizeList != null) {
        _sizeList.addAll(cart.sizeList);
      }

      if(kDebugMode){
        print("DDDDDDD ${cart.deliveryFees}");
        print("cart size is  ${cart.sizeList}");
      }
    });
  }

  // void getCartData() {
  //   _cartList = [];
  //   _cartList.addAll(cartRepo.getCartList());
  //   _cartList.forEach((cart) {
  //     _amount = _amount + (cart.discountedPrice * cart.quantity);
  //   });
  // }

  // void addToCart(CartModel cartModel, int index) {
  //   if(index != null) {
  //     _amount = _amount - (_cartList[index].discountedPrice * _cartList[index].quantity);
  //     _cartList.replaceRange(index, index+1, [cartModel]);
  //   }else {
  //     _cartList.add(cartModel);
  //   }
  //   _amount = _amount + (cartModel.discountedPrice * cartModel.quantity);
  //   cartRepo.addToCartList(_cartList);
  //   update();
  // }


  // void addToCart(CartModel cartModel, int index,double deliveryfee) {
  //   if(index != null) {
  //     _amount = _amount - (_cartList[index].discountedPrice * _cartList[index].quantity);
  //     _cartList.replaceRange(index, index+1, [cartModel]);
  //   } else {
  //     // Add delivery fees to the cart model
  //     // cartModel.addDeliveryFeeList(deliveryFeeList);
  //     cartModel.addDeliveryFee(deliveryfee);
  //     _cartList.add(cartModel);
  //   }
  //
  //   _amount = _amount + (cartModel.discountedPrice * cartModel.quantity);
  //   cartRepo.addToCartList(_cartList);
  //   update();
  // }

  void addToCart({CartModel cartModel, int index, double deliveryfee, String sizes}) {
    if (index != null) {
      _amount -= (_cartList[index].discountedPrice * _cartList[index].quantity);
      _cartList.replaceRange(index, index + 1, [cartModel]);
    } else {
      cartModel.addDeliveryFee(deliveryfee); // Corrected method name
      cartModel.addSize(sizes);

      _cartList.add(cartModel);
      _deliveryFeeList.add(deliveryfee);
      _sizeList.add(sizes);
      // _sizeList.add(sizeList.join(', ')); // Join all strings in sizeList with a comma separator

      print('Delivery Fees for Cart Model: ${cartModel.deliveryFees}');
      print('Size list is : ${cartModel.sizeList}');
    }
    _amount += (cartModel.discountedPrice * cartModel.quantity);
    cartRepo.addToCartList(_cartList);
    update();
  }


  void setQuantity(bool isIncrement, CartModel cart) {
    int index = _cartList.indexOf(cart);
    if (isIncrement) {
      _cartList[index].quantity = _cartList[index].quantity + 1;
      _amount = _amount + _cartList[index].discountedPrice;
    } else {
      _cartList[index].quantity = _cartList[index].quantity - 1;
      _amount = _amount - _cartList[index].discountedPrice;
    }
    cartRepo.addToCartList(_cartList);
    update();
  }

  void removeFromCart(int index) {
    _amount = _amount - (_cartList[index].discountedPrice * _cartList[index].quantity);
    _cartList.removeAt(index);
    _sizeList.removeAt(index);
    // _sizeList = [];

    // sizeList.removeAt(index);
    cartRepo.addToCartList(_cartList);
    // cartRepo.addToCartList(_si);
    update();
  }

  void removeAddOn(int index, int addOnIndex) {
    _cartList[index].addOnIds.removeAt(addOnIndex);
    cartRepo.addToCartList(_cartList);
    update();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    cartRepo.addToCartList(_cartList);
    update();
  }

  bool isExistInCart(CartModel cartModel, bool isUpdate, int cartIndex) {
    for(int index=0; index<_cartList.length; index++) {
      if(_cartList[index].product.id == cartModel.product.id && (_cartList[index].variation.length > 0 ? _cartList[index].variation[0].type
          == cartModel.variation[0].type : true)) {
        if((isUpdate && index == cartIndex)) {
          return false;
        }else {
          return true;
        }
      }
    }
    return false;
  }

  bool existAnotherRestaurantProduct(int restaurantID) {
    for(CartModel cartModel in _cartList) {
      if(cartModel.product.restaurantId != restaurantID) {
        return true;
      }
    }
    return false;
  }

  void removeAllAndAddToCart(CartModel cartModel) {
    _cartList = [];
    _cartList.add(cartModel);
    _amount = cartModel.discountedPrice * cartModel.quantity;
    cartRepo.addToCartList(_cartList);
    update();
  }


}
