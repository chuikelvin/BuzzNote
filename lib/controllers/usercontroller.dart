import 'package:get/get.dart';

class UserBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => UserController());
    // Get.lazyPut(() => User());
  }
}

// class User extends GetxController {
class UserController extends GetxController {
  final displayname = "".obs;
  final photourl = null.obs;
  final uuid = "".obs;
  final emailAdress = "".obs;

  updateDisplayName(String name) {
    displayname(name);
  }

  String get displayName {
    return displayname.string;
  }

  String get uid {
    return uuid.string;
  }

  get photoURL {
    // if (condition) {

    // }
    return photourl.value;
  }

  String get email {
    return emailAdress.string;
  }
}
