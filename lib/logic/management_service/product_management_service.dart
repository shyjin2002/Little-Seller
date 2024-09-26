import 'dart:typed_data';

import 'package:shopping/data/data_model/product_model.dart';
import 'package:shopping/logic/locator.dart';

class ProductManagementService {
    List<ProductModel> allProducts = [];
@override
    void init() {
    Locator.productDatabaseService.getAllProducts();// Call your init function here
  }

  Future<void> addProduct (String selectedFile, Uint8List selectedImageBytes,dynamic product,)async{
await Locator.productDatabaseService.addProductInFirestor(selectedFile,selectedImageBytes,product);
  }


  
}