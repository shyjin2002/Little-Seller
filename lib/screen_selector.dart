import 'package:flutter/material.dart';
import 'package:shopping/homepage.dart';

class ScreenSelector extends StatefulWidget {
  const ScreenSelector({super.key, required this.title});

  final String title;

  @override
  State<ScreenSelector> createState() => _ScreenSelectorState();
}

class _ScreenSelectorState extends State<ScreenSelector> {
  @override
  Widget build(BuildContext context) {
    int _selectedTab = 0;
    List<Widget> tabs = [
      HomeScreen(),
      // OrdersScreen(),
      // SettingsScreen(),
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
            // TextField(
            //   decoration: InputDecoration(
            //       fillColor: Colors.blue, // Set the background color
            //       filled:
            //           true, // Ensure the background color fills the entire TextField
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(10),
            //         borderSide: BorderSide.none, // Remove the border
            //       ),
            //       prefixIcon: IconButton(
            //           onPressed: () {}, icon: const Icon(Icons.search))),
            // ),
            
          ],
        ),
        
        actions:  [
        //  TextField(
        //       decoration: InputDecoration(
        //           fillColor: Colors.blue, // Set the background color
        //           filled:
        //               true, // Ensure the background color fills the entire TextField
        //           border: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(10),
        //             borderSide: BorderSide.none, // Remove the border
        //           ),
        //           prefixIcon: IconButton(
        //               onPressed: () {}, icon: const Icon(Icons.search))),
        //     ),
          CircleAvatar(
            backgroundImage:
                NetworkImage('https://example.com/profile-picture.jpg'),
            radius: 15,
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              children: [
                ListTile(
                  title: Text('Home'),
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                ListTile(
                  title: Text('Orders'),
                  onTap: () => setState(() => _selectedTab = 1),
                ),
                ListTile(
                  title: Text('Settings'),
                  onTap: () => setState(() => _selectedTab = 2),
                ),
                ListTile(
                  title: Text('Profile'),
                  onTap: () => setState(() => _selectedTab = 3),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: tabs[_selectedTab],
          ),
        ],
      ),
    );
  }
}
