import 'package:get/get.dart';

import '../routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  void changePage(int index) {
    switch (index) {
      case 1:
        break;
      case 2:
        pageIndex.value = index;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = index;
        Get.offAllNamed(Routes.HOME);
    }
  }
}
