import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class Controller extends GetxController {
  RxDouble minPrice = 5000.0.obs;
  RxDouble maxPrice = 500000.0.obs;
  RxString selectedOption1 = 'All'.obs;
  RxString selectedOption2 = 'All'.obs;
  RxString selectedOption3 = 'All'.obs;
  RxString selectedOption4 = 'All'.obs;
  Rx<TextEditingController> minPriceController = TextEditingController().obs;
  Rx<TextEditingController> maxPriceController = TextEditingController().obs;
}
