
  import 'package:cloud_firestore/cloud_firestore.dart';

class SellerModel {
  final String? sellerName;
  final String? location;
  final String? sellerId;
  final DateTime? createdAt;
  final String? shopName;
  final String? mailId;
    final String? phoneNumber;
    final List<String>? customers;

  

  SellerModel({
    this.sellerName,
    this.location,
    this.sellerId,
    this.createdAt,
    this.shopName,
    this.mailId,
    this.phoneNumber,
    this.customers,
  });

  factory SellerModel.fromJson(Map<String, dynamic> data) {
    return SellerModel(
      sellerName: data["sellerName"],
      location: data["location"],
      sellerId: data["sellerId"],
      createdAt:( data["createdAt"]is Timestamp)
            ? data["createdAt"].toDate()
            : null,
      shopName: data["shopName"],
      phoneNumber: data["phoneNumber"],
      customers:data["customers"]
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sellerName':sellerName,
      'location':location,
      'sellerId': sellerId,
      'createdAt': createdAt,
      'shopName': shopName,
      'phoneNumber': phoneNumber,
      'customers':customers
      
      
    };
  }
}