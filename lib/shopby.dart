import 'package:flutter/material.dart';

class shopby extends StatefulWidget {
  const shopby({super.key});

  @override
  State<shopby> createState() => _shopbyState();
}

class _shopbyState extends State<shopby> {
  List<String> imageUrls = [
    "asset/images/bestselling.png",
    "asset/images/varified.png",
    "asset/images/collection.png",
    "asset/images/warrenty.png"
  ];
  List<String> title = [
    "Bestselling\n   Mobiles",
    "   Verified\nDevices Only",
    "Like New\nCondition",
    "Phones With\n   Warrenty"
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 109.5,
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
                height: 4,
                width: 62,
                child: Column(
                  children: [
                    Image.asset(
                      imageUrls[index],
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "${title[index]}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
