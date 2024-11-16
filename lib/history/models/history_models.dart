import 'package:fl_chart/fl_chart.dart';

class HistoryModels {
  final double finalPckValue;
  final double finalMSValue;
  final DateTime currentDateAndTime;
  final List<FlSpot> listOfFlSpot;
  final bool isTable1;

  HistoryModels({
    required this.finalPckValue,
    required this.finalMSValue,
    required this.currentDateAndTime,
    required this.listOfFlSpot,
    required this.isTable1,
  });

  HistoryModels copyWith({
    double? finalPckValue,
    double? finalMSValue,
    DateTime? currentDateAndTime,
    List<FlSpot>? listOfFlSpot,
    bool? isTable1,
  }) {
    return HistoryModels(
      finalPckValue: finalPckValue ?? this.finalPckValue,
      finalMSValue: finalMSValue ?? this.finalMSValue,
      currentDateAndTime: currentDateAndTime ?? this.currentDateAndTime,
      listOfFlSpot: listOfFlSpot ?? this.listOfFlSpot,
      isTable1: isTable1 ?? this.isTable1,
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
      isTable1: json['isTable1'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'finalPckValue': finalPckValue,
      'finalMSValue': finalMSValue,
      'currentDateAndTime': currentDateAndTime.toIso8601String(),
      'listOfFlSpot': listOfFlSpot.map((spot) => {'x': spot.x, 'y': spot.y}).toList(),
      'isTable1': isTable1,
    };
  }
}

class HistoryModels2 {
  final double finalPckValue;
  final double finalMSValue;
  final DateTime currentDateAndTime;
  final List<FlSpot> listOfFlSpot;
  final bool isTable1;

  HistoryModels2({
    required this.finalPckValue,
    required this.finalMSValue,
    required this.currentDateAndTime,
    required this.listOfFlSpot,
    required this.isTable1,
  });

  HistoryModels2 copyWith({
    double? finalPckValue,
    double? finalMSValue,
    DateTime? currentDateAndTime,
    List<FlSpot>? listOfFlSpot,
    bool? isTable1,
  }) {
    return HistoryModels2(
      finalPckValue: finalPckValue ?? this.finalPckValue,
      finalMSValue: finalMSValue ?? this.finalMSValue,
      currentDateAndTime: currentDateAndTime ?? this.currentDateAndTime,
      listOfFlSpot: listOfFlSpot ?? this.listOfFlSpot,
      isTable1: isTable1 ?? this.isTable1,
    );
  }

  factory HistoryModels2.fromJson(Map<String, dynamic> json) {
    return HistoryModels2(
      finalPckValue: (json['finalPckValue'] as num).toDouble(),
      finalMSValue: (json['finalMSValue'] as num).toDouble(),
      currentDateAndTime: DateTime.parse(json['currentDateAndTime']),
      listOfFlSpot: (json['listOfFlSpot'] as List)
          .map((item) => FlSpot((item['x'] as num).toDouble(), (item['y'] as num).toDouble()))
          .toList(),
      isTable1: json['isTable1'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'finalPckValue': finalPckValue,
      'finalMSValue': finalMSValue,
      'currentDateAndTime': currentDateAndTime.toIso8601String(),
      'listOfFlSpot': listOfFlSpot.map((spot) => {'x': spot.x, 'y': spot.y}).toList(),
      'isTable1': isTable1,
    };
  }
}
