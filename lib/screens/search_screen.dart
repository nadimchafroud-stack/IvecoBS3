import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../services/hive_service.dart';
import '../models/fault_code.dart';
import 'details_screen.dart';
import 'pin_entry_screen.dart';
import 'about_screen.dart';
import '../widgets/industrial_panel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController controller = TextEditingController();
  FaultCode? result;
  String? selectedTruck;
  bool searchPerformed = false;

  late List<String> truckModels;

  @override
  void initState() {
    super.initState();
    truckModels = HiveService.getAllFaultCodes()
        .map((f) => f.truckModel)
        .toSet()
        .toList();
  }

  void search() {
    final query = controller.text.trim().toLowerCase();
    final allFaults = HiveService.getAllFaultCodes();

    final fault = allFaults.firstWhereOrNull(
      (f) =>
          f.code.toLowerCase().contains(query) &&
          (selectedTruck == null || f.truckModel == selectedTruck),
    );

    setState(() {
      result = fault;
      searchPerformed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: const Text(""),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline, color: cs.primary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutScreen()),
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: cs.primary),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PinEntryScreen()),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),

            /// ---------- عنوان IVECO ----------
            Text(
              "IVECO",
              textAlign: TextAlign.center,
              style: text.displayLarge?.copyWith(
                fontSize: 60,
                letterSpacing: 3.0,
                color: cs.primary,
              ),
            ),

            const SizedBox(height: 8),

            /// ---------- أيقونة المفتاح ----------
            Icon(
              Icons.build,
              size: 40,
              color: cs.onSurface.withOpacity(0.7),
            ),

            const SizedBox(height: 35),

            /// ---------- اختيار الشاحنة (Dropdown داخل IndustrialPanel) ----------
            IndustrialPanel(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  dropdownColor: cs.surface,
                  value: selectedTruck,
                  isExpanded: true,
                  icon:
                      Icon(Icons.arrow_drop_down, color: cs.primary, size: 30),
                  // ⭐ تنسيق النص المختار
                  style: text.bodyLarge?.copyWith(
                    color: cs.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                  hint: Text(
                    "اختر نوع الشاحنة",
                    textDirection: TextDirection.rtl,
                    // ⭐ تنسيق نص الـ Hint
                    style: text.bodyLarge?.copyWith(
                      color: cs.onSurface.withOpacity(0.55),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  items: truckModels
                      .map((truck) => DropdownMenuItem(
                            value: truck,
                            child: Text(
                              truck,
                              textDirection: TextDirection.ltr,
                              // ⭐ تنسيق نصوص العناصر في القائمة
                              style: text.bodyLarge?.copyWith(
                                color: cs.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (val) => setState(() => selectedTruck = val),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ---------- صندوق البحث (TextField) وزر البحث ----------
            IndustrialPanel(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    textAlign: TextAlign.center,
                    // ⭐ تنسيق النص المُدخل
                    style: text.headlineSmall?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      hintText: " ادخل رمز الخطأ ",
                      // ⭐ تنسيق نص الـ Hint
                      hintStyle: text.bodyMedium?.copyWith(
                        color: cs.onSurface.withOpacity(0.4),
                      ),

                      // تحسين التباين والإطار
                      filled: true,
                      fillColor: cs.onSurface.withOpacity(0.08),

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: cs.primary.withOpacity(0.3), width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: cs.primary, width: 2.0),
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: search,
                      icon: const Icon(Icons.search, size: 26),
                      label: Text("بحث", style: text.labelLarge),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// ---------- النتيجة (يستخدم isHighlighted لتمييز النتيجة الصفراء) ----------
            if (result != null)
              IndustrialPanel(
                isHighlighted: true,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsScreen(fault: result!),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        result!.code,
                        style: text.displayMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result!.truckModel,
                        style: text.bodyLarge?.copyWith(
                          color: cs.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "  درجة الخطورة: ${result!.severity}  ",
                        style: text.bodyLarge?.copyWith(
                          color: const Color(0xFFF44336),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (searchPerformed)
              IndustrialPanel(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "  لا توجد نتائج مطابقة  ",
                  textAlign: TextAlign.center,
                  style: text.bodyLarge?.copyWith(
                    color: const Color(0xFFF44336),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
