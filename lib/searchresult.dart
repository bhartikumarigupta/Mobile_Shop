import 'package:flutter/material.dart';

class SearchResultPage extends StatelessWidget {
  final Map<String, dynamic> searchResult;

  SearchResultPage(this.searchResult);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Results"),
      ),
      body: ListView.builder(
        itemCount: searchResult['models'].length,
        itemBuilder: (context, index) {
          final modelName = searchResult['models'][index];
          return ListTile(
            title: Text(modelName),
          );
        },
      ),
    );
  }
}
