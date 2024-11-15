import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oil_solution/history/controllers/history_list_screen_controllers.dart';
import 'package:oil_solution/services/scale_utils_service.dart';

class HistoryListScreen extends GetView<HistoryListScreenControllers> {
  @override
  Widget build(BuildContext context) {
    Get.put(HistoryListScreenControllers());
    ScalingUtility scale = ScalingUtility(context: context)..setCurrentDeviceSize();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 74, 156, 224),
        title: Text(
          "History Table",
          style: GoogleFonts.plusJakartaSans(
            fontSize: scale.getScaledFont(20),
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Obx((){
      if(controller.historyListScreenLoadingStatus.value.isLoading){
        return Center(
          child: CircularProgressIndicator(          
          ),
        );
      }
      return Padding(
        padding: EdgeInsets.all(scale.getScaledWidth(10)),
        child: ListView.builder(
          itemCount: controller.historyModelsList.length ?? 0,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: scale.getScaledHeight(8)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: scale.getScaledHeight(12),
                  horizontal: scale.getScaledWidth(16),
                ),
                leading: Icon(
                  Icons.history,
                  color: Colors.blueAccent,
                  size: scale.getScaledFont(28),
                ),
                title: Text(
                  controller.formatDate(controller.historyModelsList[index].currentDateAndTime).toString(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: scale.getScaledFont(16),
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  'Past Records',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: scale.getScaledFont(14),
                    color: Colors.grey[700],
                  ),
                ),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                
                },
              ),
            );
          },
        ),
      );}),
    );
  }
}
