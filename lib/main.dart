import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import the GetX package
import 'package:mobile/mobileapp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Replace MaterialApp with GetMaterialApp
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blueGrey),
      home: MobilicApp(),
    );
  }
}
