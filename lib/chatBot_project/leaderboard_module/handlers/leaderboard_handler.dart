import 'package:get/get.dart';

class LeaderboardHandler extends GetxController {
  
  RxString selectedTab='Weekly'.obs;

  void tabToggler(String tabName){
    selectedTab.value=tabName;
  }

}