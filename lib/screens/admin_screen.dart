import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/fault_code.dart';
import '../services/hive_service.dart';
import '../services/json_service.dart';
import 'add_edit_fault_screen.dart';
import 'details_screen.dart';
import 'search_screen.dart';
import '../widgets/industrial_panel.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<FaultCode> faults = [];
  bool loading = true;
  bool showFabMenu = false;
  String sortMode = "none";

  @override
  void initState() {
    super.initState();
    loadFaults();
  }

  Future<void> loadFaults() async {
    setState(() => loading = true);

    faults = HiveService.getAllFaultCodes();

    if (sortMode == "model_asc") {
      faults.sort((a, b) => a.truckModel.compareTo(b.truckModel));
    } else if (sortMode == "model_desc") {
      faults.sort((a, b) => b.truckModel.compareTo(a.truckModel));
    }

    setState(() => loading = false);
  }

  // تم تنسيق AlertDialog ليتوافق مع الثيم الصناعي
  Future<void> _deleteFault(FaultCode fault) async {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("تأكيد الحذف", style: text.displayMedium),
        content: Text("هل تريد حذف هذا الخطأ؟", style: text.bodyLarge),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("إلغاء",
                  style: text.bodyLarge?.copyWith(color: cs.onSurface))),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: cs.error,
              foregroundColor: cs.onError,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("حذف"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await HiveService.deleteFaultCode(fault.id);
      await loadFaults();
    }
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
        // ⭐ 1. إلغاء زر الرجوع الأبيض الافتراضي
        automaticallyImplyLeading: false,

        // ⭐ 2. leading (أقصى اليمين): زر المنزل فقط
        leading: IconButton(
          icon: Icon(Icons.home, color: cs.primary),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SearchScreen()),
            (Route<dynamic> route) => false,
          ),
        ),

        title: Text("لوحة التحكم", style: text.displayMedium),

        // ⭐ 3. قائمة الترتيب في Actions (أقصى اليسار)
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort, color: cs.primary),
            color: cs.surface,
            onSelected: (value) {
              setState(() => sortMode = value);
              loadFaults();
            },
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                    value: "none",
                    child: Text("بدون ترتيب", style: text.bodyMedium)),
                PopupMenuItem(
                    value: "model_asc",
                    child: Text("ترتيب حسب الموديل ↑", style: text.bodyMedium)),
                PopupMenuItem(
                    value: "model_desc",
                    child: Text("ترتيب حسب الموديل ↓", style: text.bodyMedium)),
              ];
            },
          ),
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(color: cs.primary))
          : faults.isEmpty
              ? Center(
                  child: Text("لا توجد أخطاء بعد",
                      style: text.displayMedium
                          ?.copyWith(color: cs.primary.withOpacity(0.8))))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    itemCount: faults.length,
                    itemBuilder: (context, index) {
                      final fault = faults[index];

                      // ⭐ استخدام IndustrialPanel بدلاً من Card
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: IndustrialPanel(
                          borderRadius: 12,
                          padding: EdgeInsets.zero,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailsScreen(fault: fault),
                              ),
                            ),
                            title: Text(
                              fault.code,
                              style: text.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.primary), // 🟡 كود الخطأ أصفر
                            ),
                            subtitle: Text(
                              fault.truckModel,
                              // ⭐ توحيد الخطوط
                              style: text.bodyMedium!.copyWith(
                                color: cs.onSurface.withOpacity(0.7),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color:
                                          cs.primary), // ⭐ أيقونة التعديل صفراء
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            AddEditFaultScreen(fault: fault),
                                      ),
                                    ).then((_) => loadFaults());
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: cs.error), // ⭐ أيقونة الحذف حمراء
                                  onPressed: () => _deleteFault(fault),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: _fabMenu(),
    );
  }

  // ⭐ تم تنسيق قائمة FAB باللون الأصفر والستايل الصناعي
  Widget _fabMenu() {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;

    return Stack(
      children: [
        if (showFabMenu)
          Positioned(
            bottom: 90,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _fabItem(
                  icon: Icons.add,
                  label: "إضافة",
                  onTap: () {
                    setState(() => showFabMenu = false);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddEditFaultScreen(),
                      ),
                    ).then((_) => loadFaults());
                  },
                ),
                const SizedBox(height: 10),

                /// IMPORT JSON (TEXT INPUT)
                _fabItem(
                  icon: Icons.upload_file,
                  label: "استيراد JSON",
                  onTap: () async {
                    setState(() => showFabMenu = false);

                    final controller = TextEditingController();

                    showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          backgroundColor: cs.surface,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          title:
                              Text("لصق JSON هنا", style: text.displayMedium),
                          content: TextField(
                            controller: controller,
                            maxLines: 10,
                            // ⭐ تطبيق تنسيق حقل الإدخال الموحد
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              hintText: "ألصق محتوى JSON هنا...",
                              filled: theme.inputDecorationTheme.filled,
                              fillColor: theme.inputDecorationTheme.fillColor,
                              hintStyle: theme.inputDecorationTheme.hintStyle,
                            ),
                            style: text.bodyMedium,
                          ),
                          actions: [
                            TextButton(
                              child: Text("إلغاء", style: text.bodyLarge),
                              onPressed: () => Navigator.pop(context),
                            ),
                            ElevatedButton(
                              // ⭐ استخدام ElevatedButton
                              child: const Text("استيراد"),
                              onPressed: () async {
                                final ok = await JsonService.importFromString(
                                    controller.text.trim());

                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: ok ? cs.primary : cs.error,
                                    content: Text(
                                      ok
                                          ? "تم الاستيراد بنجاح"
                                          : "فشل الاستيراد. تحقق من التنسيق.",
                                      style: text.bodyLarge
                                          ?.copyWith(color: cs.onPrimary),
                                    ),
                                  ),
                                );

                                loadFaults();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 10),

                /// EXPORT JSON
                _fabItem(
                  icon: Icons.share,
                  label: "مشاركة JSON",
                  onTap: () async {
                    setState(() => showFabMenu = false);

                    final json = JsonService.exportAsString();
                    Share.share(json);
                  },
                ),
              ],
            ),
          ),
        Positioned(
          bottom: 16,
          left: 16,
          child: FloatingActionButton(
            onPressed: () => setState(() => showFabMenu = !showFabMenu),
            backgroundColor: cs.primary, // ⭐ أصفر
            foregroundColor: cs.onPrimary, // نص أسود
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Icon(showFabMenu ? Icons.close : Icons.menu, size: 30),
          ),
        ),
      ],
    );
  }

  Widget _fabItem(
      {required IconData icon,
      required String label,
      required Function() onTap}) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return FloatingActionButton.extended(
      heroTag: label,
      backgroundColor: cs.primary.withOpacity(0.95), // ⭐ أصفر قوي
      foregroundColor: cs.onPrimary,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label, style: theme.textTheme.labelLarge),
    );
  }
}
