

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oil_solution/history/controllers/history_screen_controllers.dart';
import 'package:oil_solution/home/controllers/home_screen_controllers.dart';
import 'package:oil_solution/services/scale_utils_service.dart';

class HistoryScreen extends GetView<HistoryScreenControllers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Get.put(HistoryScreenControllers());
    ScalingUtility scale = ScalingUtility(context: context)..setCurrentDeviceSize();

    return buildHistoryScreen(scale, context);
  }

  Widget buildHistoryScreen(ScalingUtility scale, BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Histroy Screen",
          style: GoogleFonts.plusJakartaSans(
            fontSize: scale.getScaledFont(20),
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      drawer: buildSideDrawer(scale),
      body: Obx(() {
        if (controller.histroyScreenLoadingStatus.value.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.all(scale.getScaledHeight(12)),
          child: ListView(
            children: [
              buildFinalKclCalculation(scale),
              SizedBox(height: scale.getScaledHeight(20)),
              buildLineGraphData(scale),
              SizedBox(height: scale.getScaledHeight(20)),
              buildPieChart(scale),
            ],
          ),
        );
      }),
    );
  }



  Widget buildFinalKclCalculation(ScalingUtility scale) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: scale.getScaledWidth(10)),
      child: Column(
        children: [
          Text(
            'Final PCK and MS Value',
            style: GoogleFonts.plusJakartaSans(
              fontSize: scale.getScaledFont(20),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: scale.getScaledHeight(20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: buildValueCard(
                  scale,
                  title: 'PCK',
                  value: controller.pckValue.value.toString(),
                  color: Color.fromARGB(255, 177, 160, 2),
                ),
              ),
              SizedBox(width: scale.getScaledWidth(10)),
              Expanded(
                child: buildValueCard(
                  scale,
                  title: 'MS',
                  value: controller.msValue.value.toString(),
                  color: Color.fromARGB(255, 255, 87, 34),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildValueCard(ScalingUtility scale, {required String title, required String value, required Color color}) {
    return Card(
      elevation: 8,
      shadowColor: color.withOpacity(0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: scale.getPadding(horizontal: 15, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: scale.getScaledFont(18),
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(height: scale.getScaledHeight(10)),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: scale.getScaledFont(24),
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLineGraphData(ScalingUtility scale) {
  return Padding(
    padding: scale.getPadding(horizontal: 5),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              'Graph Data',
              style: GoogleFonts.plusJakartaSans(
                fontSize: scale.getScaledFont(20),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: scale.getScaledHeight(15)),
        Container(
          width: scale.fullWidth,
          height: scale.getScaledHeight(180),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Obx(() {
            // if (controller.chartData.value.isEmpty) return SizedBox();

            // double minX = controller.chartData.value.first.x;
            // double maxX = controller.chartData.value.last.x;
            // double minY = controller.chartData.value.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) - 100;
            // double maxY = controller.chartData.value.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 100;
            // double intervalY = (maxY - minY) / 4;

            return LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                  //  spots: controller.chartData,
                    isCurved: false,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: true, color: Colors.blueAccent.withOpacity(0.2)),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        return Container(
                          width: scale.getScaledWidth(30),  
                          child: Text(
                            value.toStringAsFixed(0),  
                            style: TextStyle(
                              fontSize: scale.getScaledFont(10),
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center, 
                            overflow: TextOverflow.ellipsis, 
                          ),
                        );
                      },
                    //  interval: intervalY > 0 ? intervalY : 1, 
                      reservedSize: scale.getScaledWidth(35),  
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
                gridData: FlGridData(show: true),
                // minY: minY,
                // maxY: maxY,
              ),
            );
          }),
        ),
      ],
    ),
  );
}


 
}
