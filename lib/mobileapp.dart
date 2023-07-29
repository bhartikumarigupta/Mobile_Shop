import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile/apiservice.dart';
import 'package:mobile/carasole.dart';
import 'package:mobile/company.dart';
import 'package:mobile/phone.dart';
import 'package:mobile/productmodel.dart';
import 'package:mobile/searchresult.dart';
import 'package:mobile/shopby.dart';
import 'package:http/http.dart' as http;
import 'filter.dart';

class MobilicApp extends StatefulWidget {
  @override
  State<MobilicApp> createState() => _MobilicAppState();
}

class _MobilicAppState extends State<MobilicApp> {
  Map<String, dynamic> listings = {};
  int currentPage = 1;
  int limit = 10;
  bool isLoading = false;
  String searchQuery = '';
  final String url =
      'https://dev2be.oruphones.com/api/v1/global/assignment/searchModel';

  // The payload to be sent in the request body
  Map<String, dynamic> searchresponse = {};
  bool issearching = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    fetchListingsData();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more data when the user reaches the end of the list
      if (!isLoading) {
        currentPage++;
        fetchListingsData();
      }
    }
  }

  Future<void> fetchListingsData() async {
    final url =
        "https://dev2be.oruphones.com/api/v1/global/assignment/getListings?page=$currentPage&limit=$limit";

    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(Uri.parse(url));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        final newData = json.decode(response.body);
        setState(() {
          if (listings.containsKey("listings")) {
            listings["listings"].addAll(newData["listings"]);
          } else {
            listings = newData;
          }
          isLoading = false;
        });
      } else {
        print(
            "Error: Unable to fetch data. Status Code: ${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> searchModel(String url, Map<String, dynamic> requestBody) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // The request was successful, and the response data can be accessed as follows:
        final responseData = json.decode(response.body);
        print('Response Data:');
        print(responseData);
        setState(() {
          searchresponse = responseData;
        });
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred during the request:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> product = listings["listings"];
    return MaterialApp(
      home: Scaffold(
        appBar: buildAppBar(),
        body: issearching && searchresponse['models'].length != null
            ? ListView.builder(
                itemCount: searchresponse['models'].length,
                itemBuilder: (context, index) {
                  final modelName = searchresponse['models'][index];
                  return ListTile(
                    title: Text(modelName),
                  );
                },
              )
            : SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 4.0, left: 5, bottom: 3),
                            child: Text(
                              "Buy Top Brands",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          company(),
                          SizedBox(
                            height: 1,
                          ),
                          ImageCarousel(),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Shop by",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          shopby(),
                          SizedBox(
                            height: 1,
                          ),
                          Container(
                            width: 500,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Best Deal Near You",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "India",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.yellow),
                                    )
                                  ],
                                ),
                                Container(
                                  width: 160,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "Filter",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            _showFilterPage(context);
                                          },
                                          icon: Icon(Icons.sort))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: product.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return Card(
                                child: AspectRatio(
                                  aspectRatio: 20 / 9,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start, // Align content to the left
                                      children: [
                                        Align(
                                          alignment: Alignment
                                              .topRight, // Align icon to the top-right
                                          child: Icon(
                                            Icons.favorite_border_outlined,
                                            color: Colors.red,
                                          ),
                                        ),
                                        SizedBox(height: 3),
                                        Expanded(
                                          child: Center(
                                            child: Image.network(
                                              product[index]["images"][0]
                                                  ["fullImage"],
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
                                            Text(
                                                "${product[index]["listingNumPrice"]}"),
                                          ],
                                        ),
                                        Text(
                                          "${product[index]["marketingName"]}",
                                          textAlign: TextAlign.start,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
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
                          ),
                          isLoading
                              ? Center(child: CircularProgressIndicator())
                              : SizedBox()
                        ],
                      ),
                    ),
                  ),
                )),
      ),
    );
  }

//APP BAR
  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      title: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.sort),
                onPressed: () {
                  // Add notification handling code here
                },
              ),
              Column(
                children: [
                  Text(
                    "O R U",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "p h o n e",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Text("INDIA"),
            IconButton(
              icon: Icon(Icons.location_on),
              onPressed: () {
                // Add notification handling code here
              },
            ),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Add notification handling code here
              },
            ),
          ],
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: Padding(
          padding: EdgeInsets.only(bottom: 6, left: 17, right: 17),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
                decoration: InputDecoration(
                  hintText: "Search with make and model...",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery =
                        value.trim(); // Update the search query variable
                    issearching =
                        searchQuery.isNotEmpty; // Set issearching accordingly
                  });

                  if (searchQuery.isNotEmpty) {
                    final Map<String, dynamic> requestBody = {
                      "searchModel": value,
                    };
                    searchModel(url, requestBody);
                  }
                }),
          ),
        ),
      ),
    );
  }
}

void _showFilterPage(BuildContext context) async {
  final result = await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return FilterPage();
    },
  );

  // Handle the result from the filter page (e.g., apply filters based on result).
  print("Filter options: $result");
}
