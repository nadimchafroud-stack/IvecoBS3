import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// تأكد من وجود ملف constants.dart
// تأكد من وجود SearchScreen و AdminScreen

import 'search_screen.dart';
import 'admin_screen.dart';

class PinEntryScreen extends StatefulWidget {
  const PinEntryScreen({super.key});

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  final TextEditingController _pinController = TextEditingController();
  String _errorMessage = '';

  void _validatePin() {
    // يمكنك تعديل defaultAdminPin ليصبح ثابتًا في ملف constants.dart
    const String defaultAdminPin = '1234'; // مثال: استخدم الثابت الفعلي لديك

    if (_pinController.text == defaultAdminPin) {
      setState(() => _errorMessage = '');
      // إغلاق لوحة المفاتيح
      FocusScope.of(context).unfocus();
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const AdminScreen()),
      );
    } else {
      setState(() {
        _errorMessage = 'الرمز السري غير صحيح. حاول مرة أخرى.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final text = theme.textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // الخلفية سوداء داكنة
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            // أيقونة الرجوع باللون الأصفر
            icon: Icon(Icons.arrow_back, color: cs.primary),
            onPressed: () {
              // ⭐ تم التصحيح: استخدام pop للعودة للشاشة السابقة (SearchScreen)
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // العنوان بأسلوب الثيم الصناعي
                Text(
                  'أدخل الرمز السري (PIN)',
                  textAlign: TextAlign.center,
                  style: text.displayMedium?.copyWith(
                    color: cs.onSurface,
                    letterSpacing: 1.0,
                  ),
                ),

                const SizedBox(height: 40),

                /// TextField حسب الثيم الصناعي
                Container(
                  // تطبيق نفس أسلوب الخلفية الداكنة للـ IndustrialPanel
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: TextField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    maxLength: 4,
                    // استخدام نفس style الخاص بالـ inputDecorationTheme الموحد
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: '****',
                      counterText: "",
                      // استخدام الخصائص الموحدة من app_theme.dart
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),

                      // تطبيق إطار التركيز الأصفر على الـ TextField نفسه
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: cs.primary, width: 2.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none, // حدود خفيفة
                      ),
                      filled: true,
                      fillColor: cs.surface,
                    ),
                    // ستايل النص يجب أن يكون قوياً
                    style: text.displayMedium?.copyWith(
                      color: cs.primary, // 🟡 اللون الأصفر للرقم السري
                      letterSpacing: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: text.bodyLarge?.copyWith(
                        color: const Color(0xFFF44336), // أحمر قوي
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                const SizedBox(height: 40),

                /// زر تأكيد (سيكون أصفر آلياً بسبب elevatedButtonTheme)
                SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _validatePin,
                    child: const Text('تأكيد'),
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