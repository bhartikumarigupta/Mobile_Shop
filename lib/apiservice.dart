// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'package:mobile/productmodel.dart';

// class apiservices {
//   Future<Productmodel> getApi(String url) async {
//     if (kDebugMode) {
//       print(url);
//     }

//     var responseJson;
//     try {
//       final response =
//           await http.get(Uri.parse(url)).timeout(const Duration(seconds: 50));

//       responseJson = returnResponse(response);
//     } on Exception {}

//     return responseJson;
//   }

//   dynamic returnResponse(http.Response response) {
//     switch (response.statusCode) {
//       case 200:
//         dynamic responseJson = jsonDecode(response.body);
//         return responseJson;
//       case 201:
//         print(response.body);
//         dynamic responseJson = response.body;
//         return responseJson;
//       case 400:
//         dynamic responseJson = jsonDecode(response.body);
//         return responseJson;
//       case 403:
//         dynamic responseJson = jsonDecode(response.body);
//         print(responseJson["error"]);
//         if (responseJson["error"] != null) {
//         } else {}

//       default:
//     }
//   }
// }
