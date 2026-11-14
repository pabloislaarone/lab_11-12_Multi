// Colores, estilos de texto y tema Cupertino de toda la app.
// Paleta fría: azul marino, azul, cian y turquesa.
import 'package:flutter/cupertino.dart';

class AppColors {
  AppColors._();

  // Marca
  static const Color navy = Color(0xFF0B1E3A);
  static const Color navyLight = Color(0xFF173F73);
  static const Color primary = Color(0xFF2563EB); // azul
  static const Color cyan = Color(0xFF06B6D4);
  static const Color teal = Color(0xFF0D9488);
  static const Color sky = Color(0xFF0EA5E9);
  static const Color indigo = Color(0xFF4F46E5);
  static const Color violet = Color(0xFF7C3AED);
  static const Color slate = Color(0xFF64748B);

  // Fondos
  static const Color background = Color(0xFFEAF0F7);
  static const Color card = Color(0xFFFFFFFF);
  static const Color fill = Color(0xFFE3ECF6);
  static const Color separator = Color(0xFFD9E2EE);

  // Texto
  static const Color label = Color(0xFF0F172A);
  static const Color secondaryLabel = Color(0xFF5B6B80);
  static const Color tertiaryLabel = Color(0xFF9AA8BA);

  // Estados
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  /// Encabezados de cada pantalla
  static const LinearGradient headerGradient = LinearGradient(
    colors: [navy, navyLight, Color(0xFF0E6A86)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Ícono de la app, avatar y botones principales
  static const LinearGradient brandGradient = LinearGradient(
    colors: [cyan, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Degradados de los accesos rápidos del menú
  static const List<LinearGradient> accesos = [
    LinearGradient(
      colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF22D3EE), Color(0xFF0891B2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF2DD4BF), Color(0xFF0F766E)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    LinearGradient(
      colors: [Color(0xFF475569), Color(0xFF1E293B)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];

  /// Color de cada categoría (íconos y etiquetas)
  static Color categoria(String categoria) {
    switch (categoria) {
      case 'Laptops':
        return indigo;
      case 'Celulares':
        return primary;
      case 'Tablets':
        return const Color(0xFF0891B2);
      case 'Audio':
        return violet;
      case 'Wearables':
        return teal;
      case 'Accesorios':
        return sky;
      default:
        return slate;
    }
  }

  /// Color según el stock disponible
  static Color stock(int unidades) {
    if (unidades <= 5) return danger;
    if (unidades <= 12) return warning;
    return success;
  }

  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: navy.withValues(alpha: 0.07),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];
}

/// Estilos de texto basados en la tipografía de iOS
class AppText {
  AppText._();

  static const TextStyle largeTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: AppColors.label,
  );

  static const TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    color: AppColors.label,
  );

  static const TextStyle headline = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.label,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.label,
  );

  static const TextStyle subhead = TextStyle(
    fontSize: 14,
    color: AppColors.secondaryLabel,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.secondaryLabel,
  );

  /// Título de sección (como en Ajustes de iOS)
  static const TextStyle section = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
    color: AppColors.label,
  );

  /// Textos blancos sobre los encabezados oscuros
  static const TextStyle navLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    color: CupertinoColors.white,
  );

  static const TextStyle navTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: CupertinoColors.white,
  );
}

class AppTheme {
  AppTheme._();

  static const CupertinoThemeData light = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    barBackgroundColor: AppColors.navy,
    textTheme: CupertinoTextThemeData(
      primaryColor: AppColors.primary,
      textStyle: AppText.body,
      navLargeTitleTextStyle: AppText.navLarge,
      navTitleTextStyle: AppText.navTitle,
    ),
  );
}
