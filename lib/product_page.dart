import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(16),
        child: IconButton(
          icon: Icon(Icons.add),
          color: Colors.blue,
          iconSize: 40,
          onPressed: () {
            print('Plus button pressed');
            // Add your logic here
          },
        ),
      ),
    );
  }
}