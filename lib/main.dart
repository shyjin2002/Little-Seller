import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shopping/screen_selector.dart';

void main() {
  Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyAYaoRTfxxId479-5D989w_7UFEI172Oo8",
  authDomain: "shopping-45cf6.firebaseapp.com",
  projectId: "shopping-45cf6",
  storageBucket: "shopping-45cf6.appspot.com",
  messagingSenderId: "598599070096",
  appId: "1:598599070096:web:afd82e3a8d4825aaa9c315",
  measurementId: "G-7983QSSQKK"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Little Shopping',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
      ),
      home: const ScreenSelector(title: 'Little Shopping'),
    );
  }
}


