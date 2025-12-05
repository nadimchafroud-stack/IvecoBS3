import 'dart:convert';
import '../models/fault_code.dart';
import 'hive_service.dart';

class JsonService {
  /// EXPORT → يرجّع محتوى JSON كنص
  static String exportAsString() {
    final faults = HiveService.getAllFaultCodes();

    final data = {
      "faults": faults.map((e) => e.toMap()).toList(),
    };

    return jsonEncode(data);
  }

  /// IMPORT → يستقبل نص JSON ويدخله في Hive
  static Future<bool> importFromString(String jsonStr) async {
    try {
      final json = jsonDecode(jsonStr);

      if (json is! Map) return false;
      if (!json.containsKey("faults")) return false;

      final List faultsList = json["faults"];

      await HiveService.clearAllFaultCodes();

      for (var item in faultsList) {
        HiveService.addFaultCode(FaultCode.fromMap(item));
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
