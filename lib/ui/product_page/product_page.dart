import 'dart:io';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:shopping/data/data_model/product_model.dart';
import 'package:flutter/foundation.dart';
import 'package:shopping/logic/locator.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<ProductModel> allProducts =Locator.productManagementService.allProducts;
  bool isLoading = true;
  String? _pickedimage;
  bool hasImageBeenSelected = false;
  Uint8List selectedImageBytes = Uint8List(8);

  DateTime? _createdDate;

  
  String selectFile = '';

 

  

  

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
          itemCount: allProducts.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildAddProductCard(context);
            }
            return buildProductCard(allProducts[index - 1]);
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
              height: 70,
              child: StreamBuilder<String?>(
                stream: Locator.productDatabaseService.getDownloadURLStream(product.productPhotoUrl!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                        height: 70, width: 70, color: Colors.grey[300]);
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return Image.network(snapshot.data!.toString(),
                        fit: BoxFit.contain);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.productPrice!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.description!,
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
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
      scrollControlDisabledMaxHeightRatio: 200,
      context: context,
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
        final TextEditingController _productNameController =
            TextEditingController();
        final TextEditingController _productPriceController =
            TextEditingController();
        final TextEditingController _descriptionController =
            TextEditingController();

        Future<bool> _pickImage() async {
          if (kIsWeb) {
            try {
              FilePickerResult? fileResult =
                  await FilePicker.platform.pickFiles();
              if (fileResult != null && fileResult.files.isNotEmpty) {
                setState(() {
                  selectFile = fileResult.files.first.name;
                  selectedImageBytes = fileResult.files.first.bytes!;
                  hasImageBeenSelected = true;
                });
                print('Selected file: ${selectFile}');
                return true;
              } else {
                print('No file selected');
                return false;
              }
            } catch (e) {
              print('Error picking image: $e');
              return false;
            }
          }
          return false;
        }

        Widget _buildImagePreview() {
          print('hasImageBeenSelected: $hasImageBeenSelected');
          print('_pickedImage: $_pickedimage');

          return Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: hasImageBeenSelected
                  ? Image.file(File(_pickedimage!))
                  : Icon(Icons.add_photo_alternate, color: Colors.grey),
            ),
          );
        }

        void _submitForm() async {
          if (_formKey.currentState!.validate()) {
            // Create ProductModel
            final product = ProductModel(
              productName: _productNameController.text,
              productPrice: _productPriceController.text,
              description: _descriptionController.text,
              createdAt: _createdDate ?? DateTime.now(),
              // productPhotoUrl: imageUrl,
            );

            // Save to Firestore
            Locator.productManagementService.addProduct(selectFile, selectedImageBytes, product);
            Navigator.pop(context); // Close the form
          }
        }

        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setModelsState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                child: Column(
                  children: [
                    const Text(
                      "Add Product",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _productNameController,
                              decoration: InputDecoration(
                                labelText: 'Product Name',
                                labelStyle: const TextStyle(
                                    color: Color.fromRGBO(239, 142, 53, 1),
                                    fontSize: 15),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(239, 142, 53, 1),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromRGBO(239, 143, 53, 0.664),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a product name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _productPriceController,
                              decoration: InputDecoration(
                                labelText: 'Price',
                                labelStyle: const TextStyle(
                                    color: Color.fromRGBO(239, 142, 53, 1),
                                    fontSize: 15),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(239, 142, 53, 1),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromRGBO(239, 143, 53, 0.664),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
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
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                labelStyle: const TextStyle(
                                    color: Color.fromRGBO(239, 142, 53, 1),
                                    fontSize: 15),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(239, 142, 53, 1),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromRGBO(239, 143, 53, 0.664),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.red, width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 10) {
                                  return 'Please provide a longer description';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Column(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: hasImageBeenSelected
                                        ? Image.memory(selectedImageBytes)
                                        : Icon(Icons.add_photo_alternate,
                                            color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () async {
                                    bool imageSelected = await _pickImage();
                                    if (imageSelected) {
                                      print("working setstate");
                                      setModelsState(() {
                                        hasImageBeenSelected = true;
                                        _pickedimage = selectFile;
                                      });
                                      print('Selected file: ${selectFile}');
                                      print(
                                          hasImageBeenSelected); // Use setModalState instead of setState
                                    }
                                  },
                                  child: Text(_pickedimage != null
                                      ? 'Change Photo'
                                      : 'Add Photo'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _submitForm,
                              child: const Text('Submit'),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  void setImage(String file, Uint8List bytes) {
    setState(() {
      selectFile = file;
      selectedImageBytes = bytes;
      hasImageBeenSelected = true;
    });
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
            borderRadius: const BorderRadius.only(
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
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
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
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('ID: ${product.productId ?? ''}',
                style: TextStyle(color: Colors.grey[600])),
            Text('${product.createdAt?.toIso8601String()}',
                style: TextStyle(color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
            child: Text(product.description ?? '',
                maxLines: 3, overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}


