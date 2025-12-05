import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/fault_code.dart';
import '../services/hive_service.dart';
import '../services/image_handler.dart';
import '../widgets/industrial_panel.dart'; // استيراد الويدجت الصناعي

class AddEditFaultScreen extends StatefulWidget {
  final FaultCode? fault;
  const AddEditFaultScreen({super.key, this.fault});

  @override
  State<AddEditFaultScreen> createState() => _AddEditFaultScreenState();
}

class _AddEditFaultScreenState extends State<AddEditFaultScreen> {
  final _codeController = TextEditingController();
  final _truckModelController = TextEditingController();
  final _descArController = TextEditingController();
  final _descEnController = TextEditingController();
  final _descFrController = TextEditingController();
  final _causesController = TextEditingController();

  String? _imagePath;
  String _severity = 'Low';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.fault != null) {
      final f = widget.fault!;
      _codeController.text = f.code;
      _truckModelController.text = f.truckModel;
      _descArController.text = f.descAr;
      _descEnController.text = f.descEn;
      _descFrController.text = f.descFr;
      _causesController.text = f.possibleCauses.join('\n');
      _imagePath = f.imagePath;
      _severity = f.severity;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _truckModelController.dispose();
    _descArController.dispose();
    _descEnController.dispose();
    _descFrController.dispose();
    _causesController.dispose();
    super.dispose();
  }

  /// عنصر Input عام مناسب للثيم الموحد
  Widget _field(TextEditingController c, String label, {int max = 1}) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;

    return TextFormField(
      controller: c,
      maxLines: max,
      // تطبيق ستايل النص الأساسي من الثيم
      style: text.bodyLarge?.copyWith(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: label,
        // تغيير لون labelText ليتناسب مع الثيم الداكن
        labelStyle: text.bodyMedium?.copyWith(
          color: cs.onSurface.withOpacity(0.7),
        ),

        // ⭐⭐ التعديل الموحد للثيم الصناعي: ⭐⭐
        filled: true,
        fillColor: cs.surface, // خلفية داكنة للحقل

        // إطار حاد عند عدم التركيز
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: cs.onSurface.withOpacity(0.1), width: 1),
        ),

        // إطار التركيز الأصفر القوي
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: cs.primary, width: 2.5), // الحدود الصفراء البارزة
        ),

        // الحدود الافتراضية
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // ⭐⭐⭐ نهاية التعديل ⭐⭐⭐
      ),
      // إضافة تحقق بسيط للعناصر الأساسية
      validator: (value) {
        if (max == 1 && (value == null || value.trim().isEmpty)) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  Future<void> _pickImage() async {
    final path = await ImageHandler.pickImage();
    if (path != null) {
      setState(() => _imagePath = path);
    }
  }

  bool _existsFault(String code, String model) {
    final all = HiveService.getAllFaultCodes();
    // التحقق أثناء الإضافة فقط، وليس التعديل
    if (widget.fault != null &&
        widget.fault!.code == code &&
        widget.fault!.truckModel == model) {
      return false;
    }
    return all.any((f) => f.code == code && f.truckModel == model);
  }

  Future<void> _saveFault() async {
    final code = _codeController.text.trim();
    final model = _truckModelController.text.trim();
    final cs = Theme.of(context).colorScheme;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_existsFault(code, model)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: cs.error,
          content: const Text("هذا الكود موجود بالفعل لنفس الموديل"),
        ),
      );
      return;
    }

    final fault = FaultCode(
      id: widget.fault?.id ?? const Uuid().v4(),
      code: code,
      truckModel: model,
      descAr: _descArController.text.trim(),
      descEn: _descEnController.text.trim(),
      descFr: _descFrController.text.trim(),
      possibleCauses: _causesController.text
          .split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      imagePath: _imagePath,
      severity: _severity,
    );

    if (widget.fault == null) {
      await HiveService.addFaultCode(fault);
    } else {
      await HiveService.updateFaultCode(fault);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: cs.primary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.fault == null ? "إضافة رمز خطأ" : "تعديل رمز خطأ",
            style: text.displayMedium,
          ),
          centerTitle: true,
          // إضافة زر حفظ عند التعديل لسهولة الوصول (اختياري)
          actions: widget.fault != null
              ? [
                  IconButton(
                    icon: Icon(Icons.save, color: cs.primary),
                    onPressed: _saveFault,
                  )
                ]
              : null,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /// حقول الإدخال
                _field(_codeController, "رمز العطل"),
                const SizedBox(height: 15),

                _field(_truckModelController, "نوع الشاحنة"),
                const SizedBox(height: 15),

                _field(_descArController, "الوصف عربي", max: 3),
                const SizedBox(height: 15),

                _field(_descEnController, "الوصف إنجليزي", max: 3),
                const SizedBox(height: 15),

                _field(_descFrController, "الوصف فرنسي", max: 3),
                const SizedBox(height: 15),

                _field(_causesController, "الأسباب (سطر لكل سبب)", max: 5),
                const SizedBox(height: 15),

                // مستوى الخطورة (Dropdown) - تم توحيد الستايل
                DropdownButtonFormField<String>(
                  value: _severity,
                  decoration: InputDecoration(
                    labelText: "مستوى الخطورة",
                    labelStyle: text.bodyMedium?.copyWith(
                      color: cs.onSurface.withOpacity(0.7),
                    ),
                    suffixIcon: Icon(Icons.arrow_drop_down, color: cs.primary),

                    // ⭐ توحيد تنسيق DropdownButtonFormField
                    filled: true,
                    fillColor: cs.surface,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: cs.onSurface.withOpacity(0.1), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: cs.primary, width: 2.5),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  dropdownColor: cs.surface,
                  style: text.bodyLarge?.copyWith(color: cs.onSurface),
                  items: [
                    DropdownMenuItem(
                        value: 'Low',
                        child: Text('Low',
                            style: text.bodyLarge?.copyWith(
                                color: const Color(0xFF64DD17)))), // أخضر
                    DropdownMenuItem(
                        value: 'Medium',
                        child: Text('Medium',
                            style: text.bodyLarge?.copyWith(
                                color: const Color(0xFFFFD700)))), // أصفر
                    DropdownMenuItem(
                        value: 'High',
                        child: Text('High',
                            style: text.bodyLarge?.copyWith(
                                color: const Color(0xFFFF5252)))), // أحمر
                    DropdownMenuItem(
                        value: 'Critical',
                        child: Text('Critical',
                            style: text.bodyLarge?.copyWith(
                                color: const Color(0xFFF06292)))), // وردي
                  ],
                  onChanged: (v) => setState(() => _severity = v ?? 'Low'),
                ),

                const SizedBox(height: 25),

                // زر اختيار الصورة (أصفر وبارز)
                SizedBox(
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image, size: 24),
                    label: Text(
                        _imagePath != null ? "تغيير الصورة" : "اختيار صورة"),
                    style: FilledButton.styleFrom(
                      backgroundColor: cs.primary.withOpacity(0.1),
                      foregroundColor: cs.primary,
                      side: BorderSide(
                          color: cs.primary, width: 1.5), // حدود صفراء
                      elevation: 0,
                    ),
                  ),
                ),

                if (_imagePath != null) ...[
                  const SizedBox(height: 20),
                  // عرض الصورة داخل IndustrialPanel
                  IndustrialPanel(
                    isHighlighted: true,
                    padding: const EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_imagePath!),
                        height: 180,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 30),

                // زر الحفظ الرئيسي
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _saveFault,
                    child: Text(
                        widget.fault == null ? "إضافة رمز خطأ" : "حفظ التعديل"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
