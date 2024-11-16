import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oil_solution/history/models/history_models.dart';
import 'package:oil_solution/home/controllers/home_screen_controllers.dart';
import 'package:oil_solution/services/scale_utils_service.dart';
import 'package:oil_solution/services/shared_pref_service.dart';
import 'package:oil_solution/table/models/table_data_models.dart';

class TableScreenControllers extends GetxController {
  Rx<RxStatus> tableScreenLoadingStatus = RxStatus.loading().obs;
  late HomeScreenControllers homeScreenControllers;
  RxList<TaskData> taskDataList = <TaskData>[].obs;

  @override
  void onInit() {
    super.onInit();
    homeScreenControllers = Get.find<HomeScreenControllers>();
    fetchTableData();
  }

  Future<void> fetchTableData() async {
    tableScreenLoadingStatus.value = RxStatus.loading();

    final db = await homeScreenControllers.databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(homeScreenControllers.databaseService.tasksTableName);

    taskDataList.value = maps.map((map) => TaskData.fromMap(map)).toList();

    tableScreenLoadingStatus.value = RxStatus.success();
  }

  List<DataColumn> getDataColumns(ScalingUtility scale) {
    return [
      const DataColumn(
        label: Text(
          'ID',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: scale.getScaledWidth(80),
          child: Text(
            'Avg PCK- MS Density kg/cm3',
            maxLines: 2,
            overflow: TextOverflow.visible,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: scale.getScaledWidth(80),
          child: Text(
            'Interface Density kg/cm3',
            maxLines: 2,
            overflow: TextOverflow.visible,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: scale.getScaledWidth(80),
          child: Text(
            'Time',
            maxLines: 2,
            overflow: TextOverflow.visible,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: scale.getScaledWidth(80),
          child: Text(
            '% of PCK ',
            maxLines: 2,
            overflow: TextOverflow.visible,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: scale.getScaledWidth(80),
          child: Text(
            '% of MS',
            maxLines: 2,
            overflow: TextOverflow.visible,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: scale.getScaledWidth(80),
          child: Text(
            'Qty,KL of PCK',
            maxLines: 2,
            overflow: TextOverflow.visible,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: scale.getScaledWidth(80),
          child: Text(
            'Qty,KL of MS',
            maxLines: 2,
            overflow: TextOverflow.visible,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
      DataColumn(
        label: SizedBox(
          width: scale.getScaledWidth(80),
          child: Text(
            'Total ,KLInterface',
            maxLines: 2,
            overflow: TextOverflow.visible,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
          ),
        ),
      ),
    ];
  }

List<DataRow> getDataRows(ScalingUtility scale) {
  return taskDataList.map((e) {
    int index = taskDataList.indexOf(e);
    bool isEven = index % 2 == 0;

    return DataRow(
      color: MaterialStateProperty.all(isEven ? Colors.grey[100] : Colors.white),
      cells: [
        for (var cell in [
          DataCell(Text(e.id.toString())),
          DataCell(Text(e.avgPckMsDensity.toString())),
          DataCell(Text(e.interfaceDensity.toString())),
          DataCell(Text(e.time)),
          DataCell(Text(e.percentOfPck.toString())),
          DataCell(Text(e.percentOfMs.toString())),
          DataCell(Text(e.qtyKlOfPck.toString())),
          DataCell(Text(e.qtyKlOfMs.toString())),
          DataCell(Text(e.totalKlInterface.toString())),
        ])
          DataCell(
            InkWell(
              onLongPress: () {
                print('Tapped on row with index: $index');
                showDeleteConfirmationDialog(index);
              },
              child: cell.child,
            ),
          ),
      ],
    );
  }).toList();
}

void showDeleteConfirmationDialog(int index) {
  Get.dialog(
    AlertDialog(
      title: Text(
        "Confirm Deletion",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      content: Text(
        "Are you sure you want to delete this row?",
        style: TextStyle(color: Colors.black87),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(), 
          child: Text("No", style: TextStyle(color: Colors.blue)),
        ),
        TextButton(
          onPressed: () {
           deleteRowAtIndex(index);
            Get.back(); 
          },
          child: Text("Yes", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
    barrierDismissible: false,
  );
}

Future<void> deleteRowAtIndex(int index) async {
  tableScreenLoadingStatus.value = RxStatus.loading();

  try {
    final taskId = taskDataList[index].id;

   
    final db = await homeScreenControllers.databaseService.database;
    await db.delete(
      homeScreenControllers.databaseService.tasksTableName,
      where: 'id = ?',
      whereArgs: [taskId],
    );
    await homeScreenControllers.updateHomeData();
    await fetchTableData();

    tableScreenLoadingStatus.value = RxStatus.success();
  } catch (e) {
    print('Error deleting row: ${e.toString()}');
    tableScreenLoadingStatus.value = RxStatus.error('Failed to delete row');
  }
}



void endCurrentSessionClicked() async{
  try {
    tableScreenLoadingStatus = RxStatus.loading().obs;
    HistoryModels historyModels = HistoryModels(
    currentDateAndTime: DateTime.now(),
    finalPckValue: homeScreenControllers.pckValue.value,
    finalMSValue: homeScreenControllers.msValueOrHsd.value,
    listOfFlSpot: homeScreenControllers.chartData,
  );
   await Get.find<PrefUtils>().addJsonToList(historyModels.toJson(), "history_data");
   print(historyModels.toJson());
   tableScreenLoadingStatus = RxStatus.success().obs;
  } catch (e) {
    print('something went wrong ${e.toString()}');
  }

}

}
