// lib/widgets/industrial_panel.dart
import 'package:flutter/material.dart';

class IndustrialPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool isHighlighted; // لتفعيل الحدود والتوهج الأصفر

  const IndustrialPanel({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 24, // زيادة الانحناء ليطابق تصميم الصورة
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),

        // لون الخلفية: يستخدم لون السطح (surface) الداكن من الثيم
        color: cs.surface,

        // الظلال والإضاءة (لإعطاء العمق المطلوب)
        boxShadow: [
          // 1. الظل الأسود العميق (لإعطاء العمق)
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: const Offset(4, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
          // 2. توهج أصفر إذا كان العنصر مميزاً (Glow)
          if (isHighlighted)
            BoxShadow(
              color: cs.primary.withOpacity(0.25), // 🟡 توهج أصفر نيون
              offset: const Offset(0, 0),
              blurRadius: 18,
              spreadRadius: 2,
            ),
        ],

        // 3. الحدود (Border): حدود صفراء نيون عند التمييز
        border: isHighlighted
            ? Border.all(
                width: 2.0, color: cs.primary) // حدود صفراء صريحة وسميكة
            : Border.all(
                width: 1.0,
                color: Colors.white.withOpacity(0.08)), // حدود خفيفة جداً
      ),
      child: child,
    );
  }
}
