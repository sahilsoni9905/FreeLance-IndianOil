class TaskData {
  final int id;
  final double avgPckMsDensity;
  final double interfaceDensity;
  final String time; 
  final double percentOfPck;
  final double percentOfMs;
  final double qtyKlOfPck;
  final double qtyKlOfMs;
  final double totalKlInterface;

  TaskData({
    required this.id,
    required this.avgPckMsDensity,
    required this.interfaceDensity,
    required this.time,
    required this.percentOfPck,
    required this.percentOfMs,
    required this.qtyKlOfPck,
    required this.qtyKlOfMs,
    required this.totalKlInterface,
  });

  factory TaskData.fromMap(Map<String, dynamic> map) {
    return TaskData(
      id: map['id'] ?? 0,  // Default to 0 if null
      avgPckMsDensity: map['avg_pck_ms_density']?.toDouble() ?? 0.0,  // Default to 0.0 if null
      interfaceDensity: map['interface_density']?.toDouble() ?? 0.0,  // Default to 0.0 if null
      time: map['time'] ?? '',  // Default to empty string if null
      percentOfPck: map['percent_of_pck']?.toDouble() ?? 0.0,  // Default to 0.0 if null
      percentOfMs: map['percent_of_ms']?.toDouble() ?? 0.0,  // Default to 0.0 if null
      qtyKlOfPck: map['qty_kl_of_pck']?.toDouble() ?? 0.0,  // Default to 0.0 if null
      qtyKlOfMs: map['qty_kl_of_ms']?.toDouble() ?? 0.0,  // Default to 0.0 if null
      totalKlInterface: map['total_kl_interface']?.toDouble() ?? 0.0,  // Default to 0.0 if null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'avg_pck_ms_density': avgPckMsDensity,
      'interface_density': interfaceDensity,
      'time': time, 
      'percent_of_pck': percentOfPck,
      'percent_of_ms': percentOfMs,
      'qty_kl_of_pck': qtyKlOfPck,
      'qty_kl_of_ms': qtyKlOfMs,
      'total_kl_interface': totalKlInterface,
    };
  }
}
