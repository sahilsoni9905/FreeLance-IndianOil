import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:oil_solution/home/controllers/home_screen_controllers.dart';

class AddDataScreenControllers extends GetxController {
  // Controllers for each field
  final avgPckDensityController = TextEditingController();
  final interfaceDensityController = TextEditingController();
  final timeController = TextEditingController();
  final flowRateController = TextEditingController();
  final purePCKController = TextEditingController();
  final pureMSController = TextEditingController();
  late HomeScreenControllers homeScreenControllers;
  RxStatus addDataScreenLoadingStatus = RxStatus.loading();

  // Observable fields to store input data
  var avgPckDensity = ''.obs;
  var interfaceDensity = ''.obs;
  var time = ''.obs;
  var flowRate = ''.obs;
  var flowRateInKlPerMin = ''.obs;

  @override
  void onInit() {
    addDataScreenLoadingStatus = RxStatus.loading();
    super.onInit();
    homeScreenControllers = Get.find<HomeScreenControllers>();
    addDataScreenLoadingStatus = RxStatus.success();
  }

  // Method to update average PCK density
  void setAvgPckDensity(String value) {
    avgPckDensity.value = value;
  }

  // Method to update interface density
  void setInterfaceDensity(String value) {
    interfaceDensity.value = value;
  }

  // Method to set time from time picker in HH:mm format
  Future<void> selectTime(BuildContext context) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      final formattedTime = selectedTime.format(context);
      timeController.text = formattedTime; // Set in controller
      time.value = formattedTime; // Update observable
    }
  }

  // Method to update flow rate and calculate flow rate in KL per minute
  void setFlowRate(String value) {
    flowRate.value = value;

    double? flowRateValue = double.tryParse(flowRateController.text);
    if (flowRateValue != null) {
      flowRateInKlPerMin.value = (flowRateValue / 60).toStringAsFixed(2);
    } else {
      flowRateInKlPerMin.value = '0.00'; 
    }
  }

  // Method to add data to the database
  void addDataToDatabase() async {
    addDataScreenLoadingStatus = RxStatus.loading();
    print("Starting database insertion...");

    try {
      final avgPckDensityValue = double.parse(avgPckDensity.value);
      final interfaceDensityValue = double.parse(interfaceDensity.value);
      final flowRateValue = double.parse(flowRate.value);
      final flowRateInKlPerMinValue = double.parse(flowRateInKlPerMin.value);

      print("Parsed values: avgPckDensity: $avgPckDensityValue, "
          "interfaceDensity: $interfaceDensityValue, "
          "time: ${time.value}, "
          "flowRate: $flowRateValue, "
          "flowRateInKlPerMin: $flowRateInKlPerMinValue");

      if(homeScreenControllers.isToggled.value == false){ 
        await homeScreenControllers.databaseService.addTask(
        avgPckMsDensity: avgPckDensityValue,
        interfaceDensity: interfaceDensityValue,
        time: time.value,
        percentOfPck: 0.0,
        percentOfMs: 0.0,
        qtyKlOfPck: flowRateValue,
        qtyKlOfMs: flowRateInKlPerMinValue,
        totalKlInterface: flowRateValue + flowRateInKlPerMinValue,
      );}
      else{
        await homeScreenControllers.databaseService.addTaskToTable2(
        avgPckMsDensity: avgPckDensityValue,
        interfaceDensity: interfaceDensityValue,
        time: time.value,
        percentOfPck: 0.0,
        percentOfMs: 0.0,
        qtyKlOfPck: flowRateValue,
        qtyKlOfMs: flowRateInKlPerMinValue,
        totalKlInterface: flowRateValue + flowRateInKlPerMinValue,
      );

      }

      homeScreenControllers.lastUpdatedAt.value =
          DateFormat('HH:mm:ss').format(DateTime.now());
      print("Data added successfully to database.");

      showSnackbar();
      homeScreenControllers.updateHomeData(isTable2: homeScreenControllers.isToggled.value);

      addDataScreenLoadingStatus = RxStatus.success();
    } catch (e) {
      print("Error adding data to database: $e");
      addDataScreenLoadingStatus = RxStatus.error();
    }
  }

  @override
  void dispose() {
    avgPckDensityController.dispose();
    interfaceDensityController.dispose();
    timeController.dispose();
    flowRateController.dispose();
    super.dispose();
  }

 void showSnackbar() {
  Get.showSnackbar(
    GetSnackBar(
      message: "Data has been successfully added to the table",
      snackPosition: SnackPosition.BOTTOM, 
      duration: Duration(seconds: 3), 
      margin: EdgeInsets.all(10),
      borderRadius: 20, 
      backgroundColor: Colors.transparent, 
      snackStyle: SnackStyle.GROUNDED, 
      overlayColor: Colors.black.withOpacity(0.5), 
      boxShadows: [BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.4), offset: Offset(0, 4))], 
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), 
      titleText: Text(
        'Success!',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      messageText: Text(
        'Data has been successfully added to the table',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
  );
}


}
