import 'package:flutter/material.dart';
import '../widgets/industrial_panel.dart'; // استيراد الويدجت الصناعي

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  // ─────────── عنصر صورة (تم تعديله لاستخدام IndustrialPanel) ───────────
  Widget _imageWidget(String path,
      {required double width, required double height, bool isCircle = false}) {
    return IndustrialPanel(
      borderRadius: isCircle ? width / 2 : 12, // دائري للأشخاص، مستطيل للشعارات
      padding: const EdgeInsets.all(4), // حشو بسيط لعمل إطار حول الصورة
      isHighlighted: true, // إعطاء الصور توهجًا خفيفًا
      child: ClipRRect(
        borderRadius: BorderRadius.circular(isCircle ? width / 2 : 8),
        child: Image.asset(
          path,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ─────────── صف الشخص (تم تعديله) ───────────
  Widget _personRow(BuildContext context, String imagePath, String name) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      children: [
        // استخدام isCircle: true لصورة الشخص
        _imageWidget(imagePath, width: 70, height: 70, isCircle: true),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            name,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
        ),
      ],
    );
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
          title: Text("حول التطبيق", style: text.displayMedium), // خط قوي
          centerTitle: true,
        ),

        // زر الرجوع (ElevatedButton بدلاً من FilledButton لاستخدام الثيم الموحد)
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 55, // ارتفاع موحد
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("رجوع"),
            ),
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ─────────── صور الشعارات ───────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _imageWidget('assets/images/tn.jpg', width: 130, height: 90),
                  const SizedBox(width: 25),
                  _imageWidget('assets/images/logo.jpg',
                      width: 130, height: 90),
                ],
              ),

              const SizedBox(height: 30),

              // ─────────── نص المقدمة ───────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IndustrialPanel(
                  padding: const EdgeInsets.all(20),
                  borderRadius: 16,
                  child: Text(
                    "تم إنجاز هذا المشروع في إطار اختتام شهادة مؤهل اختصاص "
                    "عدد 3 ميكانيك السيارات بالمدرسة التقنية لجيش البر "
                    "للسنة التكوينية 2025 - 2026.\n\n"
                    "يهدف هذا العمل إلى توفير مرجع تقني مبسط يساعد "
                    "على فهم أكواد الأعطال الخاصة بالشاحنات نوع Iveco، "
                    "وتسهيل عملية التشخيص لفائدة الفنين والسواق.",
                    textAlign: TextAlign.center,
                    style: text.bodyLarge?.copyWith(
                      height: 1.8,
                      color: cs.onSurface.withOpacity(0.9),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ─────────── الأشخاص المشاركين ───────────
              _personRow(context, 'assets/images/na.jpg',
                  "العريف أول نديم شفرود — تابع للفوج 15"),
              const SizedBox(height: 20),
              _personRow(context, 'assets/images/fi.jpg',
                  "العريف أول فراس البريني — ..."),
              const SizedBox(height: 20),
              _personRow(context, 'assets/images/ka.jpg',
                  "العريف أول قاسم بالحاج براهيم — ..."),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
