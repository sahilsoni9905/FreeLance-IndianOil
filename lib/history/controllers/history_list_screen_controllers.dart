import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:oil_solution/history/models/history_models.dart';
import 'package:oil_solution/services/shared_pref_service.dart';

class HistoryListScreenControllers extends GetxController {
  Rx<RxStatus> historyListScreenLoadingStatus = RxStatus.loading().obs;
  late List<HistoryModels> historyModelsList;

  @override
  void onInit() async {
    super.onInit();
    historyListScreenLoadingStatus.value = RxStatus.loading();
    historyModelsList = await Get.find<PrefUtils>().getListFromSharedPref('history_data');  
    String jsonString = jsonEncode(historyModelsList.map((model) => model.toJson()).toList());
    print(jsonString);
    historyListScreenLoadingStatus.value = RxStatus.success();
  }

  String formatDate(DateTime dateTime) {
  return DateFormat('d MMMM yyyy').format(dateTime);
}
}
