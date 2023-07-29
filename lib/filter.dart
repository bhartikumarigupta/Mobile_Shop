import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double _minPrice = 5000;
  double _maxPrice = 50000;
  String _selectedOption1 = 'All';
  String _selectedOption2 = 'All';
  String _selectedOption3 = 'All';
  String _selectedOption4 = 'All';

  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values for the text fields
    _minPriceController.text = _minPrice.toString();
    _maxPriceController.text = _maxPrice.toString();
  }

  @override
  void dispose() {
    // Clean up the controllers
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              options: ['All', 'Apple', 'Google', 'Samsung', 'Nokia'],
              selectedOption: _selectedOption1,
              onOptionChanged: (value) {
                setState(() {
                  _selectedOption1 = value;
                });
              },
              btn: "clear",
            ),
            _buildFilterSection(
              title: 'RAM',
              options: ['All', '2GB', '4GB', '8GB', '16GB'],
              selectedOption: _selectedOption2,
              onOptionChanged: (value) {
                setState(() {
                  _selectedOption2 = value;
                });
              },
              btn: '',
            ),
            _buildFilterSection(
              title: 'Storage',
              options: ['All', '64GB', '128GB', '256GB'],
              selectedOption: _selectedOption3,
              onOptionChanged: (value) {
                setState(() {
                  _selectedOption3 = value;
                });
              },
              btn: '',
            ),
            _buildFilterSection(
              title: 'Condition',
              options: ['All', 'Like New', 'Excellent', 'Good', 'Fair'],
              selectedOption: _selectedOption4,
              onOptionChanged: (value) {
                setState(() {
                  _selectedOption4 = value;
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
                    controller: _minPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Min Price',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _minPrice = double.tryParse(value) ?? _minPrice;
                      });
                    },
                  ),
                ),
                SizedBox(width: 180),
                Flexible(
                  child: TextFormField(
                    controller: _maxPriceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Max Price',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _maxPrice = double.tryParse(value) ?? _maxPrice;
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            RangeSlider(
              values: RangeValues(_minPrice, _maxPrice),
              min: 5000,
              max: 50000,
              divisions: 100,
              onChanged: (values) {
                setState(() {
                  _minPrice = values.start;
                  _maxPrice = values.end;
                  _minPriceController.text = _minPrice.toString();
                  _maxPriceController.text = _maxPrice.toString();
                });
              },
            ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Apply filters and return to the previous page
                Navigator.pop(context, {
                  'option1': _selectedOption1,
                  'option2': _selectedOption2,
                  'option3': _selectedOption3,
                  'option4': _selectedOption4,
                  'minPrice': _minPrice,
                  'maxPrice': _maxPrice,
                });
              },
              style: ElevatedButton.styleFrom(
                // Set the minimumSize property to adjust the button size
                minimumSize:
                    Size(400, 50), // Change the width and height as needed
              ),
              child: Text('Apply'),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
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
                        _selectedOption1 = 'All';
                        _selectedOption2 = 'All';
                        _selectedOption3 = 'All';
                        _selectedOption4 = 'All';
                        _minPrice = 5000;
                        _maxPrice = 50000;
                        _minPriceController.text = _minPrice.toString();
                        _maxPriceController.text = _maxPrice.toString();
                      });
                    },
                    child: Text(
                      btn,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
                : SizedBox()
          ],
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 5,
          children: options.map((option) {
            return FilterDescription(
              description: option,
              selected: option == selectedOption,
              onTap: () {
                onOptionChanged(option);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class FilterDescription extends StatelessWidget {
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const FilterDescription({
    required this.description,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.grey.shade400 : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey),
        ),
        child: Text(
          description,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
