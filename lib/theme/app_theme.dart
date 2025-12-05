import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 1. تعريف الألوان الأساسية المستخلصة من الصورة
  static const Color industrialYellow =
      Color(0xFFFFD700); // أصفر ناصع (Primary)
  static const Color backgroundBlack = Color(0xFF080808); // خلفية سوداء عميقة
  static const Color surfaceDark =
      Color(0xFF161616); // لون الكروت والأزرار العائمة
  static const Color textWhite = Color(0xFFEEEEEE);
  static const Color textGrey = Color(0xFF9E9E9E);

  static ThemeData get theme {
    final base = ThemeData.dark();

    return base.copyWith(
      useMaterial3: true,

      /// 🎨 مخطط الألوان: التركيز على الأصفر والأسود
      colorScheme: const ColorScheme.dark(
        primary: industrialYellow,
        onPrimary: Colors.black, // النص على الخلفية الصفراء
        secondary: Color(0xFF4DA3FF), // يمكن استخدامه كلون ثانوي هادئ
        surface: surfaceDark,
        onSurface: textWhite,
        background: backgroundBlack,
      ),

      scaffoldBackgroundColor: backgroundBlack,

      /// 🔤 الخطوط: استخدام Oswald للعناوين و Roboto للجسم
      textTheme: base.textTheme.copyWith(
        displayLarge: GoogleFonts.oswald(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: textWhite,
            letterSpacing: 1.2),
        displayMedium: GoogleFonts.oswald(
            fontSize: 26, fontWeight: FontWeight.w600, color: textWhite),
        bodyLarge: GoogleFonts.roboto(
            fontSize: 16, color: textWhite, fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.roboto(fontSize: 14, color: textGrey),
        labelLarge: GoogleFonts.roboto(
            fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black),
      ),

      /// 🟦 AppBar (شفافية كاملة)
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),

      /// 🔘 الأزرار (صفراء ومتباينة)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.8),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          backgroundColor: industrialYellow, // 🟡 لون الزر الأساسي أصفر
          foregroundColor: Colors.black, // لون النص أسود
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // حواف دائرية واضحة
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),

      /// 📝 حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark.withOpacity(0.8), // لون داكن لحقول الإدخال
        hintStyle: TextStyle(color: textGrey.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: industrialYellow, width: 2), // إطار أصفر عند التركيز
        ),
      ),

      /// 🔽 DropDown (متوافق مع التصميم الداكن)
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: const TextStyle(color: textWhite),
        menuStyle: MenuStyle(
          backgroundColor: MaterialStateProperty.all(surfaceDark),
          elevation: MaterialStateProperty.all(8),
        ),
      ),

      // إعدادات الكروت (تستخدم في IndustrialPanel)
      cardTheme: CardTheme(
        color: surfaceDark,
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}

