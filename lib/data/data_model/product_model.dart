
  import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? productName;
  final String? productPrice;
  final String? productId;
  final DateTime? createdAt;
  final String? productPhotoUrl;
  final String? description;
  
  

  ProductModel({
    this.productName,
    this.productPrice,
    this.productId,
    this.createdAt,
    this.productPhotoUrl,
    this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> data) {
    return ProductModel(
      productName: data["productName"],
      productPrice: data["productPrice"],
      productId: data["productId"],
      createdAt:( data["createdAt"]is Timestamp)
            ? data["createdAt"].toDate()
            : null,
      productPhotoUrl: data["productPhotoUrl"],
      description: data["description"],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productName':productName,
      'productPrice':productPrice,
      'productId': productId,
      'createdAt': createdAt,
      'productPhotoUrl': productPhotoUrl,
      'description': description,
      
      
    };
  }
}