import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageCarousel extends StatefulWidget {
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final List<String> imageUrls = [
    "asset/images/image1.png",
    "asset/images/image2.jpg",
    "asset/images/image3.jpg",
    "asset/images/image4.jpg",
    // Add more image URLs as needed
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 160, // Set your desired height of the carousel
            autoPlay: false, // Auto-play the carousel
            enlargeCenterPage: true, // Increase the size of the center image
            //aspectRatio: 16 / 9, // Set the aspect ratio of the images
            autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
            autoPlayInterval:
                Duration(seconds: 3), // Duration between each slide
            autoPlayAnimationDuration:
                Duration(milliseconds: 10000), // Animation duration
            enableInfiniteScroll: false, // Allow infinite scrolling
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: imageUrls.map((imageUrl) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 0.001),
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                );
              },
            );
          }).toList(),
        ),
        SizedBox(height: 1),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imageUrls.map((imageUrl) {
            int index = imageUrls.indexOf(imageUrl);
            return Container(
              width: 8.0,
              height: 12.0,
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.blue : Colors.grey,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
