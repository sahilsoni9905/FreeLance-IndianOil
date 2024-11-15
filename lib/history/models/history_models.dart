import 'package:fl_chart/fl_chart.dart';

class HistoryModels {
  final double finalPckValue;
  final double finalMSValue;
  final DateTime currentDateAndTime;
  final List<FlSpot> listOfFlSpot;

  HistoryModels({
    required this.finalPckValue,
    required this.finalMSValue,
    required this.currentDateAndTime,
    required this.listOfFlSpot,
  });

 
  HistoryModels copyWith({
    double? finalPckValue,
    double? finalMSValue,
    DateTime? currentDateAndTime,
    List<FlSpot>? listOfFlSpot,
  }) {
    return HistoryModels(
      finalPckValue: finalPckValue ?? this.finalPckValue,
      finalMSValue: finalMSValue ?? this.finalMSValue,
      currentDateAndTime: currentDateAndTime ?? this.currentDateAndTime,
      listOfFlSpot: listOfFlSpot ?? this.listOfFlSpot,
    );
  }


  factory HistoryModels.fromJson(Map<String, dynamic> json) {
    return HistoryModels(
      finalPckValue: (json['finalPckValue'] as num).toDouble(),
      finalMSValue: (json['finalMSValue'] as num).toDouble(),
      currentDateAndTime: DateTime.parse(json['currentDateAndTime']),
      listOfFlSpot: (json['listOfFlSpot'] as List)
          .map((item) => FlSpot((item['x'] as num).toDouble(), (item['y'] as num).toDouble()))
          .toList(),
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'finalPckValue': finalPckValue,
      'finalMSValue': finalMSValue,
      'currentDateAndTime': currentDateAndTime.toIso8601String(),
      'listOfFlSpot': listOfFlSpot.map((spot) => {'x': spot.x, 'y': spot.y}).toList(),
    };
  }
}
