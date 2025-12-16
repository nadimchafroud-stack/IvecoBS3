import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/fault_code.dart';
import 'hive_service.dart';

class DefaultDataLoader {
  static Future<void> loadIfEmpty() async {
    // 1️⃣ تحقق إذا كانت قاعدة Hive فارغة
    final existing = HiveService.getAllFaultCodes();
    if (existing.isNotEmpty) return;

    // 2️⃣ قراءة JSON
    final jsonStr =
        await rootBundle.loadString('assets/data/fault_codes.json');
    final List data = json.decode(jsonStr);

    // 3️⃣ مجلد الصور داخل التطبيق
    final dir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${dir.path}/images');
    if (!await imageDir.exists()) {
      await imageDir.create(recursive: true);
    }

    // 4️⃣ إدخال البيانات
    for (final item in data) {
      String? imagePath;

      if (item['imagePath'] != null) {
        final bytes =
            await rootBundle.load('assets/images/${item['imagePath']}');
        final file = File('${imageDir.path}/${item['imagePath']}');
        await file.writeAsBytes(bytes.buffer.asUint8List());
        imagePath = file.path;
      }

      final fault = FaultCode(
        id: const Uuid().v4(),
        code: item['code'],
        truckModel: item['truckModel'],
        descAr: item['descAr'],
        descEn: item['descEn'],
        descFr: item['descFr'],
        possibleCauses: List<String>.from(item['possibleCauses'] ?? []),
        imagePath: imagePath,
        severity: item['severity'] ?? 'Low',
      );

      await HiveService.addFaultCode(fault);
    }
  }
}
