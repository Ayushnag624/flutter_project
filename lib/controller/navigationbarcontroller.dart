import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class navigationcontroller extends GetxController{
  var selectedindex= 0.obs;

  void changetab(int index){
    selectedindex.value= index;
  }

  var goldApiValue = 0.0.obs;
  var silverApiValue = 0.0.obs;
  var goldApi = ''.obs;
  var silverApi = ''.obs;
  var isLoading = true.obs;

  void updaterate (int change){
    goldApiValue.value += change;
    silverApiValue.value += change;

    goldApi.value = goldApiValue.value.toStringAsFixed(0);
    silverApi.value = silverApiValue.value.toStringAsFixed(0);
    isLoading.value = false;
  }

}