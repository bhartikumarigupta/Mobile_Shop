import 'package:flutter/material.dart';

class company extends StatefulWidget {
  const company({super.key});

  @override
  State<company> createState() => _companyState();
}

class _companyState extends State<company> {
  List<String> imageUrls = [
    "asset/images/apple.png",
    "asset/images/samsung.png",
    "asset/images/mi.png",
    "asset/images/vivo.jpeg",
    "asset/images/oneplus.jpeg"
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: 10,
                width: 100,
                child: Image.asset(
                  imageUrls[index],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
