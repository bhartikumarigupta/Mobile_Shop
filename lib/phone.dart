import 'package:flutter/material.dart';

class Phone extends StatefulWidget {
  final List<dynamic> product;

  Phone({Key? key, required this.product}) : super(key: key);

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> product = widget.product;

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: product.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        return Card(
          child: AspectRatio(
            aspectRatio: 20 / 9,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align content to the left
                children: [
                  Align(
                    alignment:
                        Alignment.topRight, // Align icon to the top-right
                    child: Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 3),
                  Expanded(
                    child: Center(
                      child: Image.network(
                        product[index]["images"][0]["fullImage"],
                        fit: BoxFit
                            .contain, // Make the image cover the available space
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        size: 15,
                      ),
                      Text("${product[index]["listingNumPrice"]}"),
                    ],
                  ),
                  Text(
                    "${product[index]["marketingName"]}",
                    textAlign: TextAlign.start,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${product[index]["deviceStorage"]}",
                        style: TextStyle(fontSize: 11),
                      ),
                      Text(
                        "Condition:${product[index]["deviceCondition"]}",
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${product[index]["listingLocation"]}",
                        style: TextStyle(fontSize: 11),
                      ),
                      Text(
                        "${product[index]["listingDate"]}",
                        style: TextStyle(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
