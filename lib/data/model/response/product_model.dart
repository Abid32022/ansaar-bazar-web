class ProductModel {
  int _totalSize;
  String _limit;
  String _offset;
  List<Product> _products;

  ProductModel({
    int totalSize,
    String limit,
    String offset,
    List<Product> products,
  }) {
    this._totalSize = totalSize;
    this._limit = limit;
    this._offset = offset;
    this._products = products;
  }

  int get totalSize => _totalSize;
  String get limit => _limit;
  String get offset => _offset;
  List<Product> get products => _products;

  ProductModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'].toString();
    _offset = json['offset'].toString();
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this._totalSize;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._products != null) {
      data['products'] = this._products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int id;
  String name;
  String description;
  String image;
  String kg;
  int categoryId;
  List<CategoryIds> categoryIds;
  List<Variation> variations;
  List<AddOns> addOns;
  List<ChoiceOptions> choiceOptions;
  double price;
  double tax;
  double discount;
  String discountType;
  String availableTimeStarts;
  String availableTimeEnds;
  int restaurantId;
  String restaurantName;
  double restaurantDiscount;
  String restaurantOpeningTime;
  String restaurantClosingTime;
  bool scheduleOrder;
  double avgRating;
  int ratingCount;
  int veg;
  String unit; // Added parameter
  String quantity; // Added parameter
  String size; // Added parameter
  String delivery_price;

  Product({
    this.id,
    this.name,
    this.description,
    this.image,
    this.kg,
    this.categoryId,
    this.categoryIds,
    this.variations,
    this.addOns,
    this.choiceOptions,
    this.price,
    this.tax,
    this.discount,
    this.discountType,
    this.availableTimeStarts,
    this.availableTimeEnds,
    this.restaurantId,
    this.restaurantName,
    this.restaurantDiscount,
    this.restaurantOpeningTime,
    this.restaurantClosingTime,
    this.scheduleOrder,
    this.avgRating,
    this.ratingCount,
    this.veg,
    this.unit,
    this.quantity,
    this.size,
    this.delivery_price,


  });

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    kg = json['kg'];
    description = json['description'];
    image = json['image'];
    categoryId = json['category_id'];
    if (json['category_ids'] != null) {
      categoryIds = [];
      json['category_ids'].forEach((v) {
        categoryIds.add(new CategoryIds.fromJson(v));
      });
    }
    if (json['variations'] != null) {
      variations = [];
      json['variations'].forEach((v) {
        variations.add(new Variation.fromJson(v));
      });
    }
    if (json['add_ons'] != null) {
      addOns = [];
      json['add_ons'].forEach((v) {
        addOns.add(new AddOns.fromJson(v));
      });
    }
    if (json['choice_options'] != null) {
      choiceOptions = [];
      json['choice_options'].forEach((v) {
        choiceOptions.add(new ChoiceOptions.fromJson(v));
      });
    }
    price = json['price'].toDouble();
    tax = json['tax'] != null ? json['tax'].toDouble() : null;
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];
    availableTimeStarts = json['available_time_starts'];
    availableTimeEnds = json['available_time_ends'];
    restaurantId = json['restaurant_id'];
    restaurantName = json['restaurant_name'];
    restaurantDiscount = json['restaurant_discount'].toDouble();
    restaurantOpeningTime = json['restaurant_opening_time'];
    restaurantClosingTime = json['restaurant_closing_time'];
    scheduleOrder = json['schedule_order'];
    avgRating = json['avg_rating'].toDouble();
    ratingCount = json['rating_count'];
    veg = json['veg'];
    unit = json['unit']; // Added line
    quantity = json['quantity']; // Added line
    size = json['size']; // Added line
    delivery_price = json['delivery_price']; // Added line
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['kg'] = this.kg;
    data['description'] = this.description;
    data['image'] = this.image;
    data['category_id'] = this.categoryId;
    if (this.categoryIds != null) {
      data['category_ids'] = this.categoryIds.map((v) => v.toJson()).toList();
    }
    if (this.variations != null) {
      data['variations'] = this.variations.map((v) => v.toJson()).toList();
    }
    if (this.addOns != null) {
      data['add_ons'] = this.addOns.map((v) => v.toJson()).toList();
    }
    if (this.choiceOptions != null) {
      data['choice_options'] =
          this.choiceOptions.map((v) => v.toJson()).toList();
    }
    data['price'] = this.price;
    data['tax'] = this.tax;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    data['available_time_starts'] = this.availableTimeStarts;
    data['available_time_ends'] = this.availableTimeEnds;
    data['restaurant_id'] = this.restaurantId;
    data['restaurant_name'] = this.restaurantName;
    data['restaurant_discount'] = this.restaurantDiscount;
    data['schedule_order'] = this.scheduleOrder;
    data['avg_rating'] = this.avgRating;
    data['rating_count'] = this.ratingCount;
    data['veg'] = this.veg;

    data['unit'] = this.unit; // Added line
    data['quantity'] = this.quantity; // Added line
    data['size'] = this.size; // Added line
    data['delivery_price'] = this.delivery_price; // Added line

    return data;
  }
}

