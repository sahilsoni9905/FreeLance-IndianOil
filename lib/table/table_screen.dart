import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oil_solution/services/scale_utils_service.dart';
import 'package:oil_solution/table/controllers/table_screen_controllers.dart';

class TableScreen extends GetView<TableScreenControllers> {
  @override
  Widget build(BuildContext context) {
    Get.put(TableScreenControllers());
    ScalingUtility scale = ScalingUtility(context: context)..setCurrentDeviceSize();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 74, 156, 224),
        title: Text(
          "Current Table Data",
          style: GoogleFonts.plusJakartaSans(
            fontSize: scale.getScaledFont(20),
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Obx(() {
        if (controller.tableScreenLoadingStatus.value.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 74, 156, 224),
            ),
          );
        }
        return SafeArea(
          child: SizedBox.expand(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: controller.getDataColumns(scale),
                        rows: controller.getDataRows(scale),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: scale.getScaledHeight(20)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: scale.getScaledWidth(16)),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialogue(scale);
                    },
                    child: Text(
                      'End Current Session',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: scale.getScaledFont(16),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 74, 156, 224),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(scale.getScaledWidth(10)),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: scale.getScaledHeight(12),
                        horizontal: scale.getScaledWidth(32),
                      ),
                      elevation: 4,
                    ),
                  ),
                ),
                SizedBox(height: scale.getScaledHeight(20)),
              ],
            ),
          ),
        );
      }),
    );
  }

  void showDialogue(ScalingUtility scale) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(scale.getScaledWidth(15)),
        ),
        title: Text(
          'End Current Session?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: scale.getScaledFont(18),
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'It will clear the table and store the analytics data in history.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: scale.getScaledFont(14),
                color: Colors.black87,
              ),
            ),
            SizedBox(height: scale.getScaledHeight(16)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.endCurrentSessionClicked();
              Get.back();
            },
            child: Text(
              'Yes',
              style: GoogleFonts.plusJakartaSans(
                fontSize: scale.getScaledFont(16),
                color: Colors.green,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'No',
              style: GoogleFonts.plusJakartaSans(
                fontSize: scale.getScaledFont(16),
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
