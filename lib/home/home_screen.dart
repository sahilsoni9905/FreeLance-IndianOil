import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oil_solution/add_data/add_data_screen.dart';
import 'package:oil_solution/history/history_list_screen.dart';
import 'package:oil_solution/home/controllers/home_screen_controllers.dart';
import 'package:oil_solution/services/scale_utils_service.dart';
import 'package:oil_solution/table/table_screen.dart';

class HomeScreen extends GetView<HomeScreenControllers> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenControllers());
    ScalingUtility scale = ScalingUtility(context: context)..setCurrentDeviceSize();

    return buildHomeScreen(scale, context);
  }

  Widget buildHomeScreen(ScalingUtility scale, BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Home Dashboard",
          style: GoogleFonts.plusJakartaSans(
            fontSize: scale.getScaledFont(20),
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          Obx(() {
            return Switch(
              value: controller.isToggled.value,
              activeColor: const Color.fromARGB(255, 6, 99, 175),
              onChanged: (value) {
                  controller.toggleButtonClicked(value);
              },
            );
          }),
        ],
      ),
      drawer: buildSideDrawer(scale),
      body: Obx(() {
        if (controller.homeScreenLoadingStatus.value.isLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.all(scale.getScaledHeight(12)),
          child: ListView(
            children: [
              buildLastUpdatedAt(scale),
              SizedBox(height: scale.getScaledHeight(20)),
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

  Widget buildLastUpdatedAt(ScalingUtility scale) {
    return Padding(
      padding: scale.getPadding(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() {
            return Text(
              'Last updated at : ${controller.lastUpdatedAt}',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w500,
                fontSize: scale.getScaledFont(12),
                color: Colors.grey[600],
              ),
            );
          }),
          Text(
            controller.toggledText.value,
            style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w500,
                fontSize: scale.getScaledFont(15),             
              ),
          )
        ],
      ),
    );
  }

  Widget buildFinalKclCalculation(ScalingUtility scale) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: scale.getScaledWidth(10)),
      child: Column(
        children: [
          Text(
            'Final QTY KL value of',
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
                  title: !controller.isToggled.value ? 'MS' : 'HSD',
                  value: controller.msValueOrHsd.value.toString(),
                  color: !controller.isToggled.value ? Color.fromARGB(255, 255, 87, 34) : Colors.blue,
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
            if (controller.chartData.value.isEmpty) return SizedBox();

            double minX = controller.chartData.value.first.x;
            double maxX = controller.chartData.value.last.x;
            double minY = controller.chartData.value.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) - 100;
            double maxY = controller.chartData.value.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 100;
            double intervalY = (maxY - minY) / 4;

            return LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(   
                    spots: controller.chartData,
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
                      interval: intervalY > 0 ? intervalY : 1, 
                      reservedSize: scale.getScaledWidth(35),  
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
                gridData: FlGridData(show: true),
                minY: minY,
                maxY: maxY,
              ),
            );
          }),
        ),
      ],
    ),
  );
}


  Widget buildSideDrawer(ScalingUtility scale) {
  return Drawer(
    child: ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            image:  DecorationImage(
              image: AssetImage('assets/indian oil.png'),
              fit: BoxFit.contain,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
                BlendMode.darken,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              (Platform.isWindows || Platform.isLinux || Platform.isMacOS) ?
              SizedBox() :
              Icon(
                Icons.local_gas_station,
                color: Colors.amber,
                size: scale.getScaledWidth(40).floorToDouble(), 
              ),
              SizedBox(height: scale.getScaledHeight(8).floorToDouble()), 
              (Platform.isWindows || Platform.isLinux || Platform.isMacOS) ?
              SizedBox() :
              Text(
                'Dashboard Menu',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: (Platform.isWindows || Platform.isLinux || Platform.isMacOS) ? scale.getScaledWidth(8) : scale.getScaledFont(24),
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              (Platform.isWindows || Platform.isLinux || Platform.isMacOS) ?
              SizedBox() :
              Text(
                'Manage Petroleum Data Effortlessly',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: scale.getScaledFont(14),
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
        buildDrawerOption(
          scale,
          'Dashboard',
          Icons.dashboard,
          () => Get.back(),
        ),
        buildDrawerOption(
          scale,
          'History',
          Icons.history,
          () => Get.to(HistoryListScreen()),
        ),
        buildDrawerOption(
          scale,
          'Add Data',
          Icons.add,
          () => Get.to(AddDataScreen()),
        ),
        buildDrawerOption(
          scale,
          'Tables',
          Icons.table_chart,
          () => Get.to(TableScreen()),
        ),
      ],
    ),
  );
}


  Widget buildDrawerOption(ScalingUtility scale, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: scale.getScaledFont(16),
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      onTap: onTap,
    );
  }

Widget buildPieChart(ScalingUtility scale) {
  return Padding(
    padding: scale.getPadding(horizontal: 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: scale.getScaledHeight(20)),
        Row(
          children: [
            Text(
              'Pie Chart',
              style: GoogleFonts.plusJakartaSans(
                fontSize: scale.getScaledFont(20),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: scale.getScaledHeight(10)),
        Padding(
          padding: scale.getPadding(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              Container(
                height: scale.getScaledHeight(200),
                width: scale.getScaledWidth(200), 
                child: PieChart(
                  PieChartData( 
                    sectionsSpace: 10,                 
                    centerSpaceRadius: 0,
                    sections: controller.piechartSection(scale),
                  ),
                ),
              ),
              SizedBox(width: scale.getScaledWidth(20),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        color: Colors.red,
                      ),
                       SizedBox(width: scale.getScaledWidth(5),),
                  Text(
                    'PCM',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: scale.getScaledFont(15),
                    ),

                  )
                    ],
                  ),
                  SizedBox(height: scale.getScaledHeight(20),),
                  Row(
                    children: [
                      Container(
                        height: 15,
                        width: 15,
                        color: Colors.green,
                      ),
                       SizedBox(width: scale.getScaledWidth(5),),
                  Text(
                    'MS',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: scale.getScaledFont(15),
                    ),

                  )
                    ],
                  ),
                 
                ],
              )
            ],
          ),
        ),
        SizedBox(height: scale.getScaledHeight(20)),
      ],
    ),
  );
}

}
