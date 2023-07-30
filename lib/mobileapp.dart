import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
  double minPrice = 5000;
  double maxPrice = 500000;
  String selectedOption1 = 'All';
  String selectedOption2 = 'All';
  String selectedOption3 = 'All';
  String selectedOption4 = 'All';
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  List<String> Ram = ['All', '2 GB', '4 GB', '8 GB', '16 GB'];
  List<String> make = ['All', 'Apple', 'Google', 'Samsung', 'Nokia'];
  List<String> condition = ['All', 'Like New', 'Excellent', 'Good', 'Fair'];
  List<String> storage = ['All', '64 GB', '128 GB', '256 GB'];
  Map<String, dynamic> listings = {};
  int currentPage = 1;
  int limit = 10;
  bool isLoading = false;
  bool isloadingContent = false;
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
    listings = {};
    searchresponse = {};
    fetchListingsData();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
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
    setState(() {
      isloadingContent = true;
    });
    final baseUrl =
        "https://dev2be.oruphones.com/api/v1/global/assignment/getListings";

    try {
      setState(() {
        isLoading = true;
      });

      // Add the selected filters and price range to the URL as query parameters
      final queryParameters = {
        'page': currentPage.toString(),
        'limit': limit.toString(),
        'make': selectedOption1,
        'deviceRam': selectedOption2,
        'deviceStorage': selectedOption3,
        'deviceCondition': selectedOption4,
        'minPrice': minPrice.toString(),
        'maxPrice': maxPrice.toString(),
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      final response = await http.get(uri);

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

  List<dynamic> filterProducts(List<dynamic> products) {
    return products.where((product) {
      bool passFilter = true;

      if (selectedOption1 != 'All' && product['make'] != selectedOption1) {
        passFilter = false;
      }
      if (selectedOption2 != 'All' && product['deviceRam'] != selectedOption2) {
        passFilter = false;
      }
      if (selectedOption3 != 'All' &&
          product['deviceStorage'] != selectedOption3) {
        passFilter = false;
      }
      if (selectedOption4 != 'All' &&
          product['deviceCondition'] != selectedOption4) {
        passFilter = false;
      }
      if (product['listingNumPrice'] < minPrice ||
          product['listingNumPrice'] > maxPrice) {
        passFilter = false;
      }

      return passFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> product = [], filteredProducts = [];
    if (listings["listings"] != null) {
      product = listings["listings"];
      filteredProducts = filterProducts(product);

      setState(() {
        product = filteredProducts;
      });
    }
    return SafeArea(
      child: Scaffold(
        appBar: buildAppBar(),
        body: issearching &&
                searchresponse['models'] != null &&
                searchresponse['models'].length > 0
            ? ListView.builder(
                itemCount: searchresponse['models'].length,
                itemBuilder: (context, index) {
                  final modelName = searchresponse['models'][index];
                  return ListTile(
                    title: Text(modelName),
                  );
                },
              )
            : product == null && isloadingContent
                ? CircularProgressIndicator()
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                        DecoratedBox(
                                          decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.yellow,
                                                    width: 2.0)),
                                          ),
                                          child: Text(
                                            'India',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.yellow),
                                          ),
                                        ),
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
                                                // Show the Snackbar when the button is pressed

                                                _showFilterPage(context);
                                              },
                                              icon: Icon(Icons.filter_list))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: filteredProducts.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  // Display the product only if it passes all the filters
                                  return Card(
                                    child: AspectRatio(
                                      aspectRatio: 20 / 9,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start, // Align content to the left
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: Icon(
                                                    Icons
                                                        .favorite_border_outlined,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        8), // Add some spacing between the icon and the line
                                                DecoratedBox(
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            color: Colors.black,
                                                            width: 2.0)),
                                                  ),
                                                  child: SizedBox(
                                                      width:
                                                          30), // Adjust the width of the line as needed
                                                ),
                                              ],
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${product[index]["deviceStorage"]}",
                                                  style:
                                                      TextStyle(fontSize: 11),
                                                ),
                                                Text(
                                                  "Condition:${product[index]["deviceCondition"]}",
                                                  style:
                                                      TextStyle(fontSize: 11),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 3),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "${product[index]["listingLocation"]}",
                                                  style:
                                                      TextStyle(fontSize: 11),
                                                ),
                                                Text(
                                                  "${product[index]["listingDate"]}",
                                                  style:
                                                      TextStyle(fontSize: 11),
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
      backgroundColor: Colors.blueGrey[800],
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

                  if (searchQuery.isNotEmpty && searchQuery != null) {
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

  void _showFilterPage(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFilterSection(
                  title: 'Filter',
                  options: make,
                  selectedOption: selectedOption1,
                  onOptionChanged: (value) {
                    setState(() {
                      selectedOption1 = value;
                    });
                  },
                  btn: "clear",
                ),
                _buildFilterSection(
                  title: 'RAM',
                  options: Ram,
                  selectedOption: selectedOption2,
                  onOptionChanged: (value) {
                    setState(() {
                      selectedOption2 = value;
                    });
                  },
                  btn: '',
                ),
                _buildFilterSection(
                  title: 'Storage',
                  options: storage,
                  selectedOption: selectedOption3,
                  onOptionChanged: (value) {
                    setState(() {
                      selectedOption3 = value;
                    });
                  },
                  btn: '',
                ),
                _buildFilterSection(
                  title: 'Condition',
                  options: condition,
                  selectedOption: selectedOption4,
                  onOptionChanged: (value) {
                    setState(() {
                      selectedOption4 = value;
                    });
                  },
                  btn: '',
                ),
                SizedBox(height: 16),
                // LinearProgressIndicator with two editable boxes for min and max values
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextFormField(
                        controller: minPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Min Price',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            minPrice = double.tryParse(value) ?? minPrice;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 180),
                    Flexible(
                      child: TextFormField(
                        controller: maxPriceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Max Price',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            maxPrice = double.tryParse(value) ?? maxPrice;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                RangeSlider(
                  values: RangeValues(minPrice, maxPrice),
                  min: 5000,
                  max: 500000,
                  divisions: 100,
                  activeColor: Colors.blueGrey,
                  onChanged: (values) {
                    setState(() {
                      minPrice = values.start;
                      maxPrice = values.end;
                      minPriceController.text = minPrice.toString();
                      maxPriceController.text = maxPrice.toString();
                    });
                  },
                ),

                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Apply filters and return to the previous page
                    Navigator.pop(context, {
                      'option1': selectedOption1,
                      'option2': selectedOption2,
                      'option3': selectedOption3,
                      'option4': selectedOption4,
                      'minPrice': minPrice,
                      'maxPrice': maxPrice,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      // Set the minimumSize property to adjust the button size
                      minimumSize: Size(400, 50),
                      backgroundColor: Colors
                          .blueGrey // Change the width and height as needed
                      ),
                  child: Text('Apply'),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );

    // Handle the result from the filter page (e.g., apply filters based on result).
    print("Filter options: $result");
  }

  Widget _buildFilterSection({
    required String title,
    required List<String> options,
    required String selectedOption,
    required ValueChanged<String> onOptionChanged,
    required String btn,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            btn != ''
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        selectedOption1 = 'All';
                        selectedOption2 = 'All';
                        selectedOption3 = 'All';
                        selectedOption4 = 'All';
                        minPrice = 5000;
                        maxPrice = 500000;
                        minPriceController.text = minPrice.toString();
                        maxPriceController.text = maxPrice.toString();
                      });
                    },
                    child: Text(
                      btn,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red),
                    ))
                : SizedBox()
          ],
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 5,
          children: options.map((option) {
            // print(option);
            return GestureDetector(
              onTap: () {
                setState(() {
                  print(option);
                  onOptionChanged(option);
                  Get.snackbar(
                    "Selected:- ",
                    "Selected choice:- $option \n",
                  );
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: option == selectedOption
                      ? Colors.grey.shade400
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color:
                        option == selectedOption ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void showSnackbar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('This is a Snackbar!'),
      duration:
          Duration(seconds: 3), // Duration for which the Snackbar is displayed
      action: SnackBarAction(
        label: 'Dismiss', // Action label for the Snackbar
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    // Show the Snackbar using ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
