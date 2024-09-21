import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shopping/data/data_model/product_model.dart';

import 'package:flutter/foundation.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  List<ProductModel> allProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAllProducts();
  }

  Future<void> _initializeAllProducts() async {
    setState(() => isLoading = true);
    try {
      allProducts = await getAllProducts();
    } catch (e) {
      print('Error fetching documents: $e');
    }
    setState(() => isLoading = false);
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Scaffold(
        appBar: AppBar(title: const Text('Products')),
        body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          itemCount: allProducts.length+1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildAddProductCard(context);
            }
            return buildProductCard(allProducts[index-1]);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCreateProductForm(context),
          tooltip: 'Add New Product',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildAddProductCard(BuildContext context) {
    return Card(
      color: Colors.orange[100],
      child: InkWell(
        onTap: () => _showCreateProductForm(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // border: Border.all(color: Colors.orange, width: 2),
                  color: HexColor("#fff1e7"),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8), // Adjust padding as needed
                  child: Icon(Icons.add, size: 70, color: Colors.orange),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductCard(ProductModel product) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height:70,
              child: StreamBuilder<String?>(
                stream: getDownloadURLStream(product.productPhotoUrl!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(height: 70,width:70, color: Colors.grey[300]);
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Image.network(snapshot.data!.toString(), fit: BoxFit.contain);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    product.productPrice!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateProductForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
        final TextEditingController _productNameController =
            TextEditingController();
        final TextEditingController _productPriceController =
            TextEditingController();
        final TextEditingController _descriptionController =
            TextEditingController();
        File? _pickedimage;
        Uint8List selectedImageBytes = Uint8List(8);
        DateTime? _createdDate;

        String imageUrl = '';
        String selectFile = '';

        Future<void> _pickImage() async {
          if (kIsWeb) {
            FilePickerResult? fileResult =
                await FilePicker.platform.pickFiles();
            if (fileResult != null) {
              setState(() {
                selectFile = fileResult.files.first.name;
              });
              selectedImageBytes = fileResult.files.first.bytes!;
            }
            print(selectFile);
          }
        }

        void _submitForm() async {
          UploadTask uploadTask;
          Reference ref = FirebaseStorage.instance
              .ref()
              .child("images")
              .child('/' + selectFile);
          final metadata = SettableMetadata(contentType: "image/jpeg");
          uploadTask = ref.putData(selectedImageBytes, metadata);
          await uploadTask.whenComplete(() => null);
          imageUrl = await ref.getDownloadURL();
          if (_formKey.currentState!.validate()) {
            // Create ProductModel
            final product = ProductModel(
              productName: _productNameController.text,
              productPrice: _productPriceController.text,
              description: _descriptionController.text,
              createdAt: _createdDate ?? DateTime.now(),
              productPhotoUrl: imageUrl,
            );

            // Save to Firestore
            await FirebaseFirestore.instance
                .collection('products')
                .add(product.toJson());
            getAllProducts();
            Navigator.pop(context); // Close the form
          }
        }

        return Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _productPriceController,
                decoration: InputDecoration(labelText: 'Product Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid price format';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.length < 10) {
                    return 'Please provide a longer description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  _pickImage();
                },
                child:
                    Text(_pickedimage != null ? 'Change Photo' : 'Add Photo'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}

loadingImage(ProductModel product) {
  return product.productPhotoUrl;
}

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to product details screen
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductCard(product: product)),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildProductInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(product.productPhotoUrl ?? ''),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          right: 8,
          child: Text(
            '${product.productPrice}',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.productName ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          // style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ID: ${product.productId ?? ''}',
                style: TextStyle(color: Colors.grey[600])),
            Text('${product.createdAt?.toIso8601String()}',
                style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        SizedBox(height: 8),
        Expanded(
            child: Text(product.description ?? '',
                maxLines: 3, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
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