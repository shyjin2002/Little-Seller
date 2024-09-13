// import 'package:flutter/material.dart';

// import 'package:flutter/material.dart';
// import 'package:searchable_text_field/searchable_text_field.dart';

// class ScreenSelector extends StatefulWidget {
//   const ScreenSelector({super.key, required this.title});

//   final String title;

//   @override
//   State<ScreenSelector> createState() => _ScreenSelectorState();
// }

// class _ScreenSelectorState extends State<ScreenSelector> {
//   int _selectedTab = 0;
//   List<Widget> tabs = [
//     HomeScreen(),
//     // OrdersScreen(),
//     // SettingsScreen(),
//     // ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFF26419),
//         elevation: 0,
//         title: Row(
//           children: [
//             Container(
//               child: Image.asset(
//                 'assets/images/logo.png',
//                 width: 50,
//                 height: 50,
//               ),
//             ),
//             const SizedBox(width: 20),
//             Text(
//               'Little Shopping',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
//             ),
//           ],
//         ),
//         actions: [
//           SearchableTextField(
//             placeholder: 'Search...',
//             onSubmitted: (String value) {
//               print('Search term submitted: $value');
//               // Implement your search logic here
//             // },
//             builder: (context, result) {
//               return IconButton(
//                 icon: Icon(result.isFocused ? Icons.search : Icons.close, color: Colors.white),
//                 onPressed: result.isFocused ? () {} : null,
//               );
//             },
//           ),
//           const SizedBox(width: 20),
//         ],
//       ),
//       body: Row(
//         children: [
//           Expanded(
//             flex: 1,
//             child: ListView(
//               children: [
//                 ListTile(
//                   title: Text('Home'),
//                   onTap: () => setState(() => _selectedTab = 0),
//                 ),
//                 ListTile(
//                   title: Text('Orders'),
//                   onTap: () => setState(() => _selectedTab = 1),
//                 ),
//                 ListTile(
//                   title: Text('Settings'),
//                   onTap: () => setState(() => _selectedTab = 2),
//                 ),
//                 ListTile(
//                   title: Text('Profile'),
//                   onTap: () => setState(() => _selectedTab = 3),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 6,
//             child: tabs[_selectedTab],
//           ),
//         ],
//       ),
//     );
//   }
// }

