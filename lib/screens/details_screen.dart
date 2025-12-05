import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/fault_code.dart';
import '../widgets/industrial_panel.dart'; // استيراد الويدجت الصناعي

class DetailsScreen extends StatefulWidget {
  final FaultCode fault;

  const DetailsScreen({super.key, required this.fault});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String currentLang = 'ar'; // ar, en, fr

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;

    String getDescription() {
      switch (currentLang) {
        case 'en':
          return widget.fault.descEn;
        case 'fr':
          return widget.fault.descFr;
        default:
          return widget.fault.descAr;
      }
    }

    // تم تعديل الألوان لتكون أكثر تباينًا ووضوحًا على الخلفية الداكنة
    Color severityColor(String severity) {
      switch (severity) {
        case 'Low':
          return const Color(0xFF1B5E20).withOpacity(0.5); // أخضر داكن
        case 'Medium':
          return const Color(0xFFFFC107).withOpacity(0.2); // أصفر باهت
        case 'High':
          return const Color(0xFFD32F2F).withOpacity(0.25); // أحمر داكن
        case 'Critical':
          return const Color(0xFF880E4F).withOpacity(0.4); // بنفسجي داكن
        default:
          return cs.surface.withOpacity(0.5);
      }
    }

    // لون النص حسب درجة الخطورة
    Color severityTextColor(String severity) {
      switch (severity) {
        case 'Low':
          return const Color(0xFF64DD17); // أخضر نيون
        case 'Medium':
          return cs.primary; // 🟡 اللون الأصفر الأساسي
        case 'High':
          return const Color(0xFFFF5252); // أحمر ساطع
        case 'Critical':
          return const Color(0xFFF06292); // وردي
        default:
          return text.bodyMedium!.color!;
      }
    }

    IconData severityIcon(String severity) {
      switch (severity) {
        case 'Low':
          return Icons.info_outline;
        case 'Medium':
          return Icons.warning_amber;
        case 'High':
          return Icons.error_outline;
        case 'Critical':
          return Icons.dangerous;
        default:
          return Icons.help_outline;
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: cs.primary), // أيقونة صفراء
            onPressed: () => Navigator.pop(context),
          ),
          title: Text("تفاصيل العطل", style: text.displayMedium), // خط قوي
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              /// ======= بطاقة الكود والموديل (IndustrialPanel) =======
              IndustrialPanel(
                isHighlighted: true, // إبراز هذه البطاقة بالحدود الصفراء
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      // خلفية الكود حسب الخطورة (ألوان داكنة)
                      decoration: BoxDecoration(
                        color: severityColor(widget.fault.severity),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: severityTextColor(widget.fault.severity),
                            width: 1.5), // حدود بلون الخطورة
                      ),
                      child: Text(
                        widget.fault.code,
                        textAlign: TextAlign.center,
                        style: text.displayLarge?.copyWith(
                          color: severityTextColor(widget.fault.severity),
                          fontSize: 36,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.fault.truckModel,
                      style: text.displayMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          severityIcon(widget.fault.severity),
                          color: severityTextColor(
                              widget.fault.severity), // لون الأيقونة
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "درجة الخطورة: ${widget.fault.severity}",
                          style: text.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: severityTextColor(
                                widget.fault.severity), // لون النص
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ======= اختيار اللغة =======
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LanguageButton(
                      lang: 'ar',
                      currentLang: currentLang,
                      onPressed: () => setState(() => currentLang = 'ar')),
                  const SizedBox(width: 12),
                  _LanguageButton(
                      lang: 'fr',
                      currentLang: currentLang,
                      onPressed: () => setState(() => currentLang = 'fr')),
                  const SizedBox(width: 12),
                  _LanguageButton(
                      lang: 'en',
                      currentLang: currentLang,
                      onPressed: () => setState(() => currentLang = 'en')),
                ],
              ),

              const SizedBox(height: 16),

              /// ======= الوصف (IndustrialPanel) =======
              IndustrialPanel(
                borderRadius: 16,
                padding: const EdgeInsets.all(20),
                child: Text(
                  getDescription(),
                  textAlign: TextAlign.right,
                  style: text.bodyLarge?.copyWith(
                    color: text.bodyLarge?.color?.withOpacity(0.9),
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// ======= الأسباب المحتملة (عنوان) =======
              Padding(
                padding: const EdgeInsets.only(right: 5, bottom: 8),
                child: Text(
                  "الأسباب المحتملة:",
                  style: text.displayMedium?.copyWith(
                    color: cs.primary, // 🟡 عنوان أصفر
                    fontSize: 22,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// ======= قائمة الأسباب (IndustrialPanel داخل ListTile) =======
              ...widget.fault.possibleCauses.map(
                (cause) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: IndustrialPanel(
                    borderRadius: 12,
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(
                        Icons.warning_amber,
                        color: cs.primary.withOpacity(0.8), // أيقونة صفراء
                      ),
                      title: Text(
                        cause,
                        style: text.bodyMedium?.copyWith(
                            color: cs.onSurface, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// ======= صورة العطل (IndustrialPanel) =======
              if (widget.fault.imagePath != null &&
                  widget.fault.imagePath!.isNotEmpty)
                IndustrialPanel(
                  borderRadius: 16,
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(widget.fault.imagePath!),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ويدجت إضافي لتحسين مظهر أزرار اللغة
class _LanguageButton extends StatelessWidget {
  final String lang;
  final String currentLang;
  final VoidCallback onPressed;

  const _LanguageButton({
    required this.lang,
    required this.currentLang,
    required this.onPressed,
  });

  // تعيين مسار العلم المناسب
  String get flagAsset {
    switch (lang) {
      case 'ar':
        return 'assets/flags/tn.svg'; // يمكنك استبدالها بعلم بلد عربي آخر
      case 'fr':
        return 'assets/flags/fr.svg';
      case 'en':
        return 'assets/flags/us.svg';
      default:
        return 'assets/flags/us.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isSelected = lang == currentLang;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // حدود صفراء للتحديد
        border: Border.all(
          color: isSelected ? cs.primary : Colors.transparent,
          width: isSelected ? 2.5 : 0,
        ),
        // توهج خفيف عند التحديد
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: cs.primary.withOpacity(0.3),
                  blurRadius: 5,
                  spreadRadius: 1,
                )
              ]
            : null,
      ),
      child: IconButton(
        onPressed: onPressed,
        padding: const EdgeInsets.all(8),
        icon: SvgPicture.asset(
          flagAsset,
          width: 36,
          height: 36,
        ),
      ),
    );
  }
}
