// import 'package:efood_multivendor/data/model/response/product_model.dart';

import 'package:ansarbazzarweb/data/model/response/product_model.dart';

class CartModel {
  double _price;
  double _discountedPrice;
  List<Variation> _variation;
  double _discountAmount;
  int _quantity;
  List<AddOn> _addOnIds;
  List<AddOns> _addOns;
  bool _isCampaign;
  Product _product;
  List<double> _deliveryFees;
  List<String> _sizelist;

  CartModel(
      double price,
      double discountedPrice,
      List<Variation> variation,
      double discountAmount,
      int quantity,
      List<AddOn> addOnIds,
      List<AddOns> addOns,
      bool isCampaign,
      Product product,
      List<double>deliveryfees,
      List<String> sizelist,
      ) {
    this._price = price;
    this._discountedPrice = discountedPrice;
    this._variation = variation;
    this._discountAmount = discountAmount;
    this._quantity = quantity;
    this._addOnIds = addOnIds;
    this._addOns = addOns;
    this._isCampaign = isCampaign;
    this._product = product;
    this._deliveryFees = [];
    this._sizelist = [];
  }

  double get price => _price;
  double get discountedPrice => _discountedPrice;
  List<Variation> get variation => _variation;
  double get discountAmount => _discountAmount;
  int get quantity => _quantity;
  set quantity(int qty) => _quantity = qty;
  List<AddOn> get addOnIds => _addOnIds;
  List<AddOns> get addOns => _addOns;
  bool get isCampaign => _isCampaign;
  Product get product => _product;
  List<double> get deliveryFees => _deliveryFees;
  List<String> get sizeList => _sizelist;

  void addDeliveryFee(double fee) {
    _deliveryFees.add(fee);
  }

  void addSize(String size) {
    _sizelist.add(size);
  }

  void removeDeliveryFee(double fee) {
    _deliveryFees.remove(fee);
  }

  void clearDeliveryFees() {
    _deliveryFees.clear();
  }

  CartModel.fromJson(Map<String, dynamic> json) {
    _price = json['price'].toDouble();
    _discountedPrice = json['discounted_price'].toDouble();
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation.add(new Variation.fromJson(v));
      });
    }
    _discountAmount = json['discount_amount'].toDouble();
    _quantity = json['quantity'];

    if (json['add_on_ids'] != null) {
      _addOnIds = [];
      json['add_on_ids'].forEach((v) {
        _addOnIds.add(new AddOn.fromJson(v));
      });
    }
    if (json['add_ons'] != null) {
      _addOns = [];
      json['add_ons'].forEach((v) {
        _addOns.add(new AddOns.fromJson(v));
      });
    }
    _isCampaign = json['is_campaign'];
    if (json['product'] != null) {
      _product = Product.fromJson(json['product']);
    }
    if (json['delivery_fees'] != null) {
      _deliveryFees = List<double>.from(json['delivery_fees'].map((x) => x.toDouble()));
    }
    if (json['size_list'] != null) {
      _sizelist = List<String>.from(json['size_list'].map((x) => x.toString()));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['price'] = this._price;
    data['discounted_price'] = this._discountedPrice;
    if (this._variation != null) {
      data['variation'] = this._variation.map((v) => v.toJson()).toList();
    }
    data['discount_amount'] = this._discountAmount;
    data['quantity'] = this._quantity;

    if (this._addOnIds != null) {
      data['add_on_ids'] = this._addOnIds.map((v) => v.toJson()).toList();
    }
    if (this._addOns != null) {
      data['add_ons'] = this._addOns.map((v) => v.toJson()).toList();
    }
    data['is_campaign'] = this._isCampaign;
    data['product'] = this._product.toJson();
    data['delivery_fees'] = _deliveryFees;
    data['size_list'] = _sizelist;
    return data;
  }
}

class AddOn {
  int _id;
  int _quantity;

  AddOn({int id, int quantity}) {
    this._id = id;
    this._quantity = quantity;
  }

  int get id => _id;
  int get quantity => _quantity;

  AddOn.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this._id;
    data['quantity'] = this._quantity;
    return data;
  }
}
