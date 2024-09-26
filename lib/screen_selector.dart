import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shopping/customer.dart';
import 'package:shopping/homepage.dart';
import 'package:shopping/order_historypage.dart';
import 'package:shopping/orderpage.dart';
import 'package:shopping/ui/product_page/product_page.dart';
import 'package:shopping/profile_page.dart';
import 'package:shopping/setting_page.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class ScreenSelector extends StatefulWidget {
  const ScreenSelector({super.key, required this.title});

  final String title;

  @override
  State<ScreenSelector> createState() => _ScreenSelectorState();
}

class _ScreenSelectorState extends State<ScreenSelector> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      HomeScreen(),
      const OrderPage(),
      const OrderHistorypage(),
      const CustomerPage(),
      const ProductPage(),
      const ProfilePage(),
      const SettingPage()
      // ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF26419),
        elevation: 0,
        title: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/logo.png', // Replace with your actual logo asset
              width: 50, // Slightly smaller than the container size
              height: 50, // Slightly smaller than the container size
            ),
            const SizedBox(
              width: 20,
            ),
            const Text(
              'Little Shopping',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          
          ],
        ),
        actions:  [
          Row(
            children: [
              IconButton(
                icon: const Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage('https://example.com/profile-picture.jpg'),
                      radius: 18,
                    ),
                    Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  'Shyjin',
                  style: TextStyle(color: Colors.white,fontSize: 20),
                ),
              ),
                  ],
                ), onPressed: () {  },
              ),
              const SizedBox(width: 10), // Adjust spacing as needed
              
            ],
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: HexColor("#F2E4CC"), // Color of the right border
                      width: 2.0, // Width of the right border
                    ),
                  ),
                ),
                child: ListView(
  children: [
    ListTile(
      leading: Icon(Icons.home),
      title: const Text('Home'),
      onTap: () => setState(() => selectedTab = 0),
      selected: selectedTab == 0,
      selectedTileColor: Colors.orange.withOpacity(0.2), // Change this color as desired
    ),
    ListTile(
      leading: Icon(Icons.add_shopping_cart),
      title: const Text('New Orders'),
      onTap: () => setState(() => selectedTab = 1),
      selected: selectedTab == 1,
      selectedTileColor: Colors.orange.withOpacity(0.2), // Change this color as desired
    ),
    ListTile(
      leading: Icon(Icons.history),
      title: const Text('Order History'),
      onTap: () => setState(() => selectedTab = 2),
      selected: selectedTab == 2,
      selectedTileColor: Colors.orange.withOpacity(0.2), // Change this color as desired
    ),
    ListTile(
      leading: Icon(Icons.people),
      title: const Text('Customer'),
      onTap: () => setState(() => selectedTab = 3),
      selected: selectedTab == 3,
      selectedTileColor: Colors.orange.withOpacity(0.2), // Change this color as desired
    ),
    ListTile(
      title: const Text('Product'),
      leading: FaIcon(FontAwesomeIcons.productHunt),
      onTap: () => setState(() => selectedTab = 4),
      selected: selectedTab == 4,
      selectedTileColor: Colors.orange.withOpacity(0.2), // Change this color as desired
    ),
    ListTile(
      leading: Icon(Icons.person),
      title: const Text('Profile'),
      onTap: () => setState(() => selectedTab = 5),
      selected: selectedTab == 5,
      selectedTileColor: Colors.orange.withOpacity(0.2), // Change this color as desired
    ),
    ListTile(
      leading: Icon(Icons.settings),
      title: const Text('Setting'),
      onTap: () => setState(() => selectedTab = 6),
      selected: selectedTab == 6,
      selectedTileColor: Colors.orange.withOpacity(0.2), // Change this color as desired
    ),
  ],
)
              )),
          Expanded(
            flex: 5,
            child: tabs[selectedTab],
          ),
        ],
      ),
    );
  }
}