class CategoryIds {
  String id;

  CategoryIds({this.id});

  CategoryIds.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class Variation {
  String type;
  double price;

  Variation({this.type, this.price});

  Variation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['price'] = this.price;
    return data;
  }
}

class AddOns {
  int id;
  String name;
  double price;

  AddOns({this.id, this.name, this.price});

  AddOns.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}

class ChoiceOptions {
  String name;
  String title;
  List<String> options;

  ChoiceOptions({this.name, this.title, this.options});

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    title = json['title'];
    options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['title'] = this.title;
    data['options'] = this.options;
    return data;
  }
}


///
///
// class ProductModel {
//   int totalSize;
//   String limit;
//   String offset;
//   List<Products> products;
//
//   ProductModel({this.totalSize, this.limit, this.offset, this.products});
//
//   ProductModel.fromJson(Map<String, dynamic> json) {
//     totalSize = json['total_size'];
//     limit = json['limit'];
//     offset = json['offset'];
//     if (json['products'] != null) {
//       products = <Products>[];
//       json['products'].forEach((v) {
//         products.add(new Products.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['total_size'] = this.totalSize;
//     data['limit'] = this.limit;
//     data['offset'] = this.offset;
//     if (this.products != null) {
//       data['products'] = this.products.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Products {
//   int id;
//   String name;
//   String description;
//   String image;
//   int categoryId;
//   List<CategoryIds> categoryIds;
//   // List<CategoryIds> categoryIds;
//   //   List<Variation> variations;
//   //   List<AddOns> addOns;
//   //   List<ChoiceOptions> choiceOptions;
//
//   List<Null> variations;
//   List<Null> addOns;
//   List<Null> attributes;
//   List<Null> choiceOptions;
//
//   int price;
//   int tax;
//   String taxType;
//   int discount;
//   String discountType;
//   String availableTimeStarts;
//   String availableTimeEnds;
//   int veg;
//   int status;
//   int restaurantId;
//   String createdAt;
//   String updatedAt;
//   String orderCount;
//   int avgRating;
//   int ratingCount;
//   String kg;
//   String unit;
//   String quantity;
//   String size;
//   String restaurantName;
//   int restaurantDiscount;
//   String restaurantOpeningTime;
//   String restaurantClosingTime;
//   bool scheduleOrder;
//
//   Products(
//       {this.id,
//         this.name,
//         this.description,
//         this.image,
//         this.categoryId,
//         this.categoryIds,
//         this.variations,
//         this.addOns,
//         this.attributes,
//         this.choiceOptions,
//         this.price,
//         this.tax,
//         this.taxType,
//         this.discount,
//         this.discountType,
//         this.availableTimeStarts,
//         this.availableTimeEnds,
//         this.veg,
//         this.status,
//         this.restaurantId,
//         this.createdAt,
//         this.updatedAt,
//         this.orderCount,
//         this.avgRating,
//         this.ratingCount,
//         this.kg,
//         this.unit,
//         this.quantity,
//         this.size,
//         this.restaurantName,
//         this.restaurantDiscount,
//         this.restaurantOpeningTime,
//         this.restaurantClosingTime,
//         this.scheduleOrder});
//
//   Products.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     image = json['image'];
//     categoryId = json['category_id'];
//     if (json['category_ids'] != null) {
//       categoryIds = <CategoryIds>[];
//       json['category_ids'].forEach((v) {
//         categoryIds.add(new CategoryIds.fromJson(v));
//       });
//     }
//     if (json['variations'] != null) {
//       variations = <Null>[];
//       json['variations'].forEach((v) {
//         variations.add(new Null.fromJson(v));
//       });
//     }
//     if (json['add_ons'] != null) {
//       addOns = <Null>[];
//       json['add_ons'].forEach((v) {
//         addOns.add(new Null.fromJson(v));
//       });
//     }
//     if (json['attributes'] != null) {
//       attributes = <Null>[];
//       json['attributes'].forEach((v) {
//         attributes.add(new Null.fromJson(v));
//       });
//     }
//     if (json['choice_options'] != null) {
//       choiceOptions = <Null>[];
//       json['choice_options'].forEach((v) {
//         choiceOptions.add(new Null.fromJson(v));
//       });
//     }
//     price = json['price'];
//     tax = json['tax'];
//     taxType = json['tax_type'];
//     discount = json['discount'];
//     discountType = json['discount_type'];
//     availableTimeStarts = json['available_time_starts'];
//     availableTimeEnds = json['available_time_ends'];
//     veg = json['veg'];
//     status = json['status'];
//     restaurantId = json['restaurant_id'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//     orderCount = json['order_count'];
//     avgRating = json['avg_rating'];
//     ratingCount = json['rating_count'];
//     kg = json['kg'];
//     unit = json['unit'];
//     quantity = json['quantity'];
//     size = json['size'];
//     restaurantName = json['restaurant_name'];
//     restaurantDiscount = json['restaurant_discount'];
//     restaurantOpeningTime = json['restaurant_opening_time'];
//     restaurantClosingTime = json['restaurant_closing_time'];
//     scheduleOrder = json['schedule_order'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['description'] = this.description;
//     data['image'] = this.image;
//     data['category_id'] = this.categoryId;
//     if (this.categoryIds != null) {
//       data['category_ids'] = this.categoryIds.map((v) => v.toJson()).toList();
//     }
//     if (this.variations != null) {
//       data['variations'] = this.variations.map((v) => v.toJson()).toList();
//     }
//     if (this.addOns != null) {
//       data['add_ons'] = this.addOns.map((v) => v.toJson()).toList();
//     }
//     if (this.attributes != null) {
//       data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
//     }
//     if (this.choiceOptions != null) {
//       data['choice_options'] =
//           this.choiceOptions.map((v) => v.toJson()).toList();
//     }
//     data['price'] = this.price;
//     data['tax'] = this.tax;
//     data['tax_type'] = this.taxType;
//     data['discount'] = this.discount;
//     data['discount_type'] = this.discountType;
//     data['available_time_starts'] = this.availableTimeStarts;
//     data['available_time_ends'] = this.availableTimeEnds;
//     data['veg'] = this.veg;
//     data['status'] = this.status;
//     data['restaurant_id'] = this.restaurantId;
//     data['created_at'] = this.createdAt;
//     data['updated_at'] = this.updatedAt;
//     data['order_count'] = this.orderCount;
//     data['avg_rating'] = this.avgRating;
//     data['rating_count'] = this.ratingCount;
//     data['kg'] = this.kg;
//     data['unit'] = this.unit;
//     data['quantity'] = this.quantity;
//     data['size'] = this.size;
//     data['restaurant_name'] = this.restaurantName;
//     data['restaurant_discount'] = this.restaurantDiscount;
//     data['restaurant_opening_time'] = this.restaurantOpeningTime;
//     data['restaurant_closing_time'] = this.restaurantClosingTime;
//     data['schedule_order'] = this.scheduleOrder;
//     return data;
//   }
// }
//
// class CategoryIds {
//   String id;
//   int position;
//
//   CategoryIds({this.id, this.position});
//
//   CategoryIds.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     position = json['position'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['position'] = this.position;
//     return data;
//   }
// }
///
/// 
// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);
///with null safety///

