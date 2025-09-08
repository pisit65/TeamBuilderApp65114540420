import 'package:get/get.dart';

class NameController extends GetxController {
  var name = "ไม่มีชื่อ".obs;

  void changeName(String newName) {
    name.value = newName;
  }
}
