import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping/data/data_model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDatabaseService {
  String imageUrl = '';
 List<ProductModel> allProducts = []; 
 void init() {
    // Initialize anything you need here
    getAllProducts();
  }
    

  Future<List<ProductModel>> getAllProducts() async {
    try {
      // Fetch all documents from the 'products' collection
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();

      // Create a list to store ProductModel instances
      List<ProductModel> products = [];

      // Iterate through each document and create ProductModel instances
      for (DocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Convert Timestamp to DateTime if present
        DateTime? createdAt =
            data['createdAt'] is Timestamp ? data['createdAt'].toDate() : null;

        // Create ProductModel instance
        ProductModel product = ProductModel(
          productName: data['productName'],
          productPrice: data['productPrice'],
          productId: data['productId'],
          createdAt: createdAt,
          productPhotoUrl: data['productPhotoUrl'],
          description: data['description'],
        );

        // Add the ProductModel to the list
        products.add(product);
        allProducts = products;
        
      }

      return products;
    } catch (e) {
      // print('Error fetching documents: $e');
      rethrow;
    }
  }


  Future<void> addProductInFirestor(String selectFile, Uint8List selectedImageBytes, ProductModel product) async {
          UploadTask uploadTask;
          Reference ref = FirebaseStorage.instance
              .ref()
              .child("images")
              .child('/' + selectFile);
          final metadata = SettableMetadata(contentType: "image/jpeg");
          uploadTask = ref.putData(selectedImageBytes, metadata);
          await uploadTask.whenComplete(() => null);
          imageUrl = await ref.getDownloadURL();
         final makingProduct = ProductModel(
              productName: product.productName,
              productPrice: product.productPrice,
              description: product.description,
              createdAt: product.createdAt,
              productPhotoUrl: imageUrl,
            );
          

            // Save to Firestore
            await FirebaseFirestore.instance
                .collection('products')
                .add(makingProduct.toJson());
            getAllProducts();
            // Close the form
          
        }

Stream<String?> getDownloadURLStream(String imagePath) async* {
  yield null;
  try {
    final ref = FirebaseStorage.instance.ref().child(imagePath);
    final url = await ref.getDownloadURL();
    yield url;
  } catch (e) {
    print('Error getting download URL: $e');
    yield null;
  }
}
}