// import 'dart:convert';
//
// ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));
//
// String productModelToJson(ProductModel data) => json.encode(data.toJson());
//
// class ProductModel {
//   int totalSize;
//   String limit;
//   String offset;
//   List<Product> products;
//
//   ProductModel({
//    this.totalSize,
//    this.limit,
//    this.offset,
//    this.products,
//   });
//
//   factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
//     totalSize: json["total_size"],
//     limit: json["limit"],
//     offset: json["offset"],
//     products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "total_size": totalSize,
//     "limit": limit,
//     "offset": offset,
//     "products": List<dynamic>.from(products.map((x) => x.toJson())),
//   };
// }
//
// class Product {
//   int id;
//   String name;
//   String description;
//   String image;
//   int categoryId;
//   List<CategoryId> categoryIds;
//   List<dynamic> variations;
//   List<dynamic> addOns;
//   List<dynamic> attributes;
//   List<dynamic> choiceOptions;
//   int price;
//   int tax;
//   Type taxType;
//   int discount;
//   Type discountType;
//   String availableTimeStarts;
//   String availableTimeEnds;
//   int veg;
//   int status;
//   int restaurantId;
//   DateTime createdAt;
//   DateTime updatedAt;
//   String orderCount;
//   int avgRating;
//   int ratingCount;
//   String kg;
//   String unit;
//   String quantity;
//   String size;
//   RestaurantName restaurantName;
//   int restaurantDiscount;
//   RestaurantOpeningTime restaurantOpeningTime;
//   RestaurantClosingTime restaurantClosingTime;
//   bool scheduleOrder;
//
//   Product({
//      this.id,
//      this.name,
//      this.description,
//      this.image,
//      this.categoryId,
//    this.categoryIds,
//    this.variations,
//    this.addOns,
//    this.attributes,
//    this.choiceOptions,
//    this.price,
//    this.tax,
//    this.taxType,
//    this.discount,
//    this.discountType,
//    this.availableTimeStarts,
//    this.availableTimeEnds,
//    this.veg,
//    this.status,
//    this.restaurantId,
//    this.createdAt,
//    this.updatedAt,
//    this.orderCount,
//    this.avgRating,
//    this.ratingCount,
//    this.kg,
//    this.unit,
//    this.quantity,
//    this.size,
//    this.restaurantName,
//    this.restaurantDiscount,
//    this.restaurantOpeningTime,
//    this.restaurantClosingTime,
//    this.scheduleOrder,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//     id: json["id"],
//     name: json["name"],
//     description: json["description"],
//     image: json["image"],
//     categoryId: json["category_id"],
//     categoryIds: List<CategoryId>.from(json["category_ids"].map((x) => CategoryId.fromJson(x))),
//     variations: List<dynamic>.from(json["variations"].map((x) => x)),
//     addOns: List<dynamic>.from(json["add_ons"].map((x) => x)),
//     attributes: List<dynamic>.from(json["attributes"].map((x) => x)),
//     choiceOptions: List<dynamic>.from(json["choice_options"].map((x) => x)),
//     price: json["price"],
//     tax: json["tax"],
//     taxType: typeValues.map[json["tax_type"]],
//     discount: json["discount"],
//     discountType: typeValues.map[json["discount_type"]],
//     availableTimeStarts: json["available_time_starts"],
//     availableTimeEnds: json["available_time_ends"],
//     veg: json["veg"],
//     status: json["status"],
//     restaurantId: json["restaurant_id"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     orderCount: json["order_count"],
//     avgRating: json["avg_rating"],
//     ratingCount: json["rating_count"],
//     kg: json["kg"],
//     unit: json["unit"],
//     quantity: json["quantity"],
//     size: json["size"],
//     restaurantName: restaurantNameValues.map[json["restaurant_name"]],
//     restaurantDiscount: json["restaurant_discount"],
//     restaurantOpeningTime: restaurantOpeningTimeValues.map[json["restaurant_opening_time"]],
//     restaurantClosingTime: restaurantClosingTimeValues.map[json["restaurant_closing_time"]],
//     scheduleOrder: json["schedule_order"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "description": description,
//     "image": image,
//     "category_id": categoryId,
//     "category_ids": List<dynamic>.from(categoryIds.map((x) => x.toJson())),
//     "variations": List<dynamic>.from(variations.map((x) => x)),
//     "add_ons": List<dynamic>.from(addOns.map((x) => x)),
//     "attributes": List<dynamic>.from(attributes.map((x) => x)),
//     "choice_options": List<dynamic>.from(choiceOptions.map((x) => x)),
//     "price": price,
//     "tax": tax,
//     "tax_type": typeValues.reverse[taxType],
//     "discount": discount,
//     "discount_type": typeValues.reverse[discountType],
//     "available_time_starts": availableTimeStarts,
//     "available_time_ends": availableTimeEnds,
//     "veg": veg,
//     "status": status,
//     "restaurant_id": restaurantId,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "order_count": orderCount,
//     "avg_rating": avgRating,
//     "rating_count": ratingCount,
//     "kg": kg,
//     "unit": unit,
//     "quantity": quantity,
//     "size": size,
//     "restaurant_name": restaurantNameValues.reverse[restaurantName],
//     "restaurant_discount": restaurantDiscount,
//     "restaurant_opening_time": restaurantOpeningTimeValues.reverse[restaurantOpeningTime],
//     "restaurant_closing_time": restaurantClosingTimeValues.reverse[restaurantClosingTime],
//     "schedule_order": scheduleOrder,
//   };
// }
//
// class CategoryId {
//   String id;
//   int position;
//
//   CategoryId({
//    this.id,
//    this.position,
//   });
//
//   factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
//     id: json["id"],
//     position: json["position"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "position": position,
//   };
// }
//
// enum Type {
//   PERCENT
// }
//
// final typeValues = EnumValues({
//   "percent": Type.PERCENT
// });
//
// enum RestaurantClosingTime {
//   THE_2300
// }
//
// final restaurantClosingTimeValues = EnumValues({
//   "23:00": RestaurantClosingTime.THE_2300
// });
//
// enum RestaurantName {
//   ANSAAR_BAZAR
// }
//
// final restaurantNameValues = EnumValues({
//   "Ansaar Bazar": RestaurantName.ANSAAR_BAZAR
// });
//
// enum RestaurantOpeningTime {
//   THE_1000
// }
//
// final restaurantOpeningTimeValues = EnumValues({
//   "10:00": RestaurantOpeningTime.THE_1000
// });
//
// class EnumValues<T> {
//   Map<String, T> map;
//    Map<T, String> reverseMap;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     reverseMap = map.map((k, v) => MapEntry(v, k));
//     return reverseMap;
//   }
// }
