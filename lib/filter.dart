import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'controller.dart';

class FilterPage extends StatelessWidget {
  final Controller controller = Get.put(Controller());

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
              selectedOption: controller.selectedOption1.value,
              onOptionChanged: (value) {
                controller.selectedOption1.value = value;
              },
              btn: "clear",
            ),
            _buildFilterSection(
              title: 'RAM',
              options: ['All', '2GB', '4GB', '8GB', '16GB'],
              selectedOption: controller.selectedOption2.value,
              onOptionChanged: (value) {
                controller.selectedOption2.value = value;
              },
              btn: '',
            ),
            _buildFilterSection(
              title: 'Storage',
              options: ['All', '64GB', '128GB', '256GB'],
              selectedOption: controller.selectedOption3.value,
              onOptionChanged: (value) {
                controller.selectedOption3.value = value;
              },
              btn: '',
            ),
            _buildFilterSection(
              title: 'Condition',
              options: ['All', 'Like New', 'Excellent', 'Good', 'Fair'],
              selectedOption: controller.selectedOption4.value,
              onOptionChanged: (value) {
                controller.selectedOption4.value = value;
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
                    controller: controller.minPriceController.value,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Min Price',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      controller.minPrice.value =
                          double.tryParse(value) ?? controller.minPrice.value;
                    },
                  ),
                ),
                SizedBox(width: 180),
                Flexible(
                  child: TextFormField(
                    controller: controller.maxPriceController.value,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Max Price',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      controller.maxPrice.value =
                          double.tryParse(value) ?? controller.maxPrice.value;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            RangeSlider(
              values: RangeValues(
                  controller.minPrice.value, controller.maxPrice.value),
              min: 5000,
              max:
                  500000, // Change this to match the maximum price value (500000)
              divisions: 100,
              onChanged: (values) {
                controller.minPrice.value = values.start;
                controller.maxPrice.value = values.end;
                controller.minPriceController.value.text =
                    controller.minPrice.value.toString();
                controller.maxPriceController.value.text =
                    controller.maxPrice.value.toString();
              },
            ),

            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Apply filters and return to the previous page

                Navigator.pop(context, {
                  'option1': controller.selectedOption1.value,
                  'option2': controller.selectedOption2.value,
                  'option3': controller.selectedOption3.value,
                  'option4': controller.selectedOption4.value,
                  'minPrice': controller.minPrice.value,
                  'maxPrice': controller.maxPrice.value,
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
                      controller.selectedOption1.value = 'All';
                      controller.selectedOption2.value = 'All';
                      controller.selectedOption3.value = 'All';
                      controller.selectedOption4.value = 'All';
                      controller.minPrice.value = 5000;
                      controller.maxPrice.value = 50000;
                      controller.minPriceController.value.text =
                          controller.minPrice.value.toString();
                      controller.maxPriceController.value.text =
                          controller.maxPrice.value.toString();
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
