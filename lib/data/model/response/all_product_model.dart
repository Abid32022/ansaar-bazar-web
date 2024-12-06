// class AllProductModel {
//   int total;
//   List<Products> product;
//
//   AllProductModel({this.total, this.product});
//
//   AllProductModel.fromJson(Map<String, dynamic> json) {
//     total = json['total'];
//     if (json['product'] != null) {
//       product = <Products>[];
//       json['product'].forEach((v) {
//         product.add(new Products.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['total'] = this.total;
//     if (this.product != null) {
//       data['product'] = this.product.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Products {
//   int id;
//   dynamic name;
//   dynamic description;
//   dynamic image;
//   dynamic categoryId;
//   dynamic categoryIds;
//   dynamic variations;
//   dynamic addOns;
//   dynamic attributes;
//   dynamic choiceOptions;
//   dynamic price;
//   dynamic tax;
//   dynamic taxType;
//   dynamic discount;
//   dynamic discountType;
//   dynamic availableTimeStarts;
//   dynamic availableTimeEnds;
//   dynamic veg;
//   dynamic status;
//   dynamic restaurantId;
//   dynamic createdAt;
//   dynamic updatedAt;
//   dynamic orderCount;
//   dynamic avgRating;
//   dynamic ratingCount;
//   dynamic rating;
//   dynamic kg;
//   dynamic unit;
//   dynamic quantity;
//   dynamic size;
//   List<dynamic> translations;
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
//         this.rating,
//         this.kg,
//         this.unit,
//         this.quantity,
//         this.size,
//         this.translations});
//
//   Products.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     description = json['description'];
//     image = json['image'];
//     categoryId = json['category_id'];
//     categoryIds = json['category_ids'];
//     variations = json['variations'];
//     addOns = json['add_ons'];
//     attributes = json['attributes'];
//     choiceOptions = json['choice_options'];
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
//     rating = json['rating'];
//     kg = json['kg'];
//     unit = json['unit'];
//     quantity = json['quantity'];
//     size = json['size'];
//     if (json['translations'] != null) {
//       translations = <Null>[];
//       json['translations'].forEach((v) {
//         // translations.add(new translations.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['description'] = this.description;
//     data['image'] = this.image;
//     data['category_id'] = this.categoryId;
//     data['category_ids'] = this.categoryIds;
//     data['variations'] = this.variations;
//     data['add_ons'] = this.addOns;
//     data['attributes'] = this.attributes;
//     data['choice_options'] = this.choiceOptions;
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
//     data['rating'] = this.rating;
//     data['kg'] = this.kg;
//     data['unit'] = this.unit;
//     data['quantity'] = this.quantity;
//     data['size'] = this.size;
//     if (this.translations != null) {
//       data['translations'] = this.translations.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
