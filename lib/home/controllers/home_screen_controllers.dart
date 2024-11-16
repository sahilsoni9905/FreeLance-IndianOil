import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:oil_solution/services/database_service.dart';
import 'package:oil_solution/services/shared_pref_service.dart';
import 'package:oil_solution/table/models/table_data_models.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreenControllers extends GetxController {
  late DatabaseService databaseService;
  
  RxDouble pckValue = 45.66.obs;
  RxDouble msValueOrHsd = 54.66.obs;
  Rx<RxStatus> homeScreenLoadingStatus = RxStatus.loading().obs;
  RxList<TaskData> taskDataList = <TaskData>[].obs;
  var lastUpdatedAt = ''.obs;
  RxList<FlSpot> chartData = <FlSpot>[].obs;
  RxBool isToggled = false.obs;
  RxString toggledText = 'MS-PCK Mode'.obs;

  @override
  void onInit() async {
    await Get.putAsync(() => PrefUtils().init());
    homeScreenLoadingStatus.value = RxStatus.loading();
    super.onInit();
    databaseService = await DatabaseService.instance;
    await fetchTableData(false);
    chartData.value = await getChartData(false);
    homeScreenLoadingStatus.value = RxStatus.success();
  }

  void toggleButtonClicked(bool value){
    print('the value is ${value}');
    isToggled.value = value;
    if(!value){
      toggledText.value = 'MS-PCK Mode';
      updateHomeData(isTable2: false);
    }
    else{
      toggledText.value = 'HSD-PCK Mode';
      updateHomeData(isTable2: true);
    }
  }

  Future<void> fetchTableData(bool isTable2) async {
    final db = await databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(isTable2 ? databaseService.tasks2TableName : databaseService.tasksTableName);
    taskDataList.value = maps.map((map) => TaskData.fromMap(map)).toList();
    lastUpdatedAt.value = formatLastUpdatedAt(DateTime.now());
  }

DateTime parseTime(String timeString) {
  timeString = timeString.trim(); // Remove extra spaces

  // Try parsing with multiple formats
  try {
    if (timeString.contains(RegExp(r'[AaPp][Mm]'))) {
      // Time with AM/PM (e.g., "11:59 AM")
      return DateFormat('hh:mm a').parse(timeString);
    } else {
      // Time in 24-hour format (e.g., "11:59")
      return DateFormat('HH:mm').parse(timeString);
    }
  } catch (e) {
    print("Error parsing time: $e");
    return DateTime.now(); // Fallback
  }
}


Future<List<FlSpot>> getChartData(bool isTable2) async {
  final db = await databaseService.database;
  final List<Map<String, dynamic>> maps = await db.query(isTable2 ? databaseService.tasks2TableName : databaseService.tasksTableName);

  return maps.map((map) {
    String timeString = map['time'];
    double interfaceDensity = map['interface_density'];
    DateTime time = parseTime(timeString);
    
   
    double timeInHours = time.hour + (time.minute / 60);

    FlSpot flSpot = FlSpot(timeInHours, interfaceDensity);

    print('FlSpot: (${flSpot.x}, ${flSpot.y})');
    
    return flSpot;
  }).toList();
}


  Future updateHomeData({bool isTable2 = false}) async{
    homeScreenLoadingStatus.value = RxStatus.loading();
    await fetchTableData(isTable2);
    chartData.value = await getChartData(isTable2);
    homeScreenLoadingStatus.value = RxStatus.success();
  }

  String formatLastUpdatedAt(DateTime dateTime) {
  String time = DateFormat('kk:mm').format(dateTime);
  int day = dateTime.day;
  String suffix;
  if (day >= 11 && day <= 13) {
    suffix = 'th';
  } else if (day % 10 == 1) {
    suffix = 'st';
  } else if (day % 10 == 2) {
    suffix = 'nd';
  } else if (day % 10 == 3) {
    suffix = 'rd';
  } else {
    suffix = 'th';
  }
  String dayWithSuffix = '$day$suffix';
  String month = DateFormat('MMM').format(dateTime);
  return '$time $dayWithSuffix $month';
}

List<PieChartSectionData> piechartSection(){
  return  
  List.generate(2 , (index) => PieChartSectionData(
   
  ));
}

}
