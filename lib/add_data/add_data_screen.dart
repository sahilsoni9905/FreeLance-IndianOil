import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oil_solution/add_data/controllers/add_data_screen_controllers.dart';
import 'package:oil_solution/services/scale_utils_service.dart';

class AddDataScreen extends GetView<AddDataScreenControllers> {
  @override
  Widget build(BuildContext context) {
    Get.put(AddDataScreenControllers());
    ScalingUtility scale = ScalingUtility(context: context)..setCurrentDeviceSize();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF4A9CE0),
        title: Text(
          "Add Data To Your Table",
          style: GoogleFonts.plusJakartaSans(
            fontSize: scale.getScaledFont(20),
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: scale.getPadding(all: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Global Constant Data',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: scale.getScaledFont(22),
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: scale.getScaledHeight(16)),
              buildInputField(
                scale,
                "Pure PCK Density",
                TextInputType.number,
                controller.purePCKController,
                (value) => controller.setAvgPckDensity(value),
              ),
              SizedBox(height: scale.getScaledHeight(16)),
              buildInputField(
                scale,
                "Pure MS Density",
                TextInputType.number,
                controller.pureMSController,
                (value) => controller.setAvgPckDensity(value),
              ),
              SizedBox(height: scale.getScaledHeight(16)),
              Divider(height: 5, thickness: 5, color: Colors.grey.shade300),
              SizedBox(height: scale.getScaledHeight(16)),
              buildInputField(
                scale,
                "Avg PCK- MS Density kg/cm3",
                TextInputType.number,
                controller.avgPckDensityController,
                (value) => controller.setAvgPckDensity(value),
              ),
              SizedBox(height: scale.getScaledHeight(16)),
              buildInputField(
                scale,
                "Interface Density kg/cm3",
                TextInputType.number,
                controller.interfaceDensityController,
                (value) => controller.setInterfaceDensity(value),
              ),
              SizedBox(height: scale.getScaledHeight(16)),
              buildInputField(
                scale,
                "Time",
                TextInputType.datetime,
                controller.timeController,
                null,
                hintText: "HH:MM",
                isTimeField: true,
              ),
              SizedBox(height: scale.getScaledHeight(16)),
              buildInputField(
                scale,
                "Flow Rate KL/Hr",
                TextInputType.numberWithOptions(decimal: true),
                controller.flowRateController,
                (value) => controller.setFlowRate(value),
                isFlowRateField: true,
              ),
              SizedBox(height: scale.getScaledHeight(20)),
              buildButton(scale),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
    ScalingUtility scale,
    String heading,
    TextInputType inputType,
    TextEditingController Textcontroller,
    Function(String)? onChanged, {
    String? hintText,
    bool isTimeField = false,
    bool isFlowRateField = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              heading,
              style: GoogleFonts.plusJakartaSans(
                fontSize: scale.getScaledFont(16),
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            if (isTimeField)
              TextButton(
                onPressed: () => this.controller.selectTime(Get.context!),
                child: Text(
                  "Set Time",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: scale.getScaledFont(14),
                    color: Color(0xFF4A9CE0),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: scale.getScaledHeight(8)),
        TextField(
          controller: Textcontroller,
          readOnly: isTimeField,
          onChanged: onChanged,
          keyboardType: inputType,
          onTap: isTimeField ? () => this.controller.selectTime(Get.context!) : null,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(scale.getScaledWidth(10)),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(scale.getScaledWidth(10)),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(scale.getScaledWidth(10)),
              borderSide: BorderSide(color: Color(0xFF4A9CE0)),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: scale.getScaledHeight(12),
              horizontal: scale.getScaledWidth(16),
            ),
          ),
        ),
        isFlowRateField
            ? Obx(() {
                return Text(
                  'In Kl/min the value is: ${controller.flowRateInKlPerMin}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: scale.getScaledFont(14),
                    color: Colors.black54,
                  ),
                );
              })
            : const SizedBox(),
      ],
    );
  }

  Widget buildButton(ScalingUtility scale) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            controller.addDataToDatabase();
          },
          child: Text(
            'Add Data To Table',
            style: GoogleFonts.plusJakartaSans(
              fontSize: scale.getScaledFont(16),
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF9BC7EB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(scale.getScaledWidth(10)),
            ),
            padding: EdgeInsets.symmetric(
              vertical: scale.getScaledHeight(12),
              horizontal: scale.getScaledWidth(30),
            ),
            elevation: 4,
          ),
        ),
      ],
    );
  }
}
