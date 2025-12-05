// lib/services/hive_service.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../models/fault_code.dart';

class HiveService {
  static const String boxName = 'fault_codes';

  static Future<void> init() async {
    // Avoid re-initializing / re-opening
    await Hive.initFlutter();

    // Register adapter once
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(FaultCodeAdapter());
    }

    // Open box if not open
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<FaultCode>(boxName);
    }
  }

  static Box<FaultCode> get box => Hive.box<FaultCode>(boxName);

  /// GET ALL
  static List<FaultCode> getAllFaultCodes() {
    return box.values.toList();
  }

  /// ADD
  static Future<void> addFaultCode(FaultCode code) async {
    await box.put(code.id, code);
  }

  /// UPDATE
  static Future<void> updateFaultCode(FaultCode code) async {
    await box.put(code.id, code);
  }

  /// DELETE
  static Future<void> deleteFaultCode(String id) async {
    await box.delete(id);
  }

  /// CLEAR ALL
  static Future<void> clearAllFaultCodes() async {
    await box.clear();
  }
}
