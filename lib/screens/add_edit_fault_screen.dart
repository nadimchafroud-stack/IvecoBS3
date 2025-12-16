import 'dart:io';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/fault_code.dart';
import '../services/hive_service.dart';
import '../services/image_handler.dart';
import '../widgets/industrial_panel.dart';

class AddEditFaultScreen extends StatefulWidget {
  final FaultCode? fault;
  const AddEditFaultScreen({super.key, this.fault});

  @override
  State<AddEditFaultScreen> createState() => _AddEditFaultScreenState();
}

class _AddEditFaultScreenState extends State<AddEditFaultScreen> {
  final _codeController = TextEditingController();
  final _truckModelController = TextEditingController(); // ❗ يبقى كما هو
  final _descArController = TextEditingController();
  final _descEnController = TextEditingController();
  final _descFrController = TextEditingController();
  final _causesController = TextEditingController();

  String? _imagePath;
  String _severity = 'Low';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> ecuList = [
    'ECU المحرك (Engine Control Unit)',
    'ECU ناقل الحركة (Transmission Control Unit)',
    'ECU نظام الفرامل (ABS / EBS)',
    'ECU نظام التعليق',
    'ECU النظام الكهربائي',
    'ECU نظام الوقود',
    'ECU نظام التبريد',
    'ECU نظام العادم',
    'ECU الهيكل (Body Control Module)',
    'ECU الاتصالات العسكرية',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.fault != null) {
      final f = widget.fault!;
      _codeController.text = f.code;
      _truckModelController.text = f.truckModel; // 👈 نفس الحقل
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

  Widget _field(TextEditingController c, String label, {int max = 1}) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;

    return TextFormField(
      controller: c,
      maxLines: max,
      style: text.bodyLarge?.copyWith(color: cs.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: text.bodyMedium?.copyWith(
          color: cs.onSurface.withOpacity(0.7),
        ),
        filled: true,
        fillColor: cs.surface,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: cs.onSurface.withOpacity(0.1), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 2.5),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (max == 1 && (value == null || value.trim().isEmpty)) {
          return 'هذا الحقل مطلوب';
        }
        return null;
      },
    );
  }

  Future<void> _saveFault() async {
    if (!_formKey.currentState!.validate()) return;

    final fault = FaultCode(
      id: widget.fault?.id ?? const Uuid().v4(),
      code: _codeController.text.trim(),
      truckModel: _truckModelController.text.trim(), // 👈 نفس الاسم
      descAr: _descArController.text.trim(),
      descEn: _descEnController.text.trim(),
      descFr: _descFrController.text.trim(),
      possibleCauses: _causesController.text
          .split('\n')
          .where((e) => e.trim().isNotEmpty)
          .toList(),
      imagePath: _imagePath,
      severity: _severity,
    );

    widget.fault == null
        ? await HiveService.addFaultCode(fault)
        : await HiveService.updateFaultCode(fault);

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
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _field(_codeController, "رمز العطل"),
                const SizedBox(height: 15),

                /// ✅ Dropdown ECU (بديل نوع الشاحنة)
                DropdownButtonFormField<String>(
                  value: _truckModelController.text.isNotEmpty
                      ? _truckModelController.text
                      : null,
                  decoration: InputDecoration(
                    labelText: "لوحة التحكم الإلكترونية (ECU)",
                    filled: true,
                    fillColor: cs.surface,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: cs.onSurface.withOpacity(0.1), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: cs.primary, width: 2.5),
                    ),
                  ),
                  dropdownColor: cs.surface,
                  items: ecuList
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e, style: text.bodyLarge),
                          ))
                      .toList(),
                  onChanged: (v) {
                    _truckModelController.text = v ?? '';
                  },
                  validator: (v) =>
                      v == null || v.isEmpty ? 'هذا الحقل مطلوب' : null,
                ),

                const SizedBox(height: 15),
                _field(_descArController, "الوصف عربي", max: 3),
                const SizedBox(height: 15),
                _field(_descEnController, "الوصف إنجليزي", max: 3),
                const SizedBox(height: 15),
                _field(_descFrController, "الوصف فرنسي", max: 3),
                const SizedBox(height: 15),
                _field(_causesController, "الأسباب (سطر لكل سبب)", max: 5),
                const SizedBox(height: 25),

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
