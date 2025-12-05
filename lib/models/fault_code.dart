import 'package:hive_flutter/hive_flutter.dart';
part 'fault_code.g.dart';

@HiveType(typeId: 0)
class FaultCode extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String code;
  @HiveField(2)
  final String truckModel;
  @HiveField(3)
  final String descAr;
  @HiveField(4)
  final String descFr;
  @HiveField(5)
  final String descEn;
  @HiveField(6)
  final List<String> possibleCauses;
  @HiveField(7)
  final String? imagePath;
  @HiveField(8)
  final String severity;

  FaultCode({
    required this.id,
    required this.code,
    required this.truckModel,
    required this.descAr,
    required this.descFr,
    required this.descEn,
    required this.possibleCauses,
    this.imagePath,
    this.severity = 'Low',
  });

  /// JSON → EXPORT
  Map<String, dynamic> toJson() => toMap();

  /// JSON → IMPORT
  factory FaultCode.fromJson(Map<String, dynamic> json) =>
      FaultCode.fromMap(json);

  /// -------------------------
  /// MISSING FUNCTIONS (FIX)
  /// -------------------------

  /// تحويل JSON → نموذج
  factory FaultCode.fromMap(Map<String, dynamic> map) {
    return FaultCode(
      id: map['id'] ?? '',
      code: map['code'] ?? '',
      truckModel: map['truckModel'] ?? '',
      descAr: map['descAr'] ?? '',
      descFr: map['descFr'] ?? '',
      descEn: map['descEn'] ?? '',
      possibleCauses: (map['possibleCauses'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      imagePath: map['imagePath'],
      severity: map['severity'] ?? 'Low',
    );
  }

  /// تحويل النموذج → JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'truckModel': truckModel,
      'descAr': descAr,
      'descFr': descFr,
      'descEn': descEn,
      'possibleCauses': possibleCauses,
      'imagePath': imagePath,
      'severity': severity,
    };
  }
}